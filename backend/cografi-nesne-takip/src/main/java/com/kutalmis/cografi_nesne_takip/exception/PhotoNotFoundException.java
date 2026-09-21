package com.kutalmis.cografi_nesne_takip.exception;

public class PhotoNotFoundException extends RuntimeException {
    public PhotoNotFoundException(Long objectId) {
        super("Bu cisim için fotoğraf bulunamadı: " + objectId);
    }
}