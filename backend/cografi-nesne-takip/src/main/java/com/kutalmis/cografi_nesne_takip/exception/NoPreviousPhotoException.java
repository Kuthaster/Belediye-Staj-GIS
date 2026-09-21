package com.kutalmis.cografi_nesne_takip.exception;

public class NoPreviousPhotoException extends RuntimeException {
    public NoPreviousPhotoException(Long objectId) {
        super("Geri alınacak önceki fotoğraf yok: " + objectId);
    }
}