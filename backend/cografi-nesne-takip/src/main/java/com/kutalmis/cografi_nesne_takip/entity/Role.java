package com.kutalmis.cografi_nesne_takip.entity;

public enum Role {
    ADMIN("Admin"),
    VIEWER("Görüntüleyici"),
    FIELD_WORKER("Saha Görevlisi"),
    FIELD_SUPERVISOR("Saha Sorumlusu");

    private final String displayName;

    Role(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

}