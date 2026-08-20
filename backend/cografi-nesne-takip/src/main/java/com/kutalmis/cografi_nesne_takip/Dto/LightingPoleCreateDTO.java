package com.kutalmis.cografi_nesne_takip.Dto;

import com.kutalmis.cografi_nesne_takip.entity.LightType;
import com.kutalmis.cografi_nesne_takip.entity.PowerSource;

public record LightingPoleCreateDTO(Double latitude, Double longitude, Integer wattage, Double heightM,
        LightType lightType, PowerSource powerSource) {
}
