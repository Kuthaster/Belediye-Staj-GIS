package com.kutalmis.cografi_nesne_takip.Dto;

import com.kutalmis.cografi_nesne_takip.entity.LightType;
import com.kutalmis.cografi_nesne_takip.entity.PowerSource;

import jakarta.validation.constraints.NotNull;

public record LightingPoleCreateDTO(@NotNull Double latitude, @NotNull Double longitude, Integer wattage,
                Double heightM,
                @NotNull LightType lightType, @NotNull PowerSource powerSource) {
}
