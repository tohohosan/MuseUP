// Google Maps APIが読み込まれた後にオートコンプリートを初期化
document.addEventListener('DOMContentLoaded', function () {
    const inputName = document.getElementById('Name');
    const inputAddress = document.getElementById('Address');
    if (!inputAddress) return;  // Addressフィールドが存在しないページでは実行しない

    // Google Maps APIがロードされているか確認
    if (typeof google === 'undefined' || !google.maps || !google.maps.places) {
        console.error('Google Maps API is not loaded.');
        return;
    }

    // オートコンプリートのオプション
    const options = {
        types: ['establishment'],
        componentRestrictions: { country: 'JP' },
    };

    // オートコンプリート適用
    const autocompleteName = new google.maps.places.Autocomplete(inputName, options);
    const autocompleteAddress = new google.maps.places.Autocomplete(inputAddress, options);

    // 名前のオートコンプリートが選択されたとき
    autocompleteName.addListener('place_changed', function() {
        const place = autocompleteName.getPlace();
        inputName.value = place.name;
        inputAddress.value = place.formatted_address;
    });

    // 住所のオートコンプリートが選択されたとき
    autocompleteAddress.addListener('place_changed', function() {
        const place = autocompleteAddress.getPlace();
        inputName.value = place.name;
        inputAddress.value = place.formatted_address;
    });
});
