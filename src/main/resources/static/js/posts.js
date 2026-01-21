// posts.js - Scheduled posts management

let currentPostId = null;
let postsData = [];

document.addEventListener('DOMContentLoaded', function() {
    // 페이지 로드시 posts 데이터 수집
    collectPostsData();
});

// DOM에서 posts 데이터 수집
function collectPostsData() {
    const items = document.querySelectorAll('.post-item');
    postsData = Array.from(items).map(item => ({
        id: parseInt(item.dataset.postId),
        hour: parseInt(item.dataset.hour),
        minute: parseInt(item.dataset.minute),
        updatedAt: parseInt(item.dataset.updated)
    }));
}

// 모달 열기 - 새 글 작성
function openCreateModal() {
    currentPostId = null;
    document.getElementById('modalTitle').textContent = '새 글 작성';
    document.getElementById('postId').value = '';

    // 폼 초기화
    resetForm();

    // 버튼 상태 변경
    document.getElementById('createModeButtons').classList.remove('hidden');
    document.getElementById('editModeButtons').classList.add('hidden');

    // 모달 표시
    document.getElementById('postModal').classList.remove('hidden');
}

// 모달 열기 - 수정
async function openEditModal(postId) {
    currentPostId = postId;
    document.getElementById('modalTitle').textContent = '예약 글 수정';
    document.getElementById('postId').value = postId;

    // 버튼 상태 변경
    document.getElementById('createModeButtons').classList.add('hidden');
    document.getElementById('editModeButtons').classList.remove('hidden');

    try {
        const response = await fetch(`/api/posts/${postId}`);
        const data = await response.json();

        if (data) {
            // 폼에 데이터 설정
            document.getElementById('hour').value = data.hour;
            document.getElementById('minute').value = data.minute;
            document.getElementById('content').value = data.content || '';
            document.getElementById('isRecurring').checked = data.isRecurring !== false;

            // 요일 설정
            const dayBtns = document.querySelectorAll('#daySelector .day-btn');
            dayBtns.forEach(btn => btn.classList.remove('active'));

            if (data.daysOfWeek) {
                data.daysOfWeek.forEach(day => {
                    const btn = document.querySelector(`#daySelector .day-btn[data-day="${day}"]`);
                    if (btn) btn.classList.add('active');
                });
            }

            // 전체 선택 체크박스 업데이트
            updateSelectAllCheckbox();

            // 글자 수 업데이트
            updateCharCount();
        }
    } catch (error) {
        console.error('Failed to load post:', error);
    }

    // 모달 표시
    document.getElementById('postModal').classList.remove('hidden');
}

// 모달 닫기
function closeModal() {
    document.getElementById('postModal').classList.add('hidden');
    currentPostId = null;
}

// 폼 초기화
function resetForm() {
    document.getElementById('hour').value = '9';
    document.getElementById('minute').value = '00';
    document.getElementById('content').value = '';
    document.getElementById('isRecurring').checked = true;

    // 모든 요일 선택
    const dayBtns = document.querySelectorAll('#daySelector .day-btn');
    dayBtns.forEach(btn => btn.classList.add('active'));
    document.getElementById('selectAllDays').checked = true;

    updateCharCount();
}

// 폼 제출
async function submitPost(event) {
    event.preventDefault();

    const formData = {
        hour: parseInt(document.getElementById('hour').value),
        minute: parseInt(document.getElementById('minute').value),
        content: document.getElementById('content').value,
        isRecurring: document.getElementById('isRecurring').checked,
        daysOfWeek: getSelectedDays()
    };

    // 유효성 검사
    if (!formData.content.trim()) {
        alert('글 내용을 입력해주세요.');
        return;
    }

    if (formData.daysOfWeek.length === 0) {
        alert('최소 하나의 요일을 선택해주세요.');
        return;
    }

    try {
        let url = '/api/posts';
        let method = 'POST';

        if (currentPostId) {
            url = `/api/posts/${currentPostId}`;
            method = 'PUT';
        }

        const response = await fetch(url, {
            method: method,
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        });

        if (response.ok) {
            closeModal();
            location.reload();
        } else {
            const error = await response.json();
            alert(error.message || '저장에 실패했습니다.');
        }
    } catch (error) {
        console.error('Failed to save post:', error);
        alert('저장에 실패했습니다.');
    }
}

// 삭제 확인 모달 열기
function confirmDelete() {
    document.getElementById('deleteConfirmModal').classList.remove('hidden');
}

// 삭제 확인 모달 닫기
function closeDeleteConfirm() {
    document.getElementById('deleteConfirmModal').classList.add('hidden');
}

// 포스트 삭제
async function deletePost() {
    if (!currentPostId) return;

    document.getElementById('deleteConfirmModal').classList.add('hidden');
    document.getElementById('postModal').classList.add('hidden');
    document.getElementById('deleteLoading').classList.remove('hidden');

    try {
        const response = await fetch(`/api/posts/${currentPostId}`, {
            method: 'DELETE'
        });

        if (response.ok) {
            location.reload();
        } else {
            document.getElementById('deleteLoading').classList.add('hidden');
            alert('삭제에 실패했습니다.');
        }
    } catch (error) {
        document.getElementById('deleteLoading').classList.add('hidden');
        console.error('Failed to delete post:', error);
        alert('삭제에 실패했습니다.');
    }
}

// 활성 상태 토글
async function toggleActive(postId, currentState) {
    try {
        const response = await fetch(`/api/posts/${postId}/toggle`, {
            method: 'POST'
        });

        if (response.ok) {
            // 버튼 UI 업데이트
            const btn = document.querySelector(`.toggle-switch[data-post-id="${postId}"]`);
            if (btn) {
                btn.classList.toggle('active');
            }
        } else {
            alert('상태 변경에 실패했습니다.');
        }
    } catch (error) {
        console.error('Failed to toggle active:', error);
        alert('상태 변경에 실패했습니다.');
    }
}

// 요일 토글
function toggleDay(btn) {
    btn.classList.toggle('active');
    updateSelectAllCheckbox();
}

// 전체 요일 선택/해제
function toggleAllDays(checked) {
    const dayBtns = document.querySelectorAll('#daySelector .day-btn');
    dayBtns.forEach(btn => {
        if (checked) {
            btn.classList.add('active');
        } else {
            btn.classList.remove('active');
        }
    });
}

// 전체 선택 체크박스 상태 업데이트
function updateSelectAllCheckbox() {
    const dayBtns = document.querySelectorAll('#daySelector .day-btn');
    const activeBtns = document.querySelectorAll('#daySelector .day-btn.active');
    document.getElementById('selectAllDays').checked = dayBtns.length === activeBtns.length;
}

// 선택된 요일 가져오기
function getSelectedDays() {
    const activeBtns = document.querySelectorAll('#daySelector .day-btn.active');
    return Array.from(activeBtns).map(btn => parseInt(btn.dataset.day));
}

// 글자 수 업데이트
function updateCharCount() {
    const content = document.getElementById('content').value;
    document.getElementById('charCount').textContent = content.length;
}

// 정렬 설정
function setSortBy(sortType, btn) {
    // 버튼 활성화 상태 변경
    document.querySelectorAll('.sort-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    // 정렬 실행
    sortPosts(sortType);
}

// 포스트 정렬
function sortPosts(sortType) {
    const postList = document.getElementById('postList');
    const items = Array.from(postList.querySelectorAll('.post-item'));

    items.sort((a, b) => {
        if (sortType === 'schedule_time') {
            const aHour = parseInt(a.dataset.hour);
            const aMinute = parseInt(a.dataset.minute);
            const bHour = parseInt(b.dataset.hour);
            const bMinute = parseInt(b.dataset.minute);
            return (aHour * 60 + aMinute) - (bHour * 60 + bMinute);
        } else {
            // recently_updated
            return parseInt(b.dataset.updated) - parseInt(a.dataset.updated);
        }
    });

    // DOM 재정렬
    items.forEach(item => postList.appendChild(item));
}

// 필터 모달 열기
function openFilterModal() {
    document.getElementById('filterModal').classList.remove('hidden');
    updateFilterTimeRange();
}

// 필터 모달 닫기
function closeFilterModal() {
    document.getElementById('filterModal').classList.add('hidden');
}

// 필터 요일 토글
function toggleFilterDay(btn) {
    btn.classList.toggle('active');
    updateFilterSelectAllCheckbox();
}

// 필터 전체 요일 선택/해제
function toggleAllFilterDays(checked) {
    const dayBtns = document.querySelectorAll('#filterDaySelector .day-btn');
    dayBtns.forEach(btn => {
        if (checked) {
            btn.classList.add('active');
        } else {
            btn.classList.remove('active');
        }
    });
}

// 필터 전체 선택 체크박스 상태 업데이트
function updateFilterSelectAllCheckbox() {
    const dayBtns = document.querySelectorAll('#filterDaySelector .day-btn');
    const activeBtns = document.querySelectorAll('#filterDaySelector .day-btn.active');
    document.getElementById('filterSelectAllDays').checked = dayBtns.length === activeBtns.length;
}

// 필터 시간 범위 업데이트
function updateFilterTimeRange() {
    const startHour = document.getElementById('filterStartHour').value.padStart(2, '0');
    const startMinute = document.getElementById('filterStartMinute').value.padStart(2, '0');
    const endHour = document.getElementById('filterEndHour').value.padStart(2, '0');
    const endMinute = document.getElementById('filterEndMinute').value.padStart(2, '0');

    document.getElementById('filterTimeRange').textContent =
        `${startHour}:${startMinute} ~ ${endHour}:${endMinute}`;
}

// 필터 초기화
function resetFilter() {
    // 모든 요일 선택
    document.querySelectorAll('#filterDaySelector .day-btn').forEach(btn => {
        btn.classList.add('active');
    });
    document.getElementById('filterSelectAllDays').checked = true;

    // 시간 초기화
    document.getElementById('filterStartHour').value = '0';
    document.getElementById('filterStartMinute').value = '00';
    document.getElementById('filterEndHour').value = '23';
    document.getElementById('filterEndMinute').value = '55';

    updateFilterTimeRange();

    // 모든 포스트 표시
    document.querySelectorAll('.post-item').forEach(item => {
        item.style.display = '';
    });

    closeFilterModal();
}

// 필터 적용
function applyFilter() {
    const selectedDays = Array.from(document.querySelectorAll('#filterDaySelector .day-btn.active'))
        .map(btn => parseInt(btn.dataset.day));

    const startHour = parseInt(document.getElementById('filterStartHour').value);
    const startMinute = parseInt(document.getElementById('filterStartMinute').value);
    const endHour = parseInt(document.getElementById('filterEndHour').value);
    const endMinute = parseInt(document.getElementById('filterEndMinute').value);

    const startTime = startHour * 60 + startMinute;
    const endTime = endHour * 60 + endMinute;

    document.querySelectorAll('.post-item').forEach(item => {
        const hour = parseInt(item.dataset.hour);
        const minute = parseInt(item.dataset.minute);
        const itemTime = hour * 60 + minute;

        // 요일 파싱 (예: "[0, 1, 2]" 또는 "0,1,2" 형태)
        const daysStr = item.dataset.days || '';
        const itemDays = daysStr.replace(/[\[\]\s]/g, '').split(',')
            .filter(d => d !== '')
            .map(d => parseInt(d));

        // 시간 필터링
        const timeMatch = itemTime >= startTime && itemTime <= endTime;

        // 요일 필터링 (선택된 요일 중 하나라도 포함되면 표시)
        const dayMatch = selectedDays.length === 0 ||
            itemDays.some(day => selectedDays.includes(day));

        if (timeMatch && dayMatch) {
            item.style.display = '';
        } else {
            item.style.display = 'none';
        }
    });

    closeFilterModal();
}

// 필터 시간 변경 이벤트 리스너
document.addEventListener('DOMContentLoaded', function() {
    const filterTimeInputs = ['filterStartHour', 'filterStartMinute', 'filterEndHour', 'filterEndMinute'];
    filterTimeInputs.forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener('change', updateFilterTimeRange);
        }
    });
});
