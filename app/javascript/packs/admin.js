// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// rails ujs
window.Rails = require("@rails/ujs")
if(Rails.fire(document, "rails:attachBindings")) {
  Rails.start();
}
window.ActiveStorage = require("@rails/activestorage")
ActiveStorage.start()
require("channels")
require("bootstrap/dist/js/bootstrap.bundle")
require('@fortawesome/fontawesome-free/js/all')
require('imports-loader?define=>false!datatables.net')(window, $)
require('imports-loader?define=>false!datatables.net-bs4')(window, $)

// validate
require('./shared/validationEngine/jquery.validationEngine.min')
require('./shared/validationEngine/jquery.validationEngine-zh_CN')
require('./shared/ztree/jquery.ztree.all.min')
require('./shared/flash_msg')
require('./shared/qrcode/jquery.qrcode.min')
require('./shared/common')


window.jQuery = jQuery
window.$ = $
//jquery_nested_form
require('jquery_nested_form')
// seelct2
require('select2')
// 日期选择
window.flatpickr = require('flatpickr')
require('flatpickr/dist/l10n/zh') // 汉化
window.flatpickr.localize(flatpickr.l10ns.zh);
// 提示信息
window.toastr = require('toastr/toastr')
window.toastr.options.closeButton = true
window.toastr.options.closeDuration = 1000;
window.toastr.options.progressBar = true;
window.toastr.options.closeEasing = 'swing';
// ztree 方法
import { addHoverDom, removeHoverDom, beforeDrag, beforeDrop, beforeEditName, beforeRemove, onDrop, onRemove, beforeRename, onRename, onClick } from './shared/ztree/ztree';
window.addHoverDom = addHoverDom 
window.removeHoverDom = removeHoverDom
window.beforeDrag  = beforeDrag
window.beforeDrop = beforeDrop
window.beforeEditName = beforeEditName
window.beforeRemove = beforeRemove
window.onDrop = onDrop
window.onRemove = onRemove
window.beforeRename = beforeRename
window.onRename = onRename
window.onClick  = onClick
// 滑块
require('bootstrap-slider')
require('bootstrap-fileinput')
require('bootstrap-fileinput/themes/explorer-fas/theme.min.js')
require('bootstrap-fileinput/js/locales/zh') // 汉化

// table
require('bootstrap-table')
require('bootstrap-table/dist/locale/bootstrap-table-zh-CN.min')
require('bootstrap-table/dist/extensions/fixed-columns/bootstrap-table-fixed-columns.min')

import 'styles/admin'
// dialog
window.dialog = require('art-dialog/src/dialog-plus')


$.ajaxSetup({
    beforeSend: function(xhr) {
        xhr.setRequestHeader("X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content"));
    }
});
window.ajax = $.ajax;

const images = require.context('../img', true)
const imagePath = (name) => images(name, true)