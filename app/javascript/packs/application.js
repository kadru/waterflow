// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';
import M from 'materialize-css';

Turbolinks.start();
Rails.start();
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

let sidenavs;
let tooltips;

document.addEventListener('turbolinks:load', () => {
  M.Datepicker.init(document.querySelectorAll('.datepicker'));
  M.FormSelect.init(document.querySelectorAll('select'));
  M.FloatingActionButton.init(document.querySelectorAll('.fixed-action-btn'));
  sidenavs = M.Sidenav.init(document.querySelectorAll('.sidenav'));
  tooltips = M.Tooltip.init(document.querySelectorAll('.tooltipped'));
  
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
