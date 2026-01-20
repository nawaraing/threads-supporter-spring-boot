// posts.js - Scheduled posts management

document.addEventListener('DOMContentLoaded', function() {

    // Toggle post active status
    document.querySelectorAll('.toggle-btn').forEach(btn => {
        btn.addEventListener('click', async function() {
            const postId = this.dataset.id;

            try {
                await apiFetch(`/api/posts/${postId}/toggle`, { method: 'POST' });
                showToast('상태가 변경되었습니다.', 'success');
                setTimeout(() => location.reload(), 500);
            } catch (error) {
                showToast('상태 변경에 실패했습니다.', 'danger');
            }
        });
    });

    // Delete post
    document.querySelectorAll('.delete-btn').forEach(btn => {
        btn.addEventListener('click', async function() {
            const postId = this.dataset.id;

            const confirmed = await confirmAction('이 예약 포스트를 삭제하시겠습니까?');
            if (!confirmed) return;

            try {
                await apiFetch(`/api/posts/${postId}`, { method: 'DELETE' });
                showToast('삭제되었습니다.', 'success');
                setTimeout(() => location.reload(), 500);
            } catch (error) {
                showToast('삭제에 실패했습니다.', 'danger');
            }
        });
    });
});
