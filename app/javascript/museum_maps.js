// 地図とマーカーを初期化
function initMap() {
    const mapElement = document.getElementById("map");
    if (!mapElement) return; // マップ要素が存在しない場合は終了

    const pageType = mapElement.dataset.pageType; // ページタイプを取得
    const mapOptions = { zoom: 7.3 };

    if (pageType === "detail") {
        setupDetailMap(mapElement, mapOptions); // ミュージアム詳細ページの場合
    } else {
        setupListMap(mapElement, mapOptions); // ミュージアム一覧ページの場合
    }
}

// 詳細ページの地図を設定
function setupDetailMap(mapElement, mapOptions) {
    const latitude = parseFloat(mapElement.dataset.latitude);
    const longitude = parseFloat(mapElement.dataset.longitude);
    const museumName = mapElement.dataset.museumName || "ミュージアム";

    mapOptions.center = { lat: latitude, lng: longitude };
    mapOptions.zoom = 10; // 詳細ページではズームレベルを10に設定

    const map = new google.maps.Map(mapElement, mapOptions);

    new google.maps.Marker({
        position: { lat: latitude, lng: longitude },
        map: map,
        title: museumName,
    });
}

// 一覧ページの地図を設定
function setupListMap(mapElement, mapOptions) {
    const center = JSON.parse(mapElement.dataset.center);
    mapOptions.center = center;

    const map = new google.maps.Map(mapElement, mapOptions);

    // 一覧ページ用のミュージアムデータを取得してマーカーを追加
    const museumDataElement = document.getElementById("museum-data");
    if (!museumDataElement) return;

    const museums = JSON.parse(museumDataElement.textContent);

    if (museums.length > 0) {
        addMarkersToMap(museums, map);
    } else {
        alert("該当するミュージアムがありません。地図の中心を初期位置に設定しました。");
    }
}

// Turboフックを追加してページ遷移時にGoogle Mapを再初期化
document.addEventListener("turbo:load", () => {
    initMap(); // Turboページロード時に地図を初期化
    setupLocationSearchButton();
});

document.addEventListener('DOMContentLoaded', () => {
    // 閉じるボタンの取得
    const closeModalButton = document.getElementById('close-overview-modal');
    const museumDetailModal = document.getElementById('museumDetailModal');

    // 要素が存在する場合のみイベントリスナーを追加
    if (closeModalButton && museumDetailModal) {
        closeModalButton.addEventListener('click', () => {
            museumDetailModal.close(); // モーダルを閉じる
        });
    }
});

// マーカー追加
function addMarkersToMap(museums, map) {
    museums.forEach((museum) => {
        const marker = new google.maps.Marker({
            position: { lat: museum.latitude, lng: museum.longitude },
            map: map,
            title: museum.name,
        });

        marker.addListener('click', () => {
            fetch(`/museums/${museum.id}.json`)
                .then((response) => response.json())
                .then((data) => {
                    if (data) {
                        const museumImage = document.getElementById('museumImage');
                    if (data.images && data.images.length > 0) {
                        museumImage.src = data.images[0];
                        museumImage.style.display = 'block';
                        } else {
                        museumImage.style.display = 'none';
                    }

                    document.getElementById('museumTitle').innerText = data.name;
                    document.getElementById('museumDescription').innerText = data.description;
                    document.getElementById('museumLocation').innerText = data.address;
                    document.getElementById('museumDetailLink').href = `/museums/${data.id}`;

                    document.getElementById('museumDetailModal').showModal();
                } else {
                    console.error("Unexpected data format:", data);
                }
            })
            .catch(error => console.error('Error fetching museum details:', error));
        });
    });
}

// 位置情報で近隣のミュージアムを取得
function fetchNearestMuseum(userLocation) {
    fetch(`/museums/nearest?latitude=${userLocation.lat}&longitude=${userLocation.lng}`)
        .then((response) => response.json())
        .then((data) => {
            if (data.museum) {
                const mapElement = document.getElementById('map');
                const map = new google.maps.Map(mapElement, {
                    center: userLocation,
                    zoom: 11,
                });

                // 最寄りのミュージアムをマップに追加
                addMarkersToMap([data.museum], map);
            } else {
                alert("近くにミュージアムが見つかりませんでした。");
            }
        })
        .catch((error) => {
            console.error("エラーが発生しました:", error);
        });
}

document.addEventListener('DOMContentLoaded', () => {
    setupLocationSearchButton(); // 現在地検索ボタンの初期化

    // モーダルを開くボタンを取得
    const showSearchModalButton = document.getElementById('show-search-modal-btn');
    const searchModal = document.getElementById('searchModal');

    // モーダルを開くボタンにクリックイベントを追加
    showSearchModalButton.addEventListener('click', () => {
        searchModal.showModal(); // 検索モーダルを表示
    });

    // 閉じるボタンを取得
    const closeSearchModalButton = document.getElementById('close-search-modal');

    // 閉じるボタンにクリックイベントを追加
    closeSearchModalButton.addEventListener('click', () => {
        searchModal.close(); // 検索モーダルを閉じる
    });
});

function setupLocationSearchButton() {
    document.getElementById("location-search-btn").addEventListener("click", () => {
        if (!navigator.geolocation) {
            alert("お使いのブラウザは位置情報をサポートしていません。");
            return;
        }

        navigator.geolocation.getCurrentPosition(
            (position) => {
                const userLocation = {
                    lat: position.coords.latitude,
                    lng: position.coords.longitude,
                };
                fetchNearestMuseum(userLocation);

                // モーダルを閉じる（検索モーダルの場合）
                const searchModal = document.getElementById("searchModal");
                searchModal.close();
            },
            (error) => {
                let message;
                switch (error.code) {
                    case error.PERMISSION_DENIED:
                        message = "位置情報の利用が拒否されました。";
                        break;
                    case error.POSITION_UNAVAILABLE:
                        message = "位置情報が利用できません。";
                        break;
                    case error.TIMEOUT:
                        message = "位置情報の取得がタイムアウトしました。";
                        break;
                    default:
                    message = "位置情報の取得中にエラーが発生しました。";
        }
            alert(message);
            }
        );
    });
}

// コールバックとして利用するためグローバルスコープに設定
window.initMap = initMap;
// 初期化関数をエクスポート
export { initMap, setupLocationSearchButton };