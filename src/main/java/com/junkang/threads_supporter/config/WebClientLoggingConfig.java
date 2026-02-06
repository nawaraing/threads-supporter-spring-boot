package com.junkang.threads_supporter.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.ClientRequest;
import org.springframework.web.reactive.function.client.ClientResponse;
import org.springframework.web.reactive.function.client.ExchangeFilterFunction;
import org.springframework.web.reactive.function.client.ExchangeFunction;
import reactor.core.publisher.Mono;

/**
 * WebClient 요청/응답 로깅 설정
 * Threads API 호출 성능을 추적합니다.
 */
@Slf4j
@Configuration
public class WebClientLoggingConfig {

    private static final String START_TIME_ATTR = "startTime";

    @Bean
    ExchangeFilterFunction logRequest() {
        return (request, next) -> {
            long startTime = System.currentTimeMillis();

            log.info("🌐 [API REQUEST] {} {}", request.method(), request.url());

            ClientRequest modifiedRequest = ClientRequest.from(request)
                    .attribute(START_TIME_ATTR, startTime)
                    .build();

            return next.exchange(modifiedRequest)
                    .doOnNext(response -> {
                        long endTime = System.currentTimeMillis();
                        Long requestStartTime = (Long) modifiedRequest.attribute(START_TIME_ATTR).orElse(null);

                        if (requestStartTime != null) {
                            long duration = endTime - requestStartTime;
                            String logLevel = duration > 2000 ? "🔴" : duration > 1000 ? "🟡" : "🟢";

                            log.info("{} [API RESPONSE] Status: {} | Time: {}ms",
                                    logLevel, response.statusCode(), duration);

                            if (duration > 2000) {
                                log.warn("⚠️ SLOW API CALL took {}ms", duration);
                            }
                        }
                    })
                    .doOnError(error -> log.error("❌ [API ERROR] Request failed: {}", error.getMessage()));
        };
    }
}
