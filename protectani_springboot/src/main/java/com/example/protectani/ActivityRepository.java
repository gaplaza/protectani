package com.example.protectani;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ActivityRepository extends JpaRepository<Activity, Integer> {
    Optional<Activity> findByType(String type);
}
