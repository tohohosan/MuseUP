function initMap() {
  const mapElement = document.getElementById('map');
  const mapOptions = {
    center: { lat: 35.14315728478154, lng: 136.91635162137968 },
    zoom: 7
  };
  const map = new google.maps.Map(mapElement, mapOptions);

  // ミュージアムデータを取得
  const museumDataElement = document.getElementById('museum-data');
  const museums = JSON.parse(museumDataElement.textContent);

  // ミュージアムごとにマーカーを追加
  museums.forEach((museum) => {
    const marker = new google.maps.Marker({
      position: { lat: museum.latitude, lng: museum.longitude },
      map: map,
      title: museum.name
    });

    marker.addListener('click', function() {
      fetch(`/museums/${museum.id}.json`)
        .then(response => response.json())
        .then(data => {
          document.getElementById('museumTitle').innerText = data.name;
          document.getElementById('museumDescription').innerText = data.description;
          document.getElementById('museumDetailLink').href = `/museums/${museum.id}`;
          document.getElementById('museumDetailModal').showModal();
        })
        .catch(error => console.error('Error fetching museum details:', error));
    });
  });
}

// グローバルスコープに登録
window.initMap = initMap;
