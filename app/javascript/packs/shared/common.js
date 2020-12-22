$.isBlank = function(obj) {
  return(!obj || $.trim(obj) === "");
};

$(function() {
  // validate
  $(".valid_engine").validationEngine('attach', {
    promptPosition:"bottomLeft: 0, 15",
    showArrow: false,
    maxErrorsPerField: 1,
    addPromptClass: 'formError-text',
    addSuccessCssClassToField: 'is-valid',
    addFailureCssClassToField: 'is-invalid'
  });
  $('.valid_engine').bind('jqv.form.validating', function(event){
    $('.valid_engine').addClass('valid_engine-validated');
  });
  // nested_form
  // add
  $(document).on('click', '[data-form-prepend]', function(event) {
    var obj = $($(this).attr("data-form-prepend"));
    var time_number = new Date().getTime();
    obj.find("input, select, textarea").each(function() {
      $(this).attr("name", function() {
        return $(this)
          .attr("name")
          .replace("new_record",time_number )
      });
      if($(this).attr("id")){
        $(this).attr("id",function(){
        return $(this)
          .attr("id")
          .replace("new_record", time_number)
      })
    }
      
    });
    obj.insertBefore(this);
    return false;
  });
  // remove
  $(document).on('click', '[data-form-remove]', function(event) {
    $(this).prev('input:hidden').val("1");
    $(this).parents('.nested_form').hide();
  });

  // select2
  $(".select2").select2({ 
    theme: 'bootstrap4',
     language: {
          noResults: function(params) {
              return "暂无数据";
          }
     }
  });
  
  //  select2 动态选项创建 
  $(".select2_tags").select2({
    tags: true, theme: 'bootstrap4',
    language: {
         noResults: function(params) {
             return "暂无数据";
         }
    }
  })
  // 日期选择 
  // 默认年月日
  flatpickr(".flatpickr");
  // 日期选择含具体时间
  flatpickr(".flatpickr_time",{
    enableTime: true,
    dateFormat: "Y-m-d H:i",
  });
  // 滑块 bootstrap_silder
  // 百分比
  var  slider_percentage = $("input.slider_percentage").slider(
    { min: 0, max: 100, value: 0, focus: true}
  );
  // 赋默认值
  $(".slider_percentage").each(function(index, el) {
    slider_percentage.slider('setValue', $(this).data().sliderValue)
  });
  
  

  // 分页跳转
  $(document).on('click blur', '.jump_page', function(event) {
     /* Act on the event */
     var reg = /page=\d+/;
     var href = '';
     if (isNaN($("#go_to_page").val())) {
       return false
     }
     if ($("#go_to_page").val() <= 0) {
       $("#go_to_page").val(1)
     }
     if(parseInt($("#go_to_page").val()) > parseInt($("#go_to_page").attr("max"))){
       $("#go_to_page").val($("#go_to_page").attr("max"))
     }
     if(reg.test($('.go_to_href').attr('href'))){
       href = $('.go_to_href').attr('href').replace(reg,"page="+$("#go_to_page").val());
     }else{
       href = $('.go_to_href').attr('href') + "&page="+$("#go_to_page").val();
     }
     if(!(/\?/.test(href))){
       href = href.replace('&page','?page');
     }
     $('.go_to_href').attr('href',href)
   });
  // tooltip
  $('[data-toggle="tooltip"]').tooltip();
  // 级联下拉框
  $(document).on('change', 'select.multi-level', function() {
      $selector = $(this);

      $('#' + $selector.attr("aim_id")).val($selector.val());

      if ($.isBlank($selector.attr("aim_id"))) {
          $selector.siblings('input')[0].value = $selector.val();
      }

      if (!$.isBlank($selector.attr("text_id"))) {
          $('#' + $selector.attr("text_id")).val($selector.find("option:selected").text());
      }

      $.ajax({
          type: "get",
          // url: '/dynamic_selects?id=' + $selector.val() + '&otype=' + $selector.attr("otype") + '&aim_id=' + $selector.attr("aim_id") + '&other=' + $selector.attr("other") + '&text_id=' + $selector.attr("text_id"),
          url: '/dynamic_selects?id=' + $selector.val() + '&otype=' + $selector.attr("otype") + '&aim_id=' + $selector.attr("aim_id") + '&other=' + $selector.attr("other") + '&text_id=' + $selector.attr("text_id") + '&prompt=' + $selector.attr("prompt") + '&oclass=' + $selector.attr("class"),
          beforeSend: function(XMLHttpRequest) {

          },
          async: false,
          success: function(data, textStatus) {
            $selector.nextAll('select').remove();
            // $selector.parent().append(data);
            $selector.after(data);
          },
          complete: function(XMLHttpRequest, textStatus) {
              //HideLoading();
          },
          error: function() {
              //请求出错处理
          }
      });
  });
  
  // 限制金额
  $(document).on("keyup", ".money", function() {
      $(this).val($(this).val().replace(/[^\.|0-9]/g, ''))
      $(this).val($(this).val().match(/[0-9]*(\.){0,1}([0-9]{0,2})/)[0])
      var price = $(this).val()
      if (parseFloat($(this).attr('max')) < parseFloat(price)) {
          price = parseFloat($(this).attr('max'));
      }
      $(this).val(price);
  })
  
  // 整数
  $(document).on("keyup", ".integer", function() {
      var num =  parseInt($(this).val())
      if(isNaN(num)){ num = 0}
      $(this).val(num)
      var price = $(this).val()
      if (parseFloat($(this).attr('max')) < parseFloat(price)) {
          price = parseFloat($(this).attr('max'));
      }
      $(this).val(price);
  })
})

