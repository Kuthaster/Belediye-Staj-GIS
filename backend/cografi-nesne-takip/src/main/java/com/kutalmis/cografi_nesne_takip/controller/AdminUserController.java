package com.kutalmis.cografi_nesne_takip.controller;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kutalmis.cografi_nesne_takip.Dto.UserCreateDTO;
import com.kutalmis.cografi_nesne_takip.Dto.UserResponseDTO;
import com.kutalmis.cografi_nesne_takip.Dto.UserUpdateDTO;
import com.kutalmis.cografi_nesne_takip.service.UserService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/admin/users")
@PreAuthorize("hasRole('ADMIN')")
public class AdminUserController {

    private final UserService userService;

    public AdminUserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public List<UserResponseDTO> getAllUsers() {
        return userService.getAllUsers();
    }

    @PostMapping
    public UserResponseDTO createUser(@RequestBody UserCreateDTO dto) {
        return userService.createUser(dto);
    }

    @PutMapping("/{id}")
    public UserResponseDTO updateUser(@PathVariable Long id, @Valid @RequestBody UserUpdateDTO dto) {
        return userService.updateUser(id, dto);
    }

    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
    }

}