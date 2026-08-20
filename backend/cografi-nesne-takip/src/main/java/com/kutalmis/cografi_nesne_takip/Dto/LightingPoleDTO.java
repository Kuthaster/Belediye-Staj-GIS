package com.kutalmis.cografi_nesne_takip.Dto;

import java.time.LocalDateTime;

import com.kutalmis.cografi_nesne_takip.entity.LightType;
import com.kutalmis.cografi_nesne_takip.entity.ObjectStatus;
import com.kutalmis.cografi_nesne_takip.entity.ObjectType;
import com.kutalmis.cografi_nesne_takip.entity.PowerSource;

public record LightingPoleDTO(
        Long id, ObjectType type, double latitude, double longitude, ObjectStatus status,
        LocalDateTime createdAt, LocalDateTime updatedAt,
        Integer wattage, Double heightM, LightType lightType, PowerSource powerSource) {
}
