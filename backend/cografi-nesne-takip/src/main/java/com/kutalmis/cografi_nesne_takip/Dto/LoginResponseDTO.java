package com.kutalmis.cografi_nesne_takip.Dto;

import com.kutalmis.cografi_nesne_takip.entity.Role;

public record LoginResponseDTO(
                String token,
                String tokenType,
                Long userId,
                String email,
                Role role) {
}