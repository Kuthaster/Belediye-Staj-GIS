package com.kutalmis.cografi_nesne_takip.entity;

public enum EquipmentType {
    SWING("Salıncak"),
    SLIDE("Kaydırak"),
    TEETER_TOTTER("Tahtarevalli"),
    SPINNER("Dönen Oyun Elemanı"),
    CLIMBER("Tırmanma Elemanı");

    private final String displayName;

    EquipmentType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
