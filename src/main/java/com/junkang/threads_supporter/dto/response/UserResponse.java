package com.junkang.threads_supporter.dto.response;

import com.junkang.threads_supporter.entity.User;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserResponse {

    private String id;
    private String threadsUserId;
    private String username;
    private String name;
    private String profilePictureUrl;
    private Integer followerCount;
    private LocalDateTime tokenExpiresAt;
    private LocalDateTime createdAt;

    public static UserResponse from(User user) {
        return UserResponse.builder()
                .id(user.getId().toString())
                .threadsUserId(user.getThreadsUserId())
                .username(user.getUsername())
                .name(user.getName())
                .profilePictureUrl(user.getProfilePictureUrl())
                .followerCount(user.getFollowerCount())
                .tokenExpiresAt(user.getTokenExpiresAt())
                .createdAt(user.getCreatedAt())
                .build();
    }
}
