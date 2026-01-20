<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? '수정' : '새 예약'} - Threads Supporter</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="/css/styles.css" rel="stylesheet">
</head>
<body>
    <%@ include file="/WEB-INF/views/layout/header.jsp" %>

    <main class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">${isEdit ? '예약 수정' : '새 예약 만들기'}</h5>
                    </div>
                    <div class="card-body">
                        <form id="postForm">
                            <input type="hidden" id="postId" value="${post.id}">

                            <!-- Content -->
                            <div class="mb-3">
                                <label for="content" class="form-label">내용 <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="content" name="content" rows="4"
                                          maxlength="500" required placeholder="Threads에 게시할 내용을 입력하세요...">${post.content}</textarea>
                                <div class="form-text">
                                    <span id="charCount">0</span>/500자
                                </div>
                            </div>

                            <!-- Post Type -->
                            <div class="mb-3">
                                <label class="form-label">포스팅 유형</label>
                                <div class="btn-group w-100" role="group">
                                    <input type="radio" class="btn-check" name="isRecurring" id="recurring"
                                           value="true" ${post.isRecurring != false ? 'checked' : ''}>
                                    <label class="btn btn-outline-primary" for="recurring">
                                        <i class="bi bi-arrow-repeat"></i> 반복
                                    </label>

                                    <input type="radio" class="btn-check" name="isRecurring" id="oneTime"
                                           value="false" ${post.isRecurring == false ? 'checked' : ''}>
                                    <label class="btn btn-outline-primary" for="oneTime">
                                        <i class="bi bi-1-circle"></i> 일회성
                                    </label>
                                </div>
                            </div>

                            <!-- Days of Week -->
                            <div class="mb-3" id="daysSection">
                                <label class="form-label">요일 선택</label>
                                <div class="btn-group w-100 flex-wrap" role="group">
                                    <c:set var="dayNames" value="${['일', '월', '화', '수', '목', '금', '토']}"/>
                                    <c:forEach var="dayName" items="${dayNames}" varStatus="status">
                                        <input type="checkbox" class="btn-check" name="daysOfWeek"
                                               id="day${status.index}" value="${status.index}">
                                        <label class="btn btn-outline-secondary" for="day${status.index}">${dayName}</label>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Time -->
                            <div class="row mb-3" id="timeSection">
                                <div class="col-6">
                                    <label for="hour" class="form-label">시간</label>
                                    <select class="form-select" id="hour" name="hour">
                                        <c:forEach begin="0" end="23" var="h">
                                            <option value="${h}" ${post.hour == h ? 'selected' : ''}>
                                                ${h < 10 ? '0' : ''}${h}시
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label for="minute" class="form-label">분</label>
                                    <select class="form-select" id="minute" name="minute">
                                        <c:forEach begin="0" end="55" step="5" var="m">
                                            <option value="${m}" ${post.minute == m ? 'selected' : ''}>
                                                ${m < 10 ? '0' : ''}${m}분
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <!-- Image URLs -->
                            <div class="mb-3">
                                <label class="form-label">이미지 URL (선택, 최대 10개)</label>
                                <div id="imageUrlsContainer">
                                    <c:if test="${not empty post.imageUrls}">
                                        <c:forEach var="url" items="${post.imageUrls}">
                                            <div class="input-group mb-2">
                                                <input type="url" class="form-control image-url"
                                                       placeholder="https://example.com/image.jpg" value="${url}">
                                                <button type="button" class="btn btn-outline-danger remove-url">
                                                    <i class="bi bi-x"></i>
                                                </button>
                                            </div>
                                        </c:forEach>
                                    </c:if>
                                </div>
                                <button type="button" class="btn btn-outline-secondary btn-sm" id="addImageUrl">
                                    <i class="bi bi-plus"></i> 이미지 URL 추가
                                </button>
                                <div class="form-text">공개적으로 접근 가능한 이미지 URL을 입력하세요.</div>
                            </div>

                            <!-- Submit -->
                            <div class="d-flex justify-content-between mt-4">
                                <a href="/posts" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> 취소
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-lg"></i> ${isEdit ? '수정하기' : '저장하기'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/layout/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/app.js"></script>
    <script>
        // Pre-fill days of week if editing
        <c:if test="${isEdit and not empty post.daysOfWeek}">
            const selectedDays = [<c:forEach var="day" items="${post.daysOfWeek}" varStatus="status">${day}<c:if test="${!status.last}">,</c:if></c:forEach>];
            selectedDays.forEach(day => {
                const checkbox = document.getElementById('day' + day);
                if (checkbox) checkbox.checked = true;
            });
        </c:if>
    </script>
    <script src="/js/schedule-picker.js"></script>
</body>
</html>
