package com.kutalmis.cografi_nesne_takip.entity;

public enum AgeGroup {
    PRESCHOOL("Okul Öncesi"), // 0-7
    ELEMENTARY("İlköğretim Çağı"), // 7-14
    ALL_AGES("Her Yaş");

    private final String displayName;

    AgeGroup(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}