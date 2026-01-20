package com.junkang.threads_supporter.repository;

import com.junkang.threads_supporter.entity.PostLog;
import com.junkang.threads_supporter.entity.ScheduledPost;
import com.junkang.threads_supporter.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface PostLogRepository extends JpaRepository<PostLog, String> {

    Page<PostLog> findByUserOrderByPostedAtDesc(User user, Pageable pageable);

    List<PostLog> findByScheduledPost(ScheduledPost scheduledPost);

    List<PostLog> findByUserAndPostedAtBetween(User user, LocalDateTime start, LocalDateTime end);

    long countByUserAndStatus(User user, PostLog.PostStatus status);

    List<PostLog> findTop10ByUserOrderByPostedAtDesc(User user);
}
