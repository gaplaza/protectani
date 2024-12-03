package com.example.protectani;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
public class UserController {
    @Autowired
    private UserRepository userRepository;

    @PostMapping("/register")
    public User register(@RequestBody User user) {
        return userRepository.save(user);
    }

    @PostMapping("/login")
    public User login(@RequestBody User user) {
        User existingUser = userRepository.findByEmailAndPassword(user.getEmail(), user.getPassword());
        if (existingUser == null) {
            throw new IllegalArgumentException("Invalid email or password");
        }
        return existingUser;
    }
}