package com.kutalmis.cografi_nesne_takip.entity;

public enum BinType {
    GENERAL("Genel"),
    RECYCLING("Geri Dönüşüm"),
    ORGANIC("Organik");

    private final String displayName;

    BinType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}