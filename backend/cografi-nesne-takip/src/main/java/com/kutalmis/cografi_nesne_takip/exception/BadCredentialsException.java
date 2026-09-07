
package com.kutalmis.cografi_nesne_takip.exception;

public class BadCredentialsException extends RuntimeException {
    public BadCredentialsException() {
        super("E posta veya şifre hatalı");
    }
}
