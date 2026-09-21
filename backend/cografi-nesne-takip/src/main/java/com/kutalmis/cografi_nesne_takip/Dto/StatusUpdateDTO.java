package com.kutalmis.cografi_nesne_takip.Dto;

import com.kutalmis.cografi_nesne_takip.entity.ObjectStatus;

import jakarta.validation.constraints.NotNull;

public record StatusUpdateDTO(@NotNull ObjectStatus status, String reason) {

}
