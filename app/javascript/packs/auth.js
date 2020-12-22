// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
require("jquery")
require("bootstrap/dist/js/bootstrap.bundle")
require("jquery.easing/jquery.easing")
require('@fortawesome/fontawesome-free/js/all')
require('imports-loader?define=>false!datatables.net')(window, $)
require('imports-loader?define=>false!datatables.net-bs4')(window, $)
require('./shared/flash_msg')
const images = require.context('../img', true)
const imagePath = (name) => images(name, true)

// 提示信息
window.toastr = require('toastr/toastr')
window.toastr.options.closeButton = true
window.toastr.options.closeDuration = 1000;
window.toastr.options.progressBar = true;
window.toastr.options.closeEasing = 'swing';

import 'styles/auth'

