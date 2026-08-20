package com.kutalmis.cografi_nesne_takip.Dto;

import com.kutalmis.cografi_nesne_takip.entity.BinType;

public record TrashBinCreateDTO(Double latitude, Double longitude, Double volumeLiters, BinType binType,
        String material, Integer collectionFrequencyDays) {

}
