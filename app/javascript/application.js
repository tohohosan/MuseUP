// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import './place_autocomplete.js';
import { initMap } from "museums_map";

window.initMap = initMap;

// Rails UJS の読み込み
import Rails from "@rails/ujs";
Rails.start();
