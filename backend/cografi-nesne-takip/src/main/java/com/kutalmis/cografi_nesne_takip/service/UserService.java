package com.kutalmis.cografi_nesne_takip.service;

import java.util.List;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kutalmis.cografi_nesne_takip.Dto.ChangePasswordDTO;
import com.kutalmis.cografi_nesne_takip.Dto.UserCreateDTO;
import com.kutalmis.cografi_nesne_takip.Dto.UserResponseDTO;
import com.kutalmis.cografi_nesne_takip.Dto.UserUpdateDTO;
import com.kutalmis.cografi_nesne_takip.entity.Role;
import com.kutalmis.cografi_nesne_takip.entity.User;
import com.kutalmis.cografi_nesne_takip.repository.UserRepository;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public List<UserResponseDTO> getAllUsers() {
        return userRepository.findAll()
                .stream()
                .map(this::mapperResponseDTO)
                .toList();
    }

    public UserResponseDTO getUserProfileByEmail(String email) {
        User user = getUserEntityByEmail(email);
        return mapperResponseDTO(user);
    }

    public User getUserEntityByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException(email + " E-postasına sahip kullanıcı bulunamadı"));
    }

    @Transactional
    public UserResponseDTO createUser(UserCreateDTO dto) {

        User user = new User();
        user.setName(dto.name());
        user.setEmail(dto.email());
        user.setPasswordHash(passwordEncoder.encode(dto.rawPassword()));
        user.setRole(dto.role());

        User savedUser = userRepository.save(user);
        return mapperResponseDTO(savedUser);
    }

    private UserResponseDTO mapperResponseDTO(User user) {
        return new UserResponseDTO(
                user.getId(),
                user.getName(),
                user.getEmail(),
                user.getRole().getDisplayName(),
                user.getRole(),
                user.getMustChangePassword());
    }

    @Transactional
    public UserResponseDTO updateUser(Long userId, UserUpdateDTO dto) {
        User user = userByIdCheck(userId);

        Role role = user.getRole();

        if (dto.name() != null && !(dto.name().isBlank())) {
            user.setName(dto.name());
        }
        if (dto.email() != null && !(dto.email().isBlank())) {
            user.setEmail(dto.email());
        }
        user.setRole(role);

        User saved = userRepository.save(user);
        return mapperResponseDTO(saved);
    }

    @Transactional
    public void changePassword(User caller, ChangePasswordDTO dto) {

        if (!passwordEncoder.matches(dto.currentPassword(), caller.getPasswordHash())) {
            throw new IllegalArgumentException("Mevcut şifre yanlış.");
        }

        if (dto.newPassword() == null || dto.newPassword().isBlank()) {
            throw new IllegalArgumentException("Yeni şifre boş olamaz.");
        }

        if (passwordEncoder.matches(dto.newPassword(), caller.getPasswordHash())) {
            throw new IllegalArgumentException("Yeni şifre mevcut şifreyle aynı olamaz.");
        }

        if (dto.newPassword() == null || dto.newPassword().length() < 8) {
            throw new IllegalArgumentException("Yeni şifre en az 8 karakter olmalı.");
        }

        caller.setPasswordHash(passwordEncoder.encode(dto.newPassword()));
        caller.setMustChangePassword(false);

        userRepository.save(caller);
    }

    public void deleteUser(Long id) {
        User user = userByIdCheck(id);

        userRepository.deleteById(user.getId());
    }

    private User userByIdCheck(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException(
                        userId + " ID'li kullanıcı bulunamadı."));
    }
}