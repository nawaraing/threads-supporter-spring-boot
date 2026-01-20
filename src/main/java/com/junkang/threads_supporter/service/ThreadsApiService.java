package com.junkang.threads_supporter.service;

import com.junkang.threads_supporter.dto.response.ThreadsMediaContainerResponse;
import com.junkang.threads_supporter.dto.response.ThreadsPublishResponse;
import com.junkang.threads_supporter.entity.ScheduledPost;
import com.junkang.threads_supporter.entity.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class ThreadsApiService {

    private final WebClient webClient;

    private static final String API_BASE_URL = "https://graph.threads.net/v1.0";

    public String publishPost(User user, ScheduledPost post) {
        String[] imageUrls = post.getImageUrls();

        if (imageUrls == null || imageUrls.length == 0) {
            return publishTextPost(user, post.getContent());
        } else if (imageUrls.length == 1) {
            return publishImagePost(user, post.getContent(), imageUrls[0]);
        } else {
            return publishCarouselPost(user, post.getContent(), imageUrls);
        }
    }

    private String publishTextPost(User user, String content) {
        String containerId = createMediaContainer(user, "TEXT", content, null);
        return publishContainer(user, containerId);
    }

    private String publishImagePost(User user, String content, String imageUrl) {
        String containerId = createMediaContainer(user, "IMAGE", content, imageUrl);
        waitForProcessing(3000);
        return publishContainer(user, containerId);
    }

    private String publishCarouselPost(User user, String content, String[] imageUrls) {
        List<String> itemContainerIds = new ArrayList<>();
        for (String imageUrl : imageUrls) {
            String itemId = createCarouselItemContainer(user, imageUrl);
            itemContainerIds.add(itemId);
        }

        waitForProcessing(5000);

        String carouselContainerId = createCarouselContainer(user, content, itemContainerIds);
        waitForProcessing(3000);

        return publishContainer(user, carouselContainerId);
    }

    private String createMediaContainer(User user, String mediaType, String text, String imageUrl) {
        String url = API_BASE_URL + "/" + user.getThreadsUserId() + "/threads";

        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
        formData.add("media_type", mediaType);
        formData.add("text", text);
        formData.add("access_token", user.getAccessToken());

        if (imageUrl != null) {
            formData.add("image_url", imageUrl);
        }

        ThreadsMediaContainerResponse response = webClient.post()
                .uri(url)
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .body(BodyInserters.fromFormData(formData))
                .retrieve()
                .bodyToMono(ThreadsMediaContainerResponse.class)
                .block();

        if (response == null || response.getId() == null) {
            throw new RuntimeException("Failed to create media container");
        }

        return response.getId();
    }

    private String createCarouselItemContainer(User user, String imageUrl) {
        String url = API_BASE_URL + "/" + user.getThreadsUserId() + "/threads";

        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
        formData.add("media_type", "IMAGE");
        formData.add("image_url", imageUrl);
        formData.add("is_carousel_item", "true");
        formData.add("access_token", user.getAccessToken());

        ThreadsMediaContainerResponse response = webClient.post()
                .uri(url)
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .body(BodyInserters.fromFormData(formData))
                .retrieve()
                .bodyToMono(ThreadsMediaContainerResponse.class)
                .block();

        return response.getId();
    }

    private String createCarouselContainer(User user, String text, List<String> children) {
        String url = API_BASE_URL + "/" + user.getThreadsUserId() + "/threads";

        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
        formData.add("media_type", "CAROUSEL");
        formData.add("text", text);
        formData.add("children", String.join(",", children));
        formData.add("access_token", user.getAccessToken());

        ThreadsMediaContainerResponse response = webClient.post()
                .uri(url)
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .body(BodyInserters.fromFormData(formData))
                .retrieve()
                .bodyToMono(ThreadsMediaContainerResponse.class)
                .block();

        return response.getId();
    }

    private String publishContainer(User user, String containerId) {
        String url = API_BASE_URL + "/" + user.getThreadsUserId() + "/threads_publish";

        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
        formData.add("creation_id", containerId);
        formData.add("access_token", user.getAccessToken());

        ThreadsPublishResponse response = webClient.post()
                .uri(url)
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .body(BodyInserters.fromFormData(formData))
                .retrieve()
                .bodyToMono(ThreadsPublishResponse.class)
                .block();

        if (response == null || response.getId() == null) {
            throw new RuntimeException("Failed to publish thread");
        }

        return response.getId();
    }

    private void waitForProcessing(long millis) {
        try {
            Thread.sleep(millis);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> getUserInsights(String accessToken, String threadsUserId, int period) {
        String url = API_BASE_URL + "/" + threadsUserId + "/threads_insights"
                + "?metric=views"
                + "&period=day"
                + "&since=" + (System.currentTimeMillis() / 1000 - (period * 24 * 60 * 60))
                + "&until=" + (System.currentTimeMillis() / 1000)
                + "&access_token=" + accessToken;

        try {
            Map<String, Object> response = webClient.get()
                    .uri(url)
                    .retrieve()
                    .bodyToMono(Map.class)
                    .block();

            if (response != null && response.containsKey("data")) {
                List<Map<String, Object>> dataList = (List<Map<String, Object>>) response.get("data");
                if (dataList != null && !dataList.isEmpty()) {
                    return dataList.get(0);
                }
            }
            return null;
        } catch (Exception e) {
            log.error("Failed to fetch insights for user: {}", threadsUserId, e);
            throw new RuntimeException("Failed to fetch insights: " + e.getMessage(), e);
        }
    }
}
