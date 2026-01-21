package com.junkang.threads_supporter.service;

import com.junkang.threads_supporter.dto.request.ScheduledPostRequest;
import com.junkang.threads_supporter.dto.response.ScheduledPostResponse;
import com.junkang.threads_supporter.entity.ScheduledPost;
import com.junkang.threads_supporter.entity.User;
import com.junkang.threads_supporter.repository.ScheduledPostRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class ScheduledPostService {

    private final ScheduledPostRepository scheduledPostRepository;

    public ScheduledPost create(User user, ScheduledPostRequest request) {
        ScheduledPost post = ScheduledPost.builder()
                .user(user)
                .content(request.getContent())
                .daysOfWeek(request.getDaysOfWeek())
                .hour(request.getHour())
                .minute(request.getMinute())
                .imageUrls(request.getImageUrls())
                .isActive(request.getIsActive() != null ? request.getIsActive() : true)
                .isRecurring(request.getIsRecurring() != null ? request.getIsRecurring() : true)
                .build();

        return scheduledPostRepository.save(post);
    }

    public ScheduledPost update(String id, User user, ScheduledPostRequest request) {
        UUID postId = UUID.fromString(id);
        ScheduledPost post = scheduledPostRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Post not found: " + id));

        if (!post.getUser().getId().equals(user.getId())) {
            throw new SecurityException("Not authorized to update this post");
        }

        post.setContent(request.getContent());
        post.setDaysOfWeek(request.getDaysOfWeek());
        post.setHour(request.getHour());
        post.setMinute(request.getMinute());
        post.setImageUrls(request.getImageUrls());

        if (request.getIsActive() != null) {
            post.setIsActive(request.getIsActive());
        }
        if (request.getIsRecurring() != null) {
            post.setIsRecurring(request.getIsRecurring());
        }

        return scheduledPostRepository.save(post);
    }

    public void delete(String id, User user) {
        UUID postId = UUID.fromString(id);
        ScheduledPost post = scheduledPostRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Post not found: " + id));

        if (!post.getUser().getId().equals(user.getId())) {
            throw new SecurityException("Not authorized to delete this post");
        }

        scheduledPostRepository.delete(post);
    }

    @Transactional(readOnly = true)
    public List<ScheduledPostResponse> findAllByUser(User user) {
        return scheduledPostRepository.findByUserOrderByCreatedAtDesc(user)
                .stream()
                .map(ScheduledPostResponse::from)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ScheduledPostResponse> findAllByUserId(String userId) {
        UUID userUuid = UUID.fromString(userId);
        return scheduledPostRepository.findByUserId(userUuid)
                .stream()
                .map(ScheduledPostResponse::from)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public ScheduledPost findById(String id) {
        UUID postId = UUID.fromString(id);
        return scheduledPostRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Post not found: " + id));
    }

    public void toggleActive(String id, User user) {
        ScheduledPost post = findById(id);
        if (!post.getUser().getId().equals(user.getId())) {
            throw new SecurityException("Not authorized");
        }
        post.setIsActive(!post.getIsActive());
        scheduledPostRepository.save(post);
    }

    public void updateLastPostedAt(ScheduledPost post) {
        post.setLastPostedAt(LocalDateTime.now());
        if (!post.getIsRecurring()) {
            post.setIsActive(false);
        }
        scheduledPostRepository.save(post);
    }
}
