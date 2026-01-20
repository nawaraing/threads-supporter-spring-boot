package com.junkang.threads_supporter.dto.request;

import jakarta.validation.constraints.*;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ScheduledPostRequest {

    @NotBlank(message = "Content is required")
    @Size(max = 500, message = "Content must be 500 characters or less")
    private String content;

    private Integer[] daysOfWeek;

    @Min(value = 0, message = "Hour must be between 0 and 23")
    @Max(value = 23, message = "Hour must be between 0 and 23")
    private Integer hour;

    @Min(value = 0, message = "Minute must be between 0 and 59")
    @Max(value = 59, message = "Minute must be between 0 and 59")
    private Integer minute;

    private String[] imageUrls;

    private Boolean isActive;

    private Boolean isRecurring;

    private LocalDateTime scheduledDate;
}
