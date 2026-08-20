package com.kutalmis.cografi_nesne_takip.entity;

public enum ObjectType {
    TRASH_BIN("Çöp Kutusu"),
    BENCH("Bank"),
    TREE("Ağaç"),
    LIGHTING_POLE("Aydınlatma Direği"),
    PLAYGROUND_EQUIPMENT("Oyun Alanı Ekipmanı");

    private final String displayName;

    ObjectType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}