package com.junkang.threads_supporter.controller;

import com.junkang.threads_supporter.entity.ScheduledPost;
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
        model.addAttribute("posts", postService.findAllByUser(user));
        return "posts/list";
    }

    @GetMapping("/create")
    public String createForm(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/auth/login";
        }

        model.addAttribute("isEdit", false);
        return "posts/form";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable String id, HttpSession session, Model model) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/auth/login";
        }

        ScheduledPost post = postService.findById(id);
        if (!post.getUser().getId().equals(userId)) {
            return "redirect:/posts";
        }

        model.addAttribute("post", post);
        model.addAttribute("isEdit", true);
        return "posts/form";
    }
}
