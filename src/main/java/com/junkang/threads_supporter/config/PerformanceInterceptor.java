package com.junkang.threads_supporter.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * HTTP 요청의 성능을 측정하는 인터셉터
 * 각 요청의 처리 시간을 로그에 기록합니다.
 */
@Slf4j
@Component
public class PerformanceInterceptor implements HandlerInterceptor {

    private static final String START_TIME_ATTRIBUTE = "startTime";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        long startTime = System.currentTimeMillis();
        request.setAttribute(START_TIME_ATTRIBUTE, startTime);

        log.debug("⏱️ [REQUEST START] {} {} from {}",
            request.getMethod(),
            request.getRequestURI(),
            request.getRemoteAddr());

        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                                Object handler, Exception ex) {
        Long startTime = (Long) request.getAttribute(START_TIME_ATTRIBUTE);

        if (startTime != null) {
            long endTime = System.currentTimeMillis();
            long executionTime = endTime - startTime;

            String logLevel = getLogLevel(executionTime);
            String uri = request.getRequestURI();
            String method = request.getMethod();
            int status = response.getStatus();

            String logMessage = String.format(
                "%s [REQUEST END] %s %s | Status: %d | Time: %dms",
                logLevel, method, uri, status, executionTime
            );

            // 성능에 따라 로그 레벨 조정
            if (executionTime > 3000) {
                log.error("🔴 {} | ⚠️ VERY SLOW REQUEST", logMessage);
            } else if (executionTime > 1000) {
                log.warn("🟡 {} | ⚠️ SLOW REQUEST", logMessage);
            } else if (executionTime > 500) {
                log.info("🟢 {}", logMessage);
            } else {
                log.debug("⚡ {} | FAST", logMessage);
            }

            // 예외가 발생한 경우
            if (ex != null) {
                log.error("❌ [REQUEST ERROR] {} {} | Exception: {}",
                    method, uri, ex.getMessage());
            }
        }
    }

    private String getLogLevel(long executionTime) {
        if (executionTime > 3000) return "🔴 CRITICAL";
        if (executionTime > 1000) return "🟡 WARNING";
        if (executionTime > 500) return "🟢 INFO";
        return "⚡ DEBUG";
    }
}
