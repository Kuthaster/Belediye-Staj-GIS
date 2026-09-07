package com.kutalmis.cografi_nesne_takip.Dto;

import com.kutalmis.cografi_nesne_takip.entity.Role;

public record UserResponseDTO(
        Long id,
        String name,
        String email,
        String roleDisplayName,
        Role role,
        Boolean mustChangePassword) {
}