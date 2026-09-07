package com.kutalmis.cografi_nesne_takip.Dto;

import jakarta.validation.constraints.NotNull;

public record ChangePasswordDTO(
        @NotNull(message = "Şuanki şifre null") String currentPassword,
        @NotNull(message = "yeni şifre null") String newPassword) {
}
