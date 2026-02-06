package com.junkang.threads_supporter.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.ExchangeFilterFunction;
import reactor.core.publisher.Mono;

/**
 * WebClient 요청/응답 로깅 설정
 * Threads API 호출 성능을 추적합니다.
 */
@Slf4j
@Configuration
public class WebClientLoggingConfig {

    @Bean
    ExchangeFilterFunction logRequest() {
        return ExchangeFilterFunction.ofRequestProcessor(clientRequest -> {
            long startTime = System.currentTimeMillis();

            log.info("🌐 [API REQUEST] {} {}",
                clientRequest.method(),
                clientRequest.url());

            return Mono.just(clientRequest)
                    .doOnNext(request -> request.attributes()
                            .put("startTime", startTime));
        });
    }

    @Bean
    ExchangeFilterFunction logResponse() {
        return ExchangeFilterFunction.ofResponseProcessor(clientResponse -> {
            return Mono.just(clientResponse)
                    .doOnNext(response -> {
                        Long requestStartTime = (Long) response.logPrefix();
                        long startTime = System.currentTimeMillis();

                        // 요청 시작 시간을 attributes에서 가져옴
                        Object startTimeAttr = clientResponse.request().attributes().get("startTime");
                        long duration = 0;
                        if (startTimeAttr instanceof Long) {
                            duration = startTime - (Long) startTimeAttr;
                        }

                        String logLevel = duration > 2000 ? "🔴" : duration > 1000 ? "🟡" : "🟢";

                        log.info("{} [API RESPONSE] Status: {} | Time: {}ms",
                            logLevel,
                            response.statusCode(),
                            duration);

                        if (duration > 2000) {
                            log.warn("⚠️ SLOW API CALL took {}ms", duration);
                        }
                    })
                    .doOnError(error -> {
                        log.error("❌ [API ERROR] Request failed: {}", error.getMessage());
                    });
        });
    }
}
