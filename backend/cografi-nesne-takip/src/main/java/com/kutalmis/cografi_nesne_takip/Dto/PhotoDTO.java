package com.kutalmis.cografi_nesne_takip.Dto;

import java.time.LocalDateTime;

public record PhotoDTO(
        Long objectId,
        String photoUrl,
        boolean hasPrevious,
        LocalDateTime uploadedAt) {
}