package com.kutalmis.cografi_nesne_takip.exception;

public class RequiredFieldMissingException extends RuntimeException {
    public RequiredFieldMissingException(String fieldName) {
        super("Gerekli alan boş: " + fieldName);
    }
}