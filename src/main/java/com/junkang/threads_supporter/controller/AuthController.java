package com.junkang.threads_supporter.controller;

import com.junkang.threads_supporter.dto.response.ThreadsTokenResponse;
import com.junkang.threads_supporter.dto.response.ThreadsUserResponse;
import com.junkang.threads_supporter.entity.User;
import com.junkang.threads_supporter.service.ThreadsOAuthService;
import com.junkang.threads_supporter.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;

@Controller
@RequestMapping("/auth")
@RequiredArgsConstructor
@Slf4j
public class AuthController {

    private final ThreadsOAuthService oAuthService;
    private final UserService userService;

    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        // Already logged in
        if (session.getAttribute("userId") != null) {
            return "redirect:/dashboard";
        }
        return "auth/login";
    }

    @GetMapping("/threads")
    public String initiateOAuth() {
        String authUrl = oAuthService.buildAuthorizationUrl();
        return "redirect:" + authUrl;
    }

    @GetMapping("/callback")
    public String handleCallback(
            @RequestParam("code") String code,
            HttpSession session,
            Model model) {

        try {
            // Exchange code for short-lived token
            ThreadsTokenResponse shortLivedToken = oAuthService.exchangeCodeForToken(code);
            log.info("Got short-lived token for user: {}", shortLivedToken.getUserId());

            // Exchange for long-lived token (60 days)
            ThreadsTokenResponse longLivedToken = oAuthService.exchangeForLongLivedToken(
                    shortLivedToken.getAccessToken()
            );

            // Get user profile
            ThreadsUserResponse profile = oAuthService.getUserProfile(longLivedToken.getAccessToken());

            // Find or create user
            User user = userService.findOrCreateUser(
                    profile.getId(),
                    profile.getUsername(),
                    longLivedToken.getAccessToken(),
                    longLivedToken.getExpiresIn(),
                    profile.getProfilePictureUrl(),
                    profile.getBiography()
            );

            // Set session
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());

            // Set Spring Security context
            UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                    user.getId(),
                    null,
                    Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER"))
            );
            SecurityContextHolder.getContext().setAuthentication(auth);

            log.info("User {} logged in successfully", user.getUsername());
            return "redirect:/dashboard";

        } catch (Exception e) {
            log.error("OAuth callback error", e);
            model.addAttribute("error", "로그인에 실패했습니다. 다시 시도해주세요.");
            return "auth/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        SecurityContextHolder.clearContext();
        return "redirect:/";
    }
}
