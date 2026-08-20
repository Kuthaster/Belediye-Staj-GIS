package com.kutalmis.cografi_nesne_takip.exception;

import com.kutalmis.cografi_nesne_takip.entity.ObjectType;

public class WrongObjectTypeException extends RuntimeException {
    public WrongObjectTypeException(Long id, ObjectType expected, ObjectType actual) {
        super("Cisim " + id + " " + expected.getDisplayName() + "türünde olmalı ancak cismin türü."
                + actual.getDisplayName());
    }
}