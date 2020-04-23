use std::os::raw::{c_char};
use std::ffi::{CString, CStr};
use bip39::{Language, Mnemonic, MnemonicType};
use ethsign::{keyfile::Crypto, Protected};
use rustc_hex::{FromHex, ToHex, FromHexError};

mod sr25519;

const CRYPTO_ITERATIONS: u32 = 10240;

fn get_str(rust_ptr: *const c_char) -> String {
    let c_str = unsafe { CStr::from_ptr(rust_ptr) };
    let result_string = match c_str.to_str() {
        Err(_) => "",
        Ok(string) => string,
    };
    return String::from(result_string)
}

fn get_ptr(rust_string: &str) -> *mut c_char {
    CString::new(rust_string).unwrap().into_raw()
}

#[no_mangle]
pub extern fn rust_greeting(to: *const c_char) -> *mut c_char {
    get_ptr(&get_str(to))
}

#[no_mangle]
pub extern fn rust_cstr_free(s: *mut c_char) {
    unsafe {
        if s.is_null() { return }
        CString::from_raw(s)
    };
}

#[no_mangle]
pub extern fn random_phrase(
    words_number:u32
) -> *mut c_char {
    let mnemonic_type = match MnemonicType::for_word_count(words_number as usize) {
        Ok(t) => t,
        Err(_e) => MnemonicType::Words24,
    };
    let mnemonic = Mnemonic::new(mnemonic_type, Language::English);

    get_ptr(&mnemonic.into_phrase())
}

#[no_mangle]
pub extern fn encrypt_data(
    data:  *const c_char,
    password:  *const c_char
) -> *mut c_char {
    let password = Protected::new(get_str(password).into_bytes());
    let result_crypto = Crypto::encrypt(&get_str(data).as_bytes(), &password, CRYPTO_ITERATIONS);
    let crypto: Crypto = match result_crypto {
        Ok(c) => c,
        _ => return get_ptr("")
    };
    let rust_string = serde_json::to_string(&crypto);
    let cipher_text = match rust_string {
        Ok(c) => c,
        _ => String::from("")
    };
    get_ptr(&cipher_text)
}

#[no_mangle]
pub extern fn decrypt_data(
    data: *const c_char,
    password: *const c_char,
) -> *mut c_char {
    let password = Protected::new(get_str(password).into_bytes());

    let result_crypto = serde_json::from_str(&get_str(data));
    let crypto: Crypto = match result_crypto {
        Ok(c) => c,
        _ => return get_ptr("")
    };
    let decrypted_result = crypto.decrypt(&password);
    let decrypted = match decrypted_result {
        Ok(c) => c,
        _ => return get_ptr("")
    };
    let rust_string = String::from_utf8(decrypted);
    let result_string = match rust_string {
        Ok(string) => string,
        _ => String::from("")
    };
    get_ptr(&result_string)
}

#[no_mangle]
pub extern fn substrate_address(
    suri: *const c_char,
    prefix: u8
) -> *mut c_char {
    let keypair_option = sr25519::KeyPair::from_suri(&get_str(suri));
    let keypair = match keypair_option {
        Some(c) => c,
        _ => return get_ptr("")
    };

    let rust_string = keypair.ss58_address(prefix);
    get_ptr(&rust_string)
}

#[no_mangle]
pub extern fn substrate_sign(
    suri: *const c_char,
    text: *const c_char
) -> *mut c_char {
    let keypair_option = sr25519::KeyPair::from_suri(&get_str(suri));
    let keypair = match keypair_option {
        Some(c) => c,
        _ => return get_ptr("")
    };
    let message_result: Result<Vec<u8>, FromHexError> = (&get_str(text)).from_hex();
    let message: Vec<u8> = match message_result {
        Ok(c) => c,
        _ => return get_ptr("")
    };
    let signature = keypair.sign(&message);
    let result: String = signature.to_hex();
    CString::new(result).unwrap().into_raw()
}

#[no_mangle]
pub extern fn schnorrkel_verify(
    suri: *const c_char,
    message: *const c_char,
    signature: *const c_char
) -> bool {
    let keypair_option = sr25519::KeyPair::from_suri(&get_str(suri));
    let keypair = match keypair_option {
        Some(c) => c,
        _ => return false
    };
    let message_result: Result<Vec<u8>, FromHexError> = get_str(message).from_hex();
    let original_message = match message_result {
        Ok(c) => c,
        _ => return false
    };
    let signature_result: Result<Vec<u8>, FromHexError> = get_str(signature).from_hex();
    let original_signature = match signature_result {
        Ok(c) => c,
        _ => return false
    };
    return match keypair.verify_signature(&original_message, &original_signature) {
        Some(result)=> result,
        _ => false
    }
}
