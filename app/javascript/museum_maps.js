function initMap() {
    const mapElement = document.getElementById("map");
    if (!mapElement) return;

    const pageType = mapElement.dataset.pageType;
    const mapOptions = { zoom: 7.3 };

    if (pageType === "detail") {
        setupDetailMap(mapElement, mapOptions);
    } else {
        setupListMap(mapElement, mapOptions);
    }
}

// 詳細ページの地図を設定
function setupDetailMap(mapElement, mapOptions) {
    const latitude = parseFloat(mapElement.dataset.latitude);
    const longitude = parseFloat(mapElement.dataset.longitude);
    const museumName = mapElement.dataset.museumName || "ミュージアム";

    mapOptions.center = { lat: latitude, lng: longitude };
    mapOptions.zoom = 10;

    const map = new google.maps.Map(mapElement, mapOptions);

    new google.maps.Marker({
        position: { lat: latitude, lng: longitude },
        map: map,
        title: museumName,
    });
}

// 一覧ページの地図を設定
function setupListMap(mapElement, mapOptions) {
    const centerData = mapElement.dataset.center;
    if (centerData) {
        try {
            const center = JSON.parse(centerData);
            mapOptions.center = center;
        } catch (error) {
            console.error("Invalid JSON in data-center:", error);
            return;
        }
    } else {
        console.error("data-center attribute not found.");
        return;
    }

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
    const mapElement = document.getElementById("map");
    if (mapElement) {
        const pageType = mapElement.dataset.pageType;
        if (pageType === "detail") {
            setupDetailMap(mapElement, { zoom: 10 });
        } else {
            setupListMap(mapElement, { zoom: 7.3 });
        }
    }
    setupLocationSearchButton();
});

// 閉じるボタンをクリックしたときにモーダルを閉じる
document.addEventListener('DOMContentLoaded', () => {
    const closeModalButton = document.getElementById('close-overview-modal');
    const museumDetailModal = document.getElementById('museumDetailModal');

    if (closeModalButton && museumDetailModal) {
        closeModalButton.addEventListener('click', () => {
            museumDetailModal.close();
        });
    }
});

// 地図上のマーカーの処理
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

// 検索モーダルの処理
document.addEventListener('DOMContentLoaded', () => {
    setupLocationSearchButton(); // 現在地検索ボタンの処理

    const showSearchModalButton = document.getElementById('show-search-modal-btn');
    const searchModal = document.getElementById('searchModal');

    if (showSearchModalButton && searchModal) {
        showSearchModalButton.addEventListener('click', () => {
            searchModal.showModal();
        });
    }

    const closeSearchModalButton = document.getElementById('close-search-modal');

    if (closeSearchModalButton && searchModal) {
        closeSearchModalButton.addEventListener('click', () => {
            searchModal.close();
        });
    }
});

// 現在地検索ボタンの処理
function setupLocationSearchButton() {
    const searchButton = document.getElementById("location-search-btn");
    if (!searchButton) return;

    searchButton.addEventListener("click", () => {
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

                const searchModal = document.getElementById("searchModal");
                if (searchModal) {
                    searchModal.close();
                }
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

// グローバルスコープに設定
window.initMap = initMap;
// 初期化関数をエクスポート
export { initMap, setupLocationSearchButton };