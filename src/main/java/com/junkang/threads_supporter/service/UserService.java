package com.junkang.threads_supporter.service;

import com.junkang.threads_supporter.entity.User;
import com.junkang.threads_supporter.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class UserService {

    private final UserRepository userRepository;

    public User findById(String id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + id));
    }

    public Optional<User> findByThreadsUserId(String threadsUserId) {
        return userRepository.findByThreadsUserId(threadsUserId);
    }

    public User findOrCreateUser(String threadsUserId, String username, String accessToken,
                                  Long expiresIn, String profilePictureUrl, String biography) {

        Optional<User> existingUser = userRepository.findByThreadsUserId(threadsUserId);

        if (existingUser.isPresent()) {
            User user = existingUser.get();
            user.setAccessToken(accessToken);
            user.setTokenExpiresAt(LocalDateTime.now().plusSeconds(expiresIn));
            user.setProfilePictureUrl(profilePictureUrl);
            user.setUsername(username);
            return userRepository.save(user);
        }

        User newUser = User.builder()
                .threadsUserId(threadsUserId)
                .username(username)
                .accessToken(accessToken)
                .tokenExpiresAt(LocalDateTime.now().plusSeconds(expiresIn))
                .profilePictureUrl(profilePictureUrl)
                .build();

        return userRepository.save(newUser);
    }

    public User updateProfile(User user, String username, String profilePictureUrl, Integer followerCount) {
        user.setUsername(username);
        user.setProfilePictureUrl(profilePictureUrl);
        user.setFollowerCount(followerCount);
        return userRepository.save(user);
    }

    public User updateAccessToken(User user, String accessToken, Long expiresIn) {
        user.setAccessToken(accessToken);
        user.setTokenExpiresAt(LocalDateTime.now().plusSeconds(expiresIn));
        return userRepository.save(user);
    }
}
