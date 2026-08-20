package com.kutalmis.cografi_nesne_takip.exception;

public class ObjectNotFoundException extends RuntimeException {
    public ObjectNotFoundException(Long id) {
        super(id + " ID'li nesne bulunamadı.");
    }
}