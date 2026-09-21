package com.kutalmis.cografi_nesne_takip.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kutalmis.cografi_nesne_takip.Dto.LoginRequestDTO;
import com.kutalmis.cografi_nesne_takip.Dto.LoginResponseDTO;
import com.kutalmis.cografi_nesne_takip.service.AuthService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public LoginResponseDTO login(@Valid @RequestBody LoginRequestDTO dto) {
        return authService.login(dto);
    }
}