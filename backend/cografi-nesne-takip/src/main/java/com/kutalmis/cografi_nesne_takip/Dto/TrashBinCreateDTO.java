package com.kutalmis.cografi_nesne_takip.Dto;

import com.kutalmis.cografi_nesne_takip.entity.BinType;

import jakarta.validation.constraints.NotNull;

public record TrashBinCreateDTO(@NotNull Double latitude, @NotNull Double longitude, Double volumeLiters,
                @NotNull BinType binType,
                String material, Integer collectionFrequencyDays) {

}
