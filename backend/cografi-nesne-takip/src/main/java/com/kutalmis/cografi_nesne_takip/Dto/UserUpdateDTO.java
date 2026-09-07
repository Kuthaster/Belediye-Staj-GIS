package com.kutalmis.cografi_nesne_takip.Dto;

import com.kutalmis.cografi_nesne_takip.entity.Role;

public record UserUpdateDTO(
                String name,
                String email,
                Role role) {
}
