package com.kutalmis.cografi_nesne_takip.entity;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;

@Entity
@Table(name = "playground_equipment")
@DiscriminatorValue("PL AYGROUND_EQUIPMENT")
public class PlaygroundEquipment extends UrbanObject {
    @Enumerated(EnumType.STRING)
    @Column(name = "equipment_type")
    private EquipmentType equipmentType;

    @Enumerated(EnumType.STRING)
    @Column(name = "age_group")
    private AgeGroup ageGroup;

    @Column(name = "safety_certification_date")
    private LocalDate safetyCertificationDate;

    public EquipmentType getEquipmentType() {
        return equipmentType;
    }

    public void setEquipmentType(EquipmentType equipmentType) {
        this.equipmentType = equipmentType;
    }

    public AgeGroup getAgeGroup() {
        return ageGroup;
    }

    public void setAgeGroup(AgeGroup ageGroup) {
        this.ageGroup = ageGroup;
    }

    public LocalDate getSafetyCertificationDate() {
        return safetyCertificationDate;
    }

    public void setSafetyCertificationDate(LocalDate safetyCertificationDate) {
        this.safetyCertificationDate = safetyCertificationDate;
    }

}
