package com.kutalmis.cografi_nesne_takip.Dto;

import jakarta.validation.constraints.NotBlank;

public record LoginRequestDTO(
        @NotBlank(message = "E-posta boş olamaz.") String email,

        @NotBlank(message = "Şifre boş olamaz.") String password) {
}