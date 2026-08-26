package com.kutalmis.cografi_nesne_takip.Dto;

import java.time.LocalDate;

import com.kutalmis.cografi_nesne_takip.entity.AgeGroup;
import com.kutalmis.cografi_nesne_takip.entity.EquipmentType;

import jakarta.validation.constraints.NotNull;

public record PlaygroundEquipmentCreateDTO(@NotNull Double latitude, @NotNull Double longitude,
                @NotNull EquipmentType equipmentType,
                AgeGroup ageGroup, LocalDate safetyCertificationDate) {
}
