$(function(){

  ifrm = get_iframe($("#preview-window"));
  

  //初始化
  $(window).resize(function(){
    onlie_resize();
  });

  setTimeout(function(){
    onlie_resize();
  },1);

  $(".onlie-top .onlie-inner").mouseover(function(){
    $(this).find('.online-label').stop(false).fadeOut(500);
    $(this).find('.fa-expand,.fa-compress').stop(false).fadeIn(500);
  }).mouseout(function(){
    $(this).find('.online-label').stop(false).fadeIn(500);
    $(this).find('.fa-expand,.fa-compress').stop(false).fadeOut(500);
  })

  $(".onlie-inner i.fa-expand").click(function(){
    
  })

  $(".onlie-top").on("click",".fa-compress",function(){
    $(this).closest('.onlie-vertical').removeClass('full');
    $(this).removeClass('fa-compress').addClass('fa-expand');
  });

  $(".onlie-top").on("click",".fa-expand",function(){
    $(this).closest('.onlie-vertical').addClass('full').siblings('.onlie-vertical').removeClass('full');
    $(this).removeClass('fa-expand').addClass('fa-compress');
  });

  $(".onlie-bottom").on("click",".fa-expand",function(){
    $(this).closest('.onlie-horizontal').addClass('full').siblings('.onlie-horizontal').removeClass('full');
    $(this).removeClass('fa-expand').addClass('fa-compress');
  });

  $(".onlie-bottom").on("click",".fa-compress",function(){
    $(this).closest('.onlie-horizontal').removeClass('full');
    $(this).removeClass('fa-compress').addClass('fa-expand');
  })


  htmlCodeMirror =  CodeMirror.fromTextArea($('#html-text')[0],{
      lineNumbers: true,
      mode: "text/html",
      matchBrackets: true
    });

  jsCodeMirror =  CodeMirror.fromTextArea($('#js-text')[0],{
      lineNumbers: true,
      mode: "javascript",
      matchBrackets: true
    });

   cssCodeMirror =  CodeMirror.fromTextArea($('#css-text')[0],{
      lineNumbers: true,
      mode: "css",
      matchBrackets: true
    });

  
  //初始化代码 
  init_code();

  _.each([htmlCodeMirror,jsCodeMirror,cssCodeMirror],function(ele){
    ele.on('change',function(){
      get_scope().issaved = false;
      if(!get_scope().$$phase) {
         get_scope().$apply();
      }
    }); 
  }) 

   $('.onlie-menu .dropdown-menu li').click(function(){
      _.each($(this).find('a').attr("data-src").split(','),function(link){
        var srclink = '<script src="/package/' + link + '"></script>';
        if (/.+\.css$/.test(srclink)) {
          srclink = '<link rel="stylesheet" media="all" href="/package/' + link + '" />'
        };
        
        htmlCodeMirror.setValue(htmlCodeMirror.getValue().replace(/(\s+)(<\/head>)/,'$1  ' + srclink+'$1$2'));
      });
   })




  //横向拖动
  $('.split-vertical').mousedown(function(eve){
    //reset_max_width(eve);
    var split_obj = $(this);
    var prev_ele = split_obj.prev('.onlie-vertical');
    var next_ele = split_obj.next('.onlie-vertical');
    var split_obj_left = parseInt(split_obj.css('left'));
    current_position = eve.clientX;
    prev_width = prev_ele.width();
    next_width = next_ele.width();
    next_left = parseInt(next_ele.css('left'));

    $('body').mousemove(function(e){ 
      if (next_width - e.clientX + current_position <= 100) {
        return false;
      };
      prev_ele.width(prev_width + e.clientX - current_position);
      next_ele.width(next_width - prev_ele.width() + prev_width).css('left',next_left + prev_ele.width() - prev_width);
      ajust_split(split_obj);

    })

  });

  //纵向拖动
  $('.split-horizontal').mousedown(function(eve){
    var prev_ele = $(this).prev('.onlie-horizontal');
    var next_ele = $(this).next('.onlie-horizontal');
    $('.widnow-cover').show();
    current_position = eve.clientY;
    prev_height = prev_ele.height();
    next_height = next_ele.height();
    next_top = parseInt(next_ele.css('top'));

    $('body').mousemove(function(e){
      if (next_height - e.clientY + current_position <= 100) {
        return false;
      };
      prev_ele.height(prev_height + e.clientY - current_position);
      next_ele.height(next_height - prev_ele.height() + prev_height);
      ajust_top($('.split-horizontal'));
      ajust_top(next_ele);

    })
  });

  $('body').mouseup(function(){
    $('body').unbind('mousemove');
    $('.widnow-cover').hide();
  })

})

//布局
function onlie_resize(){
  $('.onlie-wrap').height($(window).height() - $('.onlie-menu').height() - 30);
  var top_width = parseInt(($('.onlie-wrap').width() - 20) / 3);
  var horizontal_height = parseInt(($('.onlie-wrap').height() - 8) / 2) ;
  $('.onlie-vertical').width(top_width).last().width($('.onlie-wrap').width() - top_width * 2 - 16);
  $('.onlie-vertical:eq(1)').css('left',top_width  + 8) ;
  $('.onlie-vertical:eq(2)').css('left',top_width * 2  + 16) ;

  ajust_split($('.split-vertical').eq(0));
  ajust_split($('.split-vertical').eq(1));

  $('.onlie-horizontal').css('height', horizontal_height)/*.css('max-height',$('.onlie-wrap').height() - 8 - 100)*/;
  
  ajust_top($('.split-horizontal'));
  ajust_top($('.onlie-horizontal:eq(1)'));
}

function ajust_split(obj){
  obj.css('left',(obj.prev().width() + parseInt(obj.prev().css('left'))));
}

function reset_max_width(eve){
  
  $('.onlie-vertical,.onlie-vertical:eq(1)').css('max-width','inherit');
  if (eve.target == $('.split-vertical').first()[0]) {
    $('.onlie-vertical').first().css('max-width',$('.onlie-wrap').width()  - 16 - 100 -  $('.onlie-vertical').last().width());
  }else{
    $('.onlie-vertical:eq(1)').css('max-width',$('.onlie-wrap').width() - 16 - 100 -  $('.onlie-vertical').first().width());
  }
}


//- 初始化编辑器代码
function init_code(){
  var _html =  "<!DOCTYPE html>\n\
    <html>\n\
      <head>\n\
        <meta charset='utf-8' \/> \n\
      <\/head>\n\
      <body>\n\
        \n\
      <\/body>\n\
    <\/html>";

  if (get_scope().isnew) {
    htmlCodeMirror.setValue(_html);
  }
  

}

//- 运行
function onlie_run(){
  run_code(htmlCodeMirror.getValue(),jsCodeMirror.getValue(),cssCodeMirror.getValue(),ifrm);
}

function ajust_top(ele){
  ele.css('top',ele.prev().height() + parseInt(ele.prev().css('top')));
}

//简单模板替换
function template_replace($temp,data){ 
  var reg;
  var temp = $temp.html();
  _.each(data,function(val,key){
    reg = new RegExp("@{"+key+"}","gi");
    temp = temp.replace(reg,val);
  });
  return  temp;
}

//获取scope
function get_scope(){
  return angular.element("#online-body").scope();
}

