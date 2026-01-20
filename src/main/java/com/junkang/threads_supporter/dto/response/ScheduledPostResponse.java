package com.junkang.threads_supporter.dto.response;

import com.junkang.threads_supporter.entity.ScheduledPost;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ScheduledPostResponse {

    private String id;
    private String userId;
    private String content;
    private Integer[] daysOfWeek;
    private Integer hour;
    private Integer minute;
    private String[] imageUrls;
    private Boolean isActive;
    private Boolean isRecurring;
    private LocalDateTime lastPostedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static ScheduledPostResponse from(ScheduledPost post) {
        return ScheduledPostResponse.builder()
                .id(post.getId())
                .userId(post.getUser().getId())
                .content(post.getContent())
                .daysOfWeek(post.getDaysOfWeek())
                .hour(post.getHour())
                .minute(post.getMinute())
                .imageUrls(post.getImageUrls())
                .isActive(post.getIsActive())
                .isRecurring(post.getIsRecurring())
                .lastPostedAt(post.getLastPostedAt())
                .createdAt(post.getCreatedAt())
                .updatedAt(post.getUpdatedAt())
                .build();
    }
}
