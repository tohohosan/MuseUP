document.addEventListener('turbo:load', function() {
    const tabs = document.querySelectorAll('.tabs input[type="radio"]'); //ラジオボタンを取得
    const contents = document.querySelectorAll('.tab-content'); //タブに対応するコンテンツを取得

    const urlParams = new URLSearchParams(window.location.search); // URLからクエリパラメータ(ex.?tab=2)を取得
    const tabParam = urlParams.get('tab') || '1'; // 'tab' パラメータの値を取得、なければ1を選択

    // タブをアクティブにする関数
    function activateTab(tabIndex) {
        // タブとコンテンツの表示切り替え
        tabs.forEach((tab, index) => {
            const content = contents[index]; // タブに対応するコンテンツを取得
            if (index + 1 == tabIndex) { // インデックスは1から始まる
                tab.checked = true; // タブをアクティブにする
                content.style.display = 'block'; // コンテンツを表示
            } else {
                tab.checked = false; // タブを非アクティブにする
                content.style.display = 'none'; // コンテンツを非表示
            }
        });
    }

    // ページ読み込み時にタブをアクティブにする
    activateTab(tabParam);

    // タブクリック時の処理
    tabs.forEach((tab, index) => {
        tab.addEventListener('change', () => {
            const tabIndex = index + 1; // タブのインデックスは1から始まる

            // タブの表示切り替え
            activateTab(tabIndex);

            // URL のクエリパラメータを更新(ex.?tab=2)
            const url = new URL(window.location.href);
            url.searchParams.set('tab', tabIndex); //'tab' パラメータを設定
            window.history.replaceState(null, '', url.toString()); //ページのURLを更新
        });
    });

    // ページネーションリンクのクリック処理
    function updatePageLinks(container, paramName) {
        if (!container) return; // コンテナが存在しない場合は処理しない

        container.addEventListener('click', (event) => {
            const link = event.target.closest('a'); // クリックされた要素がリンクか判定
                if (link) {
                    event.preventDefault(); // ページ遷移をキャンセル
                    const url = new URL(link.href); // リンク先のURLを取得

                // URL からページ番号を取得
                const page = url.searchParams.get(paramName);
                const currentUrl = new URL(window.location.href);
                currentUrl.searchParams.set(paramName, page);  // ページ番号を URL に反映

                // URL のクエリパラメータを更新
                window.history.pushState(null, '', currentUrl.toString());

                // ページネーションの内容を非同期で更新
                fetch(link.href, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
                    .then(response => response.text()) // レスポンスをテキストとして取得
                    .then(html => {
                        // 取得した HTML をコンテナに反映
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

    // ページネーションのコンテナを取得
    const reviewsPagination = document.querySelector('#reviews-pagination');
    const listsPagination = document.querySelector('#lists-pagination');

    // レビューとリストのページネーションリンクを更新
    updatePageLinks(reviewsPagination, 'reviews_page');
    updatePageLinks(listsPagination, 'lists_page');

    // ブラウザの戻る・進むボタンでタブを切り替える
    window.addEventListener('popstate', () => {
        // URL のクエリパラメータからタブを取得
        const newUrlParams = new URLSearchParams(window.location.search);
        const newTabParam = newUrlParams.get('tab') || '1'; // 'tab' パラメータの値を取得、なければ1を選択
        activateTab(newTabParam);
    });
});