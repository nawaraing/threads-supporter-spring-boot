// schedule-picker.js - Post scheduling UI logic

document.addEventListener('DOMContentLoaded', function() {

    const recurringRadio = document.getElementById('recurring');
    const oneTimeRadio = document.getElementById('oneTime');
    const daysSection = document.getElementById('daysSection');

    // Toggle between recurring and one-time
    function updateFormSections() {
        if (recurringRadio && recurringRadio.checked) {
            if (daysSection) daysSection.style.display = 'block';
        } else {
            if (daysSection) daysSection.style.display = 'none';
        }
    }

    if (recurringRadio && oneTimeRadio) {
        recurringRadio.addEventListener('change', updateFormSections);
        oneTimeRadio.addEventListener('change', updateFormSections);
        updateFormSections();
    }

    // Character counter
    const contentTextarea = document.getElementById('content');
    const charCount = document.getElementById('charCount');

    if (contentTextarea && charCount) {
        contentTextarea.addEventListener('input', function() {
            charCount.textContent = this.value.length;
        });
        charCount.textContent = contentTextarea.value.length;
    }

    // Add/Remove image URL fields
    const addImageUrlBtn = document.getElementById('addImageUrl');
    const imageUrlsContainer = document.getElementById('imageUrlsContainer');

    if (addImageUrlBtn && imageUrlsContainer) {
        addImageUrlBtn.addEventListener('click', function() {
            const count = imageUrlsContainer.querySelectorAll('.input-group').length;
            if (count >= 10) {
                showToast('최대 10개의 이미지만 추가할 수 있습니다.', 'warning');
                return;
            }

            const div = document.createElement('div');
            div.className = 'input-group mb-2';
            div.innerHTML = `
                <input type="url" class="form-control image-url"
                       placeholder="https://example.com/image.jpg">
                <button type="button" class="btn btn-outline-danger remove-url">
                    <i class="bi bi-x"></i>
                </button>
            `;
            imageUrlsContainer.appendChild(div);
        });

        imageUrlsContainer.addEventListener('click', function(e) {
            if (e.target.classList.contains('remove-url') || e.target.closest('.remove-url')) {
                e.target.closest('.input-group').remove();
            }
        });
    }

    // Form submission
    const postForm = document.getElementById('postForm');
    if (postForm) {
        postForm.addEventListener('submit', async function(e) {
            e.preventDefault();

            const postId = document.getElementById('postId')?.value;
            const isRecurring = document.querySelector('input[name="isRecurring"]:checked')?.value === 'true';

            // Collect days of week
            const daysOfWeek = [];
            document.querySelectorAll('input[name="daysOfWeek"]:checked').forEach(cb => {
                daysOfWeek.push(parseInt(cb.value));
            });

            // Collect image URLs
            const imageUrls = [];
            document.querySelectorAll('.image-url').forEach(input => {
                if (input.value.trim()) {
                    imageUrls.push(input.value.trim());
                }
            });

            const data = {
                content: document.getElementById('content').value,
                isRecurring: isRecurring,
                daysOfWeek: isRecurring ? daysOfWeek : null,
                hour: parseInt(document.getElementById('hour').value),
                minute: parseInt(document.getElementById('minute').value),
                imageUrls: imageUrls.length > 0 ? imageUrls : null,
                isActive: true
            };

            // Validation
            if (!data.content.trim()) {
                showToast('내용을 입력해주세요.', 'warning');
                return;
            }

            if (isRecurring && daysOfWeek.length === 0) {
                showToast('최소 하나의 요일을 선택해주세요.', 'warning');
                return;
            }

            try {
                const method = postId ? 'PUT' : 'POST';
                const url = postId ? `/api/posts/${postId}` : '/api/posts';

                await apiFetch(url, {
                    method: method,
                    body: JSON.stringify(data)
                });

                showToast(postId ? '수정되었습니다.' : '저장되었습니다.', 'success');
                setTimeout(() => window.location.href = '/posts', 1000);

            } catch (error) {
                console.error('Error saving post:', error);
                showToast('저장에 실패했습니다.', 'danger');
            }
        });
    }
});
