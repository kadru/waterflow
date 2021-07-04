// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
// require("@rails/activestorage").start()
require("materialize-css")
// require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
const M = require('materialize-css');
const datePicker = require('materialize/datePicker')
const sidenav = require('materialize/sidenav')
const formSelect = require('materialize/formSelect')
const floatingActionButton = require('materialize/floatingActionButton')
const tooltip = require('materialize/tooltip')

let sidenavs;
let tooltips;

document.addEventListener('turbolinks:load', () => {
  datePicker.default.initialize();
  formSelect.default.initialize();
  sidenavs = sidenav.default.initialize();
  floatingActionButton.default.initialize();
  tooltips = tooltip.default.initialize();
  
  // to set active prefilled inputs
  setTimeout(() => {
    M.updateTextFields();
  }, 100);
  M.Dropdown.init(document.querySelectorAll('.dropdown-trigger'))
});

document.addEventListener('turbolinks:before-cache', () => {
  //sidenav.default.destroy(document.querySelectorAll('.sidenav'));
  sidenavs.forEach((s)=>{
    s.destroy();
  });

  tooltips.forEach((t) =>{
    t.destroy();
  });
});
