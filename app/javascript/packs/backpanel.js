// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
// rails ujs
window.Rails = require("@rails/ujs")
if(Rails.fire(document, "rails:attachBindings")) {
  Rails.start();
}

// 提示信息
window.toastr = require('toastr/toastr')
window.toastr.options.closeButton = true
window.toastr.options.closeDuration = 1000;
window.toastr.options.progressBar = true;
window.toastr.options.closeEasing = 'swing';
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
window.$ = window.jQuery = require("jquery");
require('bootstrap/dist/js/bootstrap.bundle')
require('@fortawesome/fontawesome-free/js/fontawesome')
// require('jquery-slimscroll/jquery.slimscroll')
require('fastclick')
require('./src/app')
import { App, addTabs, closeCurrentTab, scrollTabRight, closeOtherTabs, refreshTab, closeTab, scrollTabLeft } from './src/app_iframe';
window.App = App;
window.addTabs = addTabs;
window.closeCurrentTab = closeCurrentTab;
window.scrollTabRight = scrollTabRight;
window.closeOtherTabs = closeOtherTabs;
window.refreshTab = refreshTab;
window.closeTab = closeTab;
window.scrollTabLeft = scrollTabLeft;
// dialog
window.dialog = require('art-dialog/src/dialog-plus')
// validate
require('./shared/validationEngine/jquery.validationEngine.min')
require('./shared/validationEngine/jquery.validationEngine-zh_CN')

import 'styles/backpanel'
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
const images = require.context('../img', true)
const imagePath = (name) => images(name, true)