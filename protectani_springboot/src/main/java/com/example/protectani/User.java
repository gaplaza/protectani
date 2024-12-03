package com.example.protectani;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Entity
@Getter
@Setter
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    private Integer points = 0;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<UserActivityReward> userActivityRewards;

    public void addPoints(int points) {
        this.points += points;
    }
}