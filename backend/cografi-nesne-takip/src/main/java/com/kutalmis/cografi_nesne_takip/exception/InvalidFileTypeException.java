package com.kutalmis.cografi_nesne_takip.exception;

public class InvalidFileTypeException extends RuntimeException {
    public InvalidFileTypeException(String contentType) {
        super("Desteklenmeyen dosya türü: " + (contentType != null ? contentType : "bilinmiyor"));
    }
}