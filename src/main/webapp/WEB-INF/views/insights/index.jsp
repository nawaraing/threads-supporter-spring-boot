<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>통계 - 스레드 서포터</title>
    <link href="/css/styles.css" rel="stylesheet">
</head>
<body>
    <div class="app-container">
    <div class="insights-page">
        <!-- 헤더 -->
        <div class="insights-header">
            <div class="insights-header-inner">
                <h1 class="header-title">통계</h1>
                <select id="periodSelect" class="form-select" style="width: auto;" onchange="changePeriod(this.value)">
                    <option value="7">최근 7일</option>
                    <option value="30" selected>최근 30일</option>
                    <option value="90">최근 90일</option>
                    <option value="120">최근 120일</option>
                </select>
            </div>
        </div>

        <div class="insights-content">
            <!-- 에러 메시지 -->
            <c:if test="${not empty error}">
                <div class="error-box">
                    <div class="error-box-content">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        <p>${error}</p>
                    </div>
                    <button onclick="location.reload()">다시 시도</button>
                </div>
            </c:if>

            <!-- 통계 요약 카드 -->
            <div class="insights-card">
                <div class="insights-card-header">
                    <h2 class="insights-card-title">총 조회수</h2>
                    <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" style="color: var(--gray-400);">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                        <path stroke-linecap="round" stroke-linejoin="round" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                </div>
                <div class="insights-total" id="totalViews">
                    <c:choose>
                        <c:when test="${not empty totalViews}">
                            <fmt:formatNumber value="${totalViews}" />
                        </c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </div>
                <p class="insights-subtitle">최근 <span id="periodText">30</span>일간의 조회수</p>
            </div>

            <!-- 조회수 그래프 -->
            <div class="insights-card">
                <h2 class="insights-card-title mb-6">일별 조회수 추이</h2>
                <div class="insights-chart" id="chartContainer">
                    <c:choose>
                        <c:when test="${not empty chartData}">
                            <canvas id="viewsChart"></canvas>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state" style="padding: 2rem;">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" style="width: 3rem; height: 3rem;">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                                </svg>
                                <p>차트 데이터가 없습니다</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- 데이터 없음 -->
            <c:if test="${empty totalViews && empty error}">
                <div class="insights-card text-center" style="padding: 3rem;">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" style="width: 4rem; height: 4rem; color: var(--gray-300); margin: 0 auto 1rem;">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                    </svg>
                    <h3 style="font-size: 1.125rem; font-weight: 500; color: var(--gray-900); margin-bottom: 0.5rem;">통계 데이터가 없습니다</h3>
                    <p style="font-size: 0.875rem; color: var(--gray-500);">
                        아직 조회수 데이터가 수집되지 않았습니다.
                    </p>
                </div>
            </c:if>
        </div>

        <!-- 하단 네비게이션 -->
        <nav class="bottom-nav">
            <div class="bottom-nav-inner">
                <ul class="bottom-nav-list">
                    <li class="bottom-nav-item">
                        <a href="/posts" class="bottom-nav-link">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                            <span>예약</span>
                        </a>
                    </li>
                    <li class="bottom-nav-item">
                        <a href="/insights" class="bottom-nav-link active">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                            </svg>
                            <span>통계</span>
                        </a>
                    </li>
                    <li class="bottom-nav-item">
                        <a href="/profile" class="bottom-nav-link">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                            </svg>
                            <span>프로필</span>
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
    </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        function changePeriod(period) {
            window.location.href = '/insights?period=' + period;
        }

        // 차트 초기화
        <c:if test="${not empty chartData}">
        document.addEventListener('DOMContentLoaded', function() {
            const ctx = document.getElementById('viewsChart').getContext('2d');
            const chartData = ${chartData};

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: chartData.map(d => d.date),
                    datasets: [{
                        label: '조회수',
                        data: chartData.map(d => d.views),
                        borderColor: '#3b82f6',
                        backgroundColor: 'rgba(59, 130, 246, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        tension: 0.4,
                        pointRadius: chartData.length <= 7 ? 4 : 0,
                        pointBackgroundColor: '#3b82f6'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            backgroundColor: '#ffffff',
                            titleColor: '#374151',
                            bodyColor: '#3b82f6',
                            borderColor: '#e5e7eb',
                            borderWidth: 1,
                            padding: 12,
                            displayColors: false
                        }
                    },
                    scales: {
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                color: '#9ca3af',
                                font: {
                                    size: 12
                                }
                            }
                        },
                        y: {
                            grid: {
                                color: '#f0f0f0'
                            },
                            ticks: {
                                color: '#9ca3af',
                                font: {
                                    size: 12
                                }
                            },
                            beginAtZero: true
                        }
                    }
                }
            });
        });
        </c:if>

        // URL에서 period 파라미터 읽어서 select 동기화
        const urlParams = new URLSearchParams(window.location.search);
        const period = urlParams.get('period') || '30';
        document.getElementById('periodSelect').value = period;
        document.getElementById('periodText').textContent = period;
    </script>
</body>
</html>
