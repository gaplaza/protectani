package com.example.protectani;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/user-activities")
@CrossOrigin
public class UserActivityRewardController {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ActivityRepository activityRepository;

    @Autowired
    private UserActivityRewardRepository userActivityRewardRepository;

    @PostMapping
    public ResponseEntity<?> addUserActivity(@RequestBody Map<String, Object> request) {
        Integer userId = (Integer) request.get("user_id");
        String activityType = (String) request.get("activity_type");

        if (userId == null || activityType == null) {
            return ResponseEntity.badRequest().body("Missing user_id or activity_type");
        }

        Optional<Activity> activityOptional = activityRepository.findByType(activityType);
        if (activityOptional.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Activity not found");
        }
        Activity activity = activityOptional.get();

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        UserActivityReward userActivityReward = new UserActivityReward();
        userActivityReward.setUser(user);
        userActivityReward.setActivity(activity);
        userActivityRewardRepository.save(userActivityReward);

        long activityCount = userActivityRewardRepository.countByUserIdAndActivityType(userId, activityType);

        if (activityCount % activity.getRequired_completions() == 0) {
            user.addPoints(activity.getPoints());
            userRepository.save(user);
        }

        return ResponseEntity.ok("Activity added and points updated");
    }

    @GetMapping("/{userId}")
    public ResponseEntity<?> getUserActivities(@PathVariable Integer userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        List<UserActivityReward> userActivities = userActivityRewardRepository.findByUserId(userId);

        Map<String, Long> activityCounts = userActivities.stream()
                .collect(Collectors.groupingBy(
                        reward -> reward.getActivity().getType(),
                        Collectors.counting()
                ));

        Map<String, Object> response = new HashMap<>();
        response.put("user", Map.of(
                "id", user.getId(),
                "email", user.getEmail(),
                "points", user.getPoints()
        ));
        response.put("activities", activityCounts);

        return ResponseEntity.ok(response);
    }
}
