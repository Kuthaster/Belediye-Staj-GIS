package com.kutalmis.cografi_nesne_takip.Dto;

import java.time.LocalDateTime;

import com.kutalmis.cografi_nesne_takip.entity.ObjectStatus;

public record UrbanObjectSummaryDTO(
        Long id,
        com.kutalmis.cografi_nesne_takip.entity.ObjectType type,
        double latitude,
        double longitude,
        ObjectStatus status,
        LocalDateTime createdAt,
        LocalDateTime updatedAt) {
}