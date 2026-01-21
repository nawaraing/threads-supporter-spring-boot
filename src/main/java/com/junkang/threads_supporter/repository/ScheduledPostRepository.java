package com.junkang.threads_supporter.repository;

import com.junkang.threads_supporter.entity.ScheduledPost;
import com.junkang.threads_supporter.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface ScheduledPostRepository extends JpaRepository<ScheduledPost, UUID> {

    List<ScheduledPost> findByUserAndIsActiveTrue(User user);

    List<ScheduledPost> findByUserOrderByCreatedAtDesc(User user);

    List<ScheduledPost> findByUserId(UUID userId);

    // Find recurring posts due for publishing
    @Query(value = """
        SELECT * FROM scheduled_posts sp
        WHERE sp.is_active = true
        AND sp.is_recurring = true
        AND :dayOfWeek = ANY(sp.days_of_week)
        AND sp.hour = :hour
        AND sp.minute = :minute
        AND (sp.last_posted_at IS NULL OR sp.last_posted_at < :today)
        """, nativeQuery = true)
    List<ScheduledPost> findRecurringPostsDueNow(
            @Param("dayOfWeek") int dayOfWeek,
            @Param("hour") int hour,
            @Param("minute") int minute,
            @Param("today") LocalDateTime today
    );

    // Find one-time posts due for publishing
    @Query(value = """
        SELECT * FROM scheduled_posts sp
        WHERE sp.is_active = true
        AND sp.is_recurring = false
        AND sp.last_posted_at IS NULL
        """, nativeQuery = true)
    List<ScheduledPost> findOneTimePostsDue();
}
