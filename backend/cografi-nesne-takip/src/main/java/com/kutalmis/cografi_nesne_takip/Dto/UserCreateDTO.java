package com.kutalmis.cografi_nesne_takip.Dto;

import com.kutalmis.cografi_nesne_takip.entity.Role;

public record UserCreateDTO(
                String name,
                String email,
                String rawPassword,
                Role role) {
}