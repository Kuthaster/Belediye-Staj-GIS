package com.kutalmis.cografi_nesne_takip.Dto;

import jakarta.validation.constraints.NotNull;

public record BenchCreateDTO(@NotNull Double latitude, @NotNull Double longitude, @NotNull Integer seatCount,
                String material,
                @NotNull Boolean hasBackrest) {
}