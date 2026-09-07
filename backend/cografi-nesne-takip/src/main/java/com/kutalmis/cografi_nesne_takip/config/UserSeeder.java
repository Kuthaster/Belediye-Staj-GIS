package com.kutalmis.cografi_nesne_takip.config;

import com.kutalmis.cografi_nesne_takip.entity.Role;
import com.kutalmis.cografi_nesne_takip.entity.User;
import com.kutalmis.cografi_nesne_takip.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@Order(2)
public class UserSeeder implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(UserSeeder.class);

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Value("${app.bootstrap-admin.email:admin@corum.bld}")
    private String bootstrapAdminEmail;

    @Value("${app.bootstrap-admin.password:Admin123!}")
    private String bootstrapAdminPassword;

    public UserSeeder(UserRepository userRepository,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        if (userRepository.existsByRole(Role.ADMIN)) {
            return;
        }

        User admin = new User();
        admin.setName("Sistem Yöneticisi");
        admin.setEmail(bootstrapAdminEmail);
        admin.setPasswordHash(passwordEncoder.encode(bootstrapAdminPassword));
        admin.setRole(Role.ADMIN);
        admin.setMustChangePassword(Boolean.TRUE);

        userRepository.save(admin);

        log.warn("Bootstrap ADMIN hesabı oluşturuldu (email: {}). " +
                "Bu hesabın şifresini ilk girişten sonra değiştirin.", bootstrapAdminEmail);
    }
}
