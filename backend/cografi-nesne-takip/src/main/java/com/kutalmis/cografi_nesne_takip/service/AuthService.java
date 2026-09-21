package com.kutalmis.cografi_nesne_takip.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Service;

import com.kutalmis.cografi_nesne_takip.Dto.LoginRequestDTO;
import com.kutalmis.cografi_nesne_takip.Dto.LoginResponseDTO;
import com.kutalmis.cografi_nesne_takip.entity.User;
import com.kutalmis.cografi_nesne_takip.security.JwtService;

@Service
public class AuthService {

    private static final Logger log = LoggerFactory.getLogger(AuthService.class);

    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final UserService userService;

    public AuthService(AuthenticationManager authenticationManager, JwtService jwtService, UserService userService) {
        this.authenticationManager = authenticationManager;
        this.jwtService = jwtService;
        this.userService = userService;
    }

    public LoginResponseDTO login(LoginRequestDTO dto) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(dto.email(), dto.password()));

        User user = userService.getUserEntityByEmail(dto.email());

        log.debug("User {} authenticated with role {}", user.getEmail(), user.getRole());

        String token = jwtService.generateToken(user.getEmail(), user.getRole().name());

        return new LoginResponseDTO(
                token,
                "Bearer",
                user.getId(),
                user.getEmail(),
                user.getRole());
    }
}