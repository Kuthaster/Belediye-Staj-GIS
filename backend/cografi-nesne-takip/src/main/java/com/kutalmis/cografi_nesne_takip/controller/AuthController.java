package com.kutalmis.cografi_nesne_takip.controller;

import com.kutalmis.cografi_nesne_takip.Dto.LoginRequestDTO;
import com.kutalmis.cografi_nesne_takip.Dto.LoginResponseDTO;
import com.kutalmis.cografi_nesne_takip.entity.User;
import com.kutalmis.cografi_nesne_takip.security.JwtService;
import com.kutalmis.cografi_nesne_takip.service.UserService;
import jakarta.validation.Valid;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final UserService userService;

    public AuthController(AuthenticationManager authenticationManager, JwtService jwtService, UserService userService) {
        this.authenticationManager = authenticationManager;
        this.jwtService = jwtService;
        this.userService = userService;
    }

    @PostMapping("/login")
    public LoginResponseDTO login(@Valid @RequestBody LoginRequestDTO dto) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        dto.email(),
                        dto.password()));

        System.out.println("Authentication successful");

        User user = userService.getUserEntityByEmail(dto.email());

        System.out.println("User found: " + user.getEmail());
        System.out.println("User role: " + user.getRole());

        String token = jwtService.generateToken(
                user.getEmail(),
                user.getRole().name());

        System.out.println("Token generated");

        user.getEmail();
        user.getRole().name();

        return new LoginResponseDTO(
                token,
                "Bearer",
                user.getId(),
                user.getEmail(),
                user.getRole());
    }
}