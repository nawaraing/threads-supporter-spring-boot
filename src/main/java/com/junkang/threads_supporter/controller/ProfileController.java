package com.junkang.threads_supporter.controller;

import com.junkang.threads_supporter.dto.response.ThreadsUserResponse;
import com.junkang.threads_supporter.entity.User;
import com.junkang.threads_supporter.service.ThreadsOAuthService;
import com.junkang.threads_supporter.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/profile")
@RequiredArgsConstructor
@Slf4j
public class ProfileController {

    private final UserService userService;
    private final ThreadsOAuthService oAuthService;

    @GetMapping
    public String profile(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/auth/login";
        }

        User user = userService.findById(userId);
        model.addAttribute("user", user);
        return "profile/index";
    }

    @PostMapping("/sync")
    public String syncProfile(HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/auth/login";
        }

        try {
            User user = userService.findById(userId);
            ThreadsUserResponse profile = oAuthService.getUserProfile(user.getAccessToken());
            Integer followerCount = oAuthService.getFollowerCount(user.getAccessToken(), user.getThreadsUserId());

            userService.updateProfile(user, profile.getUsername(), profile.getProfilePictureUrl(), followerCount);
            log.info("Profile synced for user: {}", user.getUsername());
        } catch (Exception e) {
            log.error("Failed to sync profile", e);
        }

        return "redirect:/profile";
    }
}
