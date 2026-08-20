package com.kutalmis.cografi_nesne_takip.Dto;

import java.time.LocalDate;

import com.kutalmis.cografi_nesne_takip.entity.AgeGroup;
import com.kutalmis.cografi_nesne_takip.entity.EquipmentType;

public record PlaygroundEquipmentCreateDTO(Double latitude, Double longitude, EquipmentType equipmentType,
        AgeGroup ageGroup, LocalDate safetyCertificationDate) {
}
