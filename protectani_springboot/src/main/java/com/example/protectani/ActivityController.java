package com.example.protectani;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/activities")
@CrossOrigin
public class ActivityController {
    @Autowired
    private ActivityRepository activityRepository;

    @GetMapping
    public ResponseEntity<List<Activity>> getAllActivities() {
        List<Activity> activities = activityRepository.findAll();
        return ResponseEntity.ok(activities);
    }

    @PostMapping
    public ResponseEntity<Activity> addActivity(@RequestBody Activity activity) {
        try {
            Activity savedActivity = activityRepository.save(activity);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedActivity);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }
}
