package com.kutalmis.cografi_nesne_takip.Dto;

import java.time.LocalDate;

import jakarta.validation.constraints.NotNull;

public record TreeCreateDTO(@NotNull Double latitude, @NotNull Double longitude, String species, Double trunkDiameterCm,
        LocalDate plantingDate, Double heightM, String healthStatus) {
}
