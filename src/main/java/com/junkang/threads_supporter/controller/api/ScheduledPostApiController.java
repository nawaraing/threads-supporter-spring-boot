package com.junkang.threads_supporter.controller.api;

import com.junkang.threads_supporter.dto.request.ScheduledPostRequest;
import com.junkang.threads_supporter.dto.response.ScheduledPostResponse;
import com.junkang.threads_supporter.entity.ScheduledPost;
import com.junkang.threads_supporter.entity.User;
import com.junkang.threads_supporter.service.ScheduledPostService;
import com.junkang.threads_supporter.service.UserService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/posts")
@RequiredArgsConstructor
public class ScheduledPostApiController {

    private final ScheduledPostService postService;
    private final UserService userService;

    @GetMapping
    public ResponseEntity<List<ScheduledPostResponse>> getAllPosts(HttpSession session) {
        User user = getCurrentUser(session);
        List<ScheduledPostResponse> posts = postService.findAllByUser(user);
        return ResponseEntity.ok(posts);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ScheduledPostResponse> getPost(@PathVariable String id, HttpSession session) {
        User user = getCurrentUser(session);
        ScheduledPost post = postService.findById(id);

        if (!post.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403).build();
        }

        return ResponseEntity.ok(ScheduledPostResponse.from(post));
    }

    @PostMapping
    public ResponseEntity<ScheduledPostResponse> createPost(
            @Valid @RequestBody ScheduledPostRequest request,
            HttpSession session) {
        User user = getCurrentUser(session);
        ScheduledPost post = postService.create(user, request);
        return ResponseEntity.ok(ScheduledPostResponse.from(post));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ScheduledPostResponse> updatePost(
            @PathVariable String id,
            @Valid @RequestBody ScheduledPostRequest request,
            HttpSession session) {
        User user = getCurrentUser(session);
        ScheduledPost post = postService.update(id, user, request);
        return ResponseEntity.ok(ScheduledPostResponse.from(post));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePost(@PathVariable String id, HttpSession session) {
        User user = getCurrentUser(session);
        postService.delete(id, user);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}/active")
    public ResponseEntity<Void> updateActive(@PathVariable String id, HttpSession session) {
        User user = getCurrentUser(session);
        postService.toggleActive(id, user);
        return ResponseEntity.ok().build();
    }

    private User getCurrentUser(HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            throw new SecurityException("Not authenticated");
        }
        return userService.findById(userId);
    }
}
