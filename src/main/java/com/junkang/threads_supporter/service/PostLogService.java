package com.junkang.threads_supporter.service;

import com.junkang.threads_supporter.entity.PostLog;
import com.junkang.threads_supporter.entity.User;
import com.junkang.threads_supporter.repository.PostLogRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class PostLogService {

    private final PostLogRepository postLogRepository;

    public PostLog save(PostLog postLog) {
        return postLogRepository.save(postLog);
    }

    @Transactional(readOnly = true)
    public List<PostLog> getRecentLogs(User user, int limit) {
        return postLogRepository.findTop10ByUserOrderByPostedAtDesc(user);
    }

    @Transactional(readOnly = true)
    public long countSuccessful(User user) {
        return postLogRepository.countByUserAndStatus(user, PostLog.PostStatus.success);
    }

    @Transactional(readOnly = true)
    public long countFailed(User user) {
        return postLogRepository.countByUserAndStatus(user, PostLog.PostStatus.failed);
    }
}
