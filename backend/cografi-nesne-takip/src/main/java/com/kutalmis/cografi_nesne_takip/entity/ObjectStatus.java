package com.kutalmis.cografi_nesne_takip.entity;

public enum ObjectStatus {
    ACTIVE("Aktif"),
    NEEDS_MAINTENANCE("Bakım Gerekli"),
    BROKEN("Kırık"),
    REMOVED("Kaldırıldı");

    private final String displayName;

    ObjectStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}