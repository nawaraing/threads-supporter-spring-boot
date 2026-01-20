package com.junkang.threads_supporter.service;

import com.junkang.threads_supporter.dto.response.ThreadsTokenResponse;
import com.junkang.threads_supporter.dto.response.ThreadsUserResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Service
@RequiredArgsConstructor
@Slf4j
public class ThreadsOAuthService {

    private final WebClient webClient;

    @Value("${threads.client-id}")
    private String clientId;

    @Value("${threads.client-secret}")
    private String clientSecret;

    @Value("${threads.redirect-uri}")
    private String redirectUri;

    private static final String AUTHORIZATION_URI = "https://threads.net/oauth/authorize";
    private static final String TOKEN_URI = "https://graph.threads.net/oauth/access_token";
    private static final String API_BASE_URL = "https://graph.threads.net/v1.0";

    public String buildAuthorizationUrl() {
        String scopes = "threads_basic,threads_content_publish,threads_manage_insights,threads_manage_replies,threads_read_replies";
        return AUTHORIZATION_URI +
                "?client_id=" + clientId +
                "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8) +
                "&scope=" + scopes +
                "&response_type=code";
    }

    public ThreadsTokenResponse exchangeCodeForToken(String code) {
        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
        formData.add("client_id", clientId);
        formData.add("client_secret", clientSecret);
        formData.add("grant_type", "authorization_code");
        formData.add("redirect_uri", redirectUri);
        formData.add("code", code);

        return webClient.post()
                .uri(TOKEN_URI)
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .body(BodyInserters.fromFormData(formData))
                .retrieve()
                .bodyToMono(ThreadsTokenResponse.class)
                .block();
    }

    public ThreadsTokenResponse exchangeForLongLivedToken(String shortLivedToken) {
        String url = API_BASE_URL + "/access_token" +
                "?grant_type=th_exchange_token" +
                "&client_secret=" + clientSecret +
                "&access_token=" + shortLivedToken;

        return webClient.get()
                .uri(url)
                .retrieve()
                .bodyToMono(ThreadsTokenResponse.class)
                .block();
    }

    public ThreadsTokenResponse refreshLongLivedToken(String currentToken) {
        String url = API_BASE_URL + "/refresh_access_token" +
                "?grant_type=th_refresh_token" +
                "&access_token=" + currentToken;

        return webClient.get()
                .uri(url)
                .retrieve()
                .bodyToMono(ThreadsTokenResponse.class)
                .block();
    }

    public ThreadsUserResponse getUserProfile(String accessToken) {
        String url = API_BASE_URL + "/me?fields=id,username,threads_profile_picture_url,threads_biography&access_token=" + accessToken;

        return webClient.get()
                .uri(url)
                .retrieve()
                .bodyToMono(ThreadsUserResponse.class)
                .block();
    }

    public Integer getFollowerCount(String accessToken, String userId) {
        String url = API_BASE_URL + "/" + userId + "/threads_insights" +
                "?metric=followers_count" +
                "&access_token=" + accessToken;

        try {
            var response = webClient.get()
                    .uri(url)
                    .retrieve()
                    .bodyToMono(Object.class)
                    .block();
            // Parse follower count from response
            // This is simplified - actual implementation may need more parsing
            return 0;
        } catch (Exception e) {
            log.warn("Failed to get follower count: {}", e.getMessage());
            return 0;
        }
    }
}
