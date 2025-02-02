// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "place_autocomplete";

// Rails UJS の読み込み
import Rails from "@rails/ujs";
Rails.start();

document.addEventListener('turbo:load', function () {
    $(document).on('click', '.pagination a', function () {
        $.getScript(this.href);
        return false;
    });
});

import { initMap, setupLocationSearchButton } from "./museum_maps";

document.addEventListener("DOMContentLoaded", () => {
    initMap();
    setupLocationSearchButton();
});
