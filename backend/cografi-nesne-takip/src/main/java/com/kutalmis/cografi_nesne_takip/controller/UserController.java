package com.kutalmis.cografi_nesne_takip.controller;

import java.security.Principal;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kutalmis.cografi_nesne_takip.Dto.ChangePasswordDTO;
import com.kutalmis.cografi_nesne_takip.Dto.UserResponseDTO;
import com.kutalmis.cografi_nesne_takip.entity.User;
import com.kutalmis.cografi_nesne_takip.service.UserService;

import jakarta.validation.Valid;

@PreAuthorize("isAuthenticated()")
@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/profile")
    public UserResponseDTO getMyProfile(Principal principal) {
        String email = principal.getName();
        return userService.getUserProfileByEmail(email);
    }

    @PatchMapping("/profile/password")
    public void changePassword(Principal principal, @Valid @RequestBody ChangePasswordDTO dto) {

        User caller = userService.getUserEntityByEmail(principal.getName());

        userService.changePassword(caller, dto);
    }

}