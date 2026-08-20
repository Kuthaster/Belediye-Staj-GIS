package com.kutalmis.cografi_nesne_takip.Dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

import com.kutalmis.cografi_nesne_takip.entity.ObjectStatus;
import com.kutalmis.cografi_nesne_takip.entity.ObjectType;

public record TreeDTO(
        Long id, ObjectType type, double latitude, double longitude, ObjectStatus status,
        LocalDateTime createdAt, LocalDateTime updatedAt,
        String species, LocalDate plantingDate, Double trunkDiameterCm, Double heightM, String healthStatus) {
}