package com.junkang.threads_supporter.controller;

import com.junkang.threads_supporter.entity.User;
import com.junkang.threads_supporter.service.ThreadsApiService;
import com.junkang.threads_supporter.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/insights")
@RequiredArgsConstructor
@Slf4j
public class InsightsController {

    private final UserService userService;
    private final ThreadsApiService threadsApiService;

    @GetMapping
    public String insights(
            @RequestParam(defaultValue = "30") int period,
            HttpSession session,
            Model model) {

        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/auth/login";
        }

        User user = userService.findById(userId);
        model.addAttribute("user", user);

        try {
            // Threads Insights API 호출
            Map<String, Object> insightsData = threadsApiService.getUserInsights(
                    user.getAccessToken(),
                    user.getThreadsUserId(),
                    period
            );

            if (insightsData != null) {
                // 총 조회수 계산
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> values = (List<Map<String, Object>>) insightsData.get("values");
                if (values != null && !values.isEmpty()) {
                    long totalViews = values.stream()
                            .mapToLong(v -> ((Number) v.get("value")).longValue())
                            .sum();
                    model.addAttribute("totalViews", totalViews);

                    // 차트 데이터 생성
                    StringBuilder chartDataJson = new StringBuilder("[");
                    for (int i = 0; i < values.size(); i++) {
                        Map<String, Object> item = values.get(i);
                        String endTime = (String) item.get("end_time");
                        Number value = (Number) item.get("value");

                        // 날짜 포맷팅 (간단히 처리)
                        String dateLabel = endTime.substring(5, 10).replace("-", "/");

                        chartDataJson.append("{\"date\":\"").append(dateLabel)
                                .append("\",\"views\":").append(value).append("}");

                        if (i < values.size() - 1) {
                            chartDataJson.append(",");
                        }
                    }
                    chartDataJson.append("]");
                    model.addAttribute("chartData", chartDataJson.toString());
                }
            }
        } catch (Exception e) {
            log.error("Failed to fetch insights for user: {}", user.getUsername(), e);
            model.addAttribute("error", "통계 데이터를 불러오는데 실패했습니다: " + e.getMessage());
        }

        return "insights/index";
    }
}
