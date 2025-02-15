document.addEventListener('turbo:load', function() {
    const tabs = document.querySelectorAll('.tabs input[type="radio"]');
    const contents = document.querySelectorAll('.tab-content');
    const urlParams = new URLSearchParams(window.location.search);
    const tabParam = urlParams.get('tab') || '1';

    // タブの表示を切り替える
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

    // ページ読み込み時にタブをアクティブにする
    activateTab(tabParam);

    // タブがクリックされた時の処理
    tabs.forEach((tab, index) => {
        tab.addEventListener('change', () => {
            const tabIndex = index + 1;
            activateTab(tabIndex);

            // URL のクエリパラメータを更新(ex.?tab=2)
            const url = new URL(window.location.href);
            url.searchParams.set('tab', tabIndex);
            window.history.replaceState(null, '', url.toString());
        });
    });

    // ページネーションリンクのクリック処理
    function updatePageLinks(container, paramName) {
        if (!container) return;

        container.addEventListener('click', (event) => {
            const link = event.target.closest('a'); // クリックされた要素がリンクか判定
                if (link) {
                    event.preventDefault(); // ページ全体の遷移をキャンセル
                    const url = new URL(link.href);

                const page = url.searchParams.get(paramName);
                const currentUrl = new URL(window.location.href);
                currentUrl.searchParams.set(paramName, page);  // ページ番号を URL に反映

                // ページネーションのリンクをクリックした時にブラウザの履歴に追加しない
                window.history.pushState(null, '', currentUrl.toString());

                // ページネーションのリンクをクリックした時にページを非同期で取得
                fetch(link.href, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
                    .then(response => response.text())
                    .then(html => {
                        // 取得した HTML をパースしてコンテナの中身を更新
                        const newContent = new DOMParser().parseFromString(html, 'text/html');
                        const updatedContainer = newContent.querySelector(`#${container.id}`);
                        container.innerHTML = updatedContainer.innerHTML;

                        // 更新後に再度イベントリスナーを再登録
                        updatePageLinks(container, paramName);
                    })
                    .catch(error => console.error('エラー:', error));
            }
        });
    }

    // ページネーションの要素を取得して設定
    const reviewsPagination = document.querySelector('#reviews-pagination');
    const listsPagination = document.querySelector('#lists-pagination');
    updatePageLinks(reviewsPagination, 'reviews_page');
    updatePageLinks(listsPagination, 'lists_page');

    // ブラウザの戻る・進むボタンでタブを切り替える
    window.addEventListener('popstate', () => {
        const newUrlParams = new URLSearchParams(window.location.search);
        const newTabParam = newUrlParams.get('tab') || '1';
        activateTab(newTabParam);
    });
});