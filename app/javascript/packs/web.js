// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("jquery")
window.jQuery = jQuery
window.$ = $
import 'styles/web'

/*
 * 封装的方法
 * 
 */

  //切换tab
  $.fn.changeTab = function(options) {
    options = $.extend({
      //定义一个对象，设置默认值
      //点击选择区域
      checkedArea: $.noop,

      //切换区域
      changeArea: $.noop,

      //是否复用
      manyTimes: false,

      //给点击元素新增的元素
      checkedClass: 'active',

      callBack: $.noop,

    }, options);

    //主体区域
    var className = $(this).selector;

    //点击区域
    var checkedArea = options.checkedArea;

    //需要新增的class
    var checkedClass = options.checkedClass;

    //切换区域
    var changeArea = options.changeArea;

    //是否复用
    var manyTimes = options.manyTimes;

    //回调函数
    var callBack = options.callBack;

    //点击选择区域触发事件
    $(document).on('click', checkedArea, function() {
      var num = $(this).index();
      $(this).siblings(checkedArea).removeClass(checkedClass);
      $(this).addClass(checkedClass);
      if(manyTimes) {
        $(this).closest(className).eq(num).show().siblings().hide();
      }else{
        $(changeArea).hide();
        $(changeArea).eq(num).show();
      }
      //回调函数
      if(callBack) {
        callBack();
      }
    })

    return this;
  },
  
  $.fn.carousel = function(options) { //定义插件方法名
    options = $.extend({
      //定义一个对象，设置默认值

      //轮播方式（默认为按以透明度变化轮播）
      way: 'fade',

      //一列显示的图片数量（默认为1）
      num: 1,

      //滚动速度（默认为100）
      speed: 100,

      //滚动间隔时间（默认为100）
      timer: 100,

      //是否显示下圆角（默认为false）
      showButton: false,

      //是否显示左右箭头（默认为false）
      showArrow: false,

      //是否自动播放（默认为false）
      autoPlay: false,
      
      //图片高度是否需要自适应
      imgHeight: $.noop,

    }, options);

    //设置一页显示图片的个数，速度,是否显示下圆角和左右箭头，是否自动播放
    var way = options.way;
    var num = options.num;
    var speed = options.speed;
    var timer = options.timer;
    var showButton = options.showButton;
    var showArrow = options.showArrow;
    var autoPlay = options.autoPlay;
    var imgHeight=options.imgHeight;

    //获取页面元素
    var content = $(this);
    var contentUl = $(this).find('.carousel_ul');
    var contentLi = contentUl.children('li');
    var page_count = contentLi.length;
    
    
    //图片高度是否需要自适应
    if(imgHeight ==='auto'){
      //找到图片元素
      var $_img= $(this).find('img');
      content.height($_img.height());
    }
    
    //一面显示多图片时触发
    if(num > 1 && way === 'scrolls_x') {
      var li_width = content.width() / num;
      contentLi.width(li_width);
    } else if(num > 1 && way === 'scrolls_y') {
      var li_height = content.height() / num;
      contentLi.height(li_height);
    }

    //如果显示下圆角为true
    if(showButton && num === 1) {
      var positionUl = "<ul class='position_ul'></ul>";
      content.append(positionUl);
      var positionUl_$ = content.find('.position_ul');
      for(var i = 1; i <= page_count; i++) {
        positionUl_$.append("<li></li>");
      }
      positionUl_$.find('li').eq(0).addClass('cur');
      var id;
      var _this;
      positionUl_$.find('li').hover(function() {
        _this = $(this);
        id = setTimeout(mouseOver, 100);
      }, function() {
        if(id) {
          clearTimeout(id);
        }
      });
    }

    //如果显示左右箭头为true
    if(showArrow) {
      var prev = "<span class='prev'></span>";
      var next = "<span class='next'></span>";
      content.append(prev);
      content.append(next);
      var time = 0;
      content.children('.next').click(function() {
        //判断计时器是否处于关闭状态
        if(time == 0) {
          time = 1; //设定间隔时间（秒）

          //启动计时器，倒计时time秒后自动关闭计时器。
          var index = setInterval(function() {
            time--;
            if(time == 0) {
              clearInterval(index);
            }
          }, 500);

          playLeft();
        }
      });

      content.children('.prev').click(function() {
        playRight();
      });
    }
    //设置左移和右移函数
    var playLeft;
    var playRight;
    var mouseOver;

    switch(way) {

      //渐变(透明度)切换
      case 'fade':
        //隐藏所有li，显示第一个li
        contentLi.hide();
        contentLi.eq(0).show();
        contentUl.addClass('fade_ul');
        var i = 0;
        //左移函数
        playLeft = function() {
          i++;
          i = i > page_count - 1 ? 0 : i;
          positionUl_$.find('li').eq(i).addClass('cur').siblings().removeClass("cur");
          contentLi.eq(i).fadeIn(speed).siblings().fadeOut(speed);
        }

        //右移函数
        playRight = function() {
          i--;
          i = i < 0 ? page_count - 1 : i;
          positionUl_$.find('li').eq(i).addClass('cur').siblings().removeClass("cur");
          contentLi.eq(i).fadeIn(speed).siblings().fadeOut(speed);
        }

        //鼠标移入圆角函数
        mouseOver = function(a) {
          _this.addClass('cur').siblings().removeClass("cur");
          var index = _this.index();
          i = index;
          contentLi.eq(i).fadeIn(speed).siblings().fadeOut(speed);
        }
        break;

        //左右切换
      case 'scrollX':
        contentUl.addClass('scrollX_ul');
        var v_width = content.width();
        contentLi.width(v_width);
        contentUl.width(v_width * page_count);
        var i = 0;
        playLeft = function() {
          if(i >= page_count - 1) {
            i = 0;
            contentUl.animate({
              left: '0px'
            }, speed);
            positionUl_$.find('li').eq(i).addClass('cur').siblings().removeClass("cur");
          } else {
            i++;
            contentUl.animate({
              left: '-=' + v_width
            }, speed);
            positionUl_$.find('li').eq(i).addClass('cur').siblings().removeClass("cur");
          }
        }

        playRight = function() {
          if(i == 0) {
            i = page_count - 1;
            contentUl.animate({
              left: '-=' + v_width * (page_count - 1)
            }, speed);
            positionUl_$.find('li').eq(i).addClass('cur').siblings().removeClass("cur");
          } else {
            i--;
            contentUl.animate({
              left: '+=' + v_width
            }, speed);
            positionUl_$.find('li').eq(i).addClass('cur').siblings().removeClass("cur");
          }
        }

        //鼠标移入圆角函数
        mouseOver = function() {
          _this.addClass('cur').siblings().removeClass("cur");
          var index = _this.index();
          i = index;
          contentUl.animate({
            left: -v_width * i
          }, "slow");
        }

        break;

        //上下切换
      case 'scrollY':
        contentUl.addClass('scrollY_ul');
        var i = 0;
        var v_height = content.height();
        playLeft = function() {
          if(i >= page_count - 1) {
            i = 0;
            contentUl.animate({
              top: '0px'
            }, speed);
            positionUl_$.find('li').eq(i).addClass('cur').siblings().removeClass("cur");
          } else {
            i++;
            contentUl.animate({
              top: '-=' + v_height
            }, speed);
            positionUl_$.find('li').eq(i).addClass('cur').siblings().removeClass("cur");
          }
        }

        playRight = function() {
          if(i == 0) {
            i = page_count - 1;
            contentUl.animate({
              top: '-=' + v_height * (page_count - 1)
            }, speed);
            positionUl_$.find('li').eq(i).addClass('cur').siblings().removeClass("cur");
          } else {
            i--;
            contentUl.animate({
              top: '+=' + v_height
            }, speed);
            positionUl_$.find('li').eq(i).addClass('cur').siblings().removeClass("cur");
          }
        }

        //鼠标移入圆角函数
        mouseOver = function() {
          _this.addClass('cur').siblings().removeClass("cur");
          var index = _this.index();
          i = index;
          contentUl.animate({
            top: -v_height * i
          }, "slow");
        }

        break;

        //多图片左右切换
      case 'scrolls_x':
        contentUl.addClass('scrolls_x_ul');
        //复制ul里的元素
        var cloneLi = contentLi.clone();
        contentUl.append(cloneLi);
        //移动距离
        var v_width = contentLi.outerWidth();
        contentUl.width(v_width * contentUl.find('li').length);
        var i = 0;
        //左移函数
        playLeft = function() {
          if(i > page_count - 2) {
            i = 0;
            contentUl.animate({
              left: '-=' + v_width
            }, speed, function() {
              contentUl.css('left', '0px');
            });
          } else {
            i++;
            contentUl.animate({
              left: '-=' + v_width
            }, speed);
          }
        }
        break;
        //类似公告的上下切换
      case 'scrolls_y':
        showButton = false;
        showArrow = false;
        contentUl.addClass('scrolls_y_ul');

        //复制ul里的元素
        var cloneLi = contentLi.clone();
        contentUl.append(cloneLi);

        //移动距离
        var v_height = contentLi.outerHeight();
        contentUl.height(v_height * contentUl.find('li').length);

        var i = 0;
        //下移函数
        playLeft = function() {
          if(i > page_count - 2) {
            i = 0;
            contentUl.animate({
              top: '-=' + v_height
            }, speed, function() {
              contentUl.css('top', '0px');
            });
          } else {
            i++;
            contentUl.animate({
              top: '-=' + v_height
            }, speed);
          }
        }
        break;
    }
    //如果自动切换为true
    if(autoPlay) {
      var setTime = setInterval(playLeft, timer);
      //鼠标移入清空时间函数
      content.hover(function() {
        clearInterval(setTime);
      }, function() {
        setTime = setInterval(playLeft, timer);
      });
    }

    return this;
  }

