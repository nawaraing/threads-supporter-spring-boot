package com.junkang.threads_supporter.scheduler;

import com.junkang.threads_supporter.entity.PostLog;
import com.junkang.threads_supporter.entity.ScheduledPost;
import com.junkang.threads_supporter.repository.ScheduledPostRepository;
import com.junkang.threads_supporter.service.PostLogService;
import com.junkang.threads_supporter.service.ScheduledPostService;
import com.junkang.threads_supporter.service.ThreadsApiService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;

@Component
@RequiredArgsConstructor
@Slf4j
public class PostPublisherScheduler {

    private final ScheduledPostRepository scheduledPostRepository;
    private final ScheduledPostService scheduledPostService;
    private final ThreadsApiService threadsApiService;
    private final PostLogService postLogService;

    // Run at 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55 minutes of every hour
    @Scheduled(cron = "0 0/5 * * * *", zone = "Asia/Seoul")
    @Transactional
    public void publishScheduledPosts() {
        log.info("Running scheduled post publisher...");

        LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));
        int dayOfWeek = now.getDayOfWeek().getValue() % 7;  // Convert to 0=Sunday format
        int hour = now.getHour();
        int minute = now.getMinute();

        // Round minute to nearest 5-minute interval
        int roundedMinute = (minute / 5) * 5;

        // Find recurring posts due now
        LocalDateTime todayStart = LocalDate.now(ZoneId.of("Asia/Seoul")).atStartOfDay();
        List<ScheduledPost> recurringPosts = scheduledPostRepository.findRecurringPostsDueNow(
                dayOfWeek, hour, roundedMinute, todayStart
        );

        // Find one-time posts due
        List<ScheduledPost> oneTimePosts = scheduledPostRepository.findOneTimePostsDue();

        // Process recurring posts
        for (ScheduledPost post : recurringPosts) {
            publishPost(post);
        }

        // Process one-time posts
        for (ScheduledPost post : oneTimePosts) {
            publishPost(post);
        }

        log.info("Scheduled post publisher completed. Processed {} recurring, {} one-time posts",
                recurringPosts.size(), oneTimePosts.size());
    }

    private void publishPost(ScheduledPost post) {
        PostLog logEntry = PostLog.builder()
                .scheduledPost(post)
                .user(post.getUser())
                .status(PostLog.PostStatus.success)
                .build();

        try {
            log.info("Publishing post {} for user {}", post.getId(), post.getUser().getUsername());

            String threadsPostId = threadsApiService.publishPost(post.getUser(), post);

            logEntry.setThreadsPostId(threadsPostId);
            logEntry.setStatus(PostLog.PostStatus.success);
            logEntry.setPostedAt(LocalDateTime.now());

            scheduledPostService.updateLastPostedAt(post);

            log.info("Successfully published post {} as Threads post {}", post.getId(), threadsPostId);

        } catch (Exception e) {
            log.error("Failed to publish post {}: {}", post.getId(), e.getMessage());

            logEntry.setStatus(PostLog.PostStatus.failed);
            logEntry.setErrorMessage(e.getMessage());
            logEntry.setPostedAt(LocalDateTime.now());
        }

        postLogService.save(logEntry);
    }
}
