document.addEventListener('DOMContentLoaded', function() {
    const tabs = document.querySelectorAll('.tabs input[type="radio"]');
    const contents = document.querySelectorAll('.tab-content');

    // URLからクエリパラメータを取得
    const urlParams = new URLSearchParams(window.location.search);
    const tabParam = urlParams.get('tab') || '1'; // デフォルトで1を選択

    // 初期タブ状態の設定
    function activateTab(tabIndex) {
        tabs.forEach((tab, index) => {
        const content = contents[index];
        if (index + 1 == tabIndex) {
            tab.checked = true;
            content.style.display = 'block';
        } else {
            tab.checked = false;
            content.style.display = 'none';
        }
    });
}

// 初期表示
activateTab(tabParam);

// タブクリック時の処理
tabs.forEach((tab, index) => {
    tab.addEventListener('change', () => {
        const tabIndex = index + 1;

        // タブの表示切り替え
        activateTab(tabIndex);

        // URL の更新
        const url = new URL(window.location.href);
        url.searchParams.set('tab', tabIndex);
        window.history.replaceState(null, '', url.toString());
    });
});

// ページネーションリンクのクリック処理
function updatePageLinks(container, paramName) {
    if (!container) return;

    container.addEventListener('click', (event) => {
        const link = event.target.closest('a');
            if (link) {
                event.preventDefault();
                const url = new URL(link.href);

                // ページ番号の更新
                const page = url.searchParams.get(paramName);
                const currentUrl = new URL(window.location.href);
                currentUrl.searchParams.set(paramName, page);

                // ページ番号を URL に反映
                window.history.pushState(null, '', currentUrl.toString());

                // ページネーションの内容を非同期で更新
                fetch(link.href, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
                    .then(response => response.text())
                    .then(html => {
                        const newContent = new DOMParser().parseFromString(html, 'text/html');
                        const updatedContainer = newContent.querySelector(`#${container.id}`);
                        container.innerHTML = updatedContainer.innerHTML;

                        // イベントリスナーを再登録
                        updatePageLinks(container, paramName);
                    })
                    .catch(error => console.error('エラー:', error));
            }
        });
    }

    // 各ページネーションに処理を適用
    const reviewsPagination = document.querySelector('#reviews-pagination');
    const listsPagination = document.querySelector('#lists-pagination');
    updatePageLinks(reviewsPagination, 'reviews_page');
    updatePageLinks(listsPagination, 'lists_page');

    // 履歴変更時のタブとページ更新対応
    window.addEventListener('popstate', () => {
        const newUrlParams = new URLSearchParams(window.location.search);
        const newTabParam = newUrlParams.get('tab') || '1';
        activateTab(newTabParam);
    });
});