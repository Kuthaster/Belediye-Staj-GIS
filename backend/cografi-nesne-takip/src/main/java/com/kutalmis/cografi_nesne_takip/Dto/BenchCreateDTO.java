package com.kutalmis.cografi_nesne_takip.Dto;

public record BenchCreateDTO(Double latitude, Double longitude, Integer seatCount, String material,
        Boolean hasBackrest) {
}