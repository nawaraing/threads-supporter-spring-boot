package com.junkang.threads_supporter.controller;

import com.junkang.threads_supporter.entity.User;
import com.junkang.threads_supporter.service.PostLogService;
import com.junkang.threads_supporter.service.ScheduledPostService;
import com.junkang.threads_supporter.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
@Slf4j
public class DashboardController {

    private final UserService userService;
    private final ScheduledPostService postService;
    private final PostLogService postLogService;

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("userId");
        log.debug("Dashboard accessed. Session ID: {}, userId: {}", session.getId(), userId);

        if (userId == null) {
            log.debug("No userId in session, redirecting to login");
            return "redirect:/auth/login";
        }

        User user = userService.findById(userId);
        log.debug("User found: {}", user.getUsername());

        model.addAttribute("user", user);
        model.addAttribute("scheduledPosts", postService.findAllByUser(user));
        model.addAttribute("recentLogs", postLogService.getRecentLogs(user, 10));
        model.addAttribute("successCount", postLogService.countSuccessful(user));
        model.addAttribute("failedCount", postLogService.countFailed(user));

        return "dashboard/index";
    }
}
