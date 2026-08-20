package com.kutalmis.cografi_nesne_takip.entity;

public enum PowerSource {
    GRID("Şebeke"),
    SOLAR("Güneş Paneli");

    private final String displayName;

    PowerSource(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}