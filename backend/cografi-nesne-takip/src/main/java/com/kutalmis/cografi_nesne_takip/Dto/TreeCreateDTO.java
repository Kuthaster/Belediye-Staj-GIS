package com.kutalmis.cografi_nesne_takip.Dto;

import java.time.LocalDate;

public record TreeCreateDTO(Double latitude, Double longitude, String species, Double trunkDiameterCm,
        LocalDate plantingDate, Double heightM, String healtStatus) {
}
