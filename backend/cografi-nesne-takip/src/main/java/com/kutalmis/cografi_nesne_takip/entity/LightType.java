package com.kutalmis.cografi_nesne_takip.entity;

public enum LightType {
    LED("Led"),
    SODIUM("Sodyum");

    private final String displayName;

    LightType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}