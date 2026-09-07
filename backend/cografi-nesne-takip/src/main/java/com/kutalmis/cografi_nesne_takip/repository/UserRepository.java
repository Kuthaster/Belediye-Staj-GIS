package com.kutalmis.cografi_nesne_takip.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kutalmis.cografi_nesne_takip.entity.User;

import java.util.Optional;

import com.kutalmis.cografi_nesne_takip.entity.Role;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);

    boolean existsByRole(Role role);
}