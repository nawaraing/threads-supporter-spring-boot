package com.junkang.threads_supporter.controller;

import com.junkang.threads_supporter.entity.User;
import com.junkang.threads_supporter.service.ScheduledPostService;
import com.junkang.threads_supporter.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/posts")
@RequiredArgsConstructor
public class ScheduledPostController {

    private final ScheduledPostService postService;
    private final UserService userService;

    @GetMapping
    public String listPosts(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/auth/login";
        }

        User user = userService.findById(userId);
        model.addAttribute("user", user);
        model.addAttribute("posts", postService.findAllByUser(user));
        return "posts/list";
    }
}
