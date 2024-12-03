package com.example.protectani;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserActivityRewardRepository extends JpaRepository<UserActivityReward, Integer> {
    List<UserActivityReward> findByUserId(Integer userId);
    Optional<UserActivityReward> findByUserAndActivity(User user, Activity activity);
    long countByUserIdAndActivityType(int userId, String activityType);

}