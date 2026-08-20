package com.kutalmis.cografi_nesne_takip.Dto;

import java.time.LocalDateTime;

import com.kutalmis.cografi_nesne_takip.entity.BinType;
import com.kutalmis.cografi_nesne_takip.entity.ObjectStatus;
import com.kutalmis.cografi_nesne_takip.entity.ObjectType;

public record TrashBinDTO(
        Long id, ObjectType type, double latitude, double longitude,
        ObjectStatus status,
        LocalDateTime createdAt, LocalDateTime updatedAt,
        Double volumeLiters, BinType binType, String material, Integer collectionFrequencyDays) {
}