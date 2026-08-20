package com.kutalmis.cografi_nesne_takip.Dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

import com.kutalmis.cografi_nesne_takip.entity.AgeGroup;
import com.kutalmis.cografi_nesne_takip.entity.EquipmentType;
import com.kutalmis.cografi_nesne_takip.entity.ObjectStatus;
import com.kutalmis.cografi_nesne_takip.entity.ObjectType;

public record PlaygroundEquipmentDTO(
        Long id, ObjectType type, double latitude, double longitude, ObjectStatus status,
        LocalDateTime createdAt, LocalDateTime updatedAt,
        EquipmentType equipmentType, AgeGroup ageGroup, LocalDate safetyCertificationDate) {
}