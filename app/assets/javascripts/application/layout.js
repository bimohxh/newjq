$(function(){
  rezie_height();
  NProgress.start();
  NProgress.done();
  $(window).resize(function(){
    rezie_height();
  })

  $('[data-toggle="popover"]').popover();

  //- 打开登陆框
  $('.open-login').click(function(){ 
    return show_login(); 
  })

  $('.open-singin').click(function(){ 
  	var scope = angular.element($('#loginModal')).scope()
  	scope.$apply(function(){
  		scope.switch_status('singup');
  	})
  	show_login();
  	return false;
  });

  //- 单选框
  $(':radio:checked').parent("label.btn").addClass("active")
  $('label.btn').click(function(){
    $(this).find(":radio").checked()
    console.log()
  })
})

//- 页面高度
function rezie_height(){
  $('.con-wrap').css('min-height',$(window).height()-95);
  $(".footer").show();
}

//- 弹出登陆框
function show_login(){
	if (!Rails.islogin) {
    $('#loginModal').modal('show');
    return false;
  }else{
    return true;
  }
}


//-po
function popoverup($ele,tip){
}



//- 获取文本框光标位置
(function($) {
    $.fn.insertContent = function(myValue, t) {
    var $t = $(this)[0];
    if (document.selection) { //ie
      this.focus();
      var sel = document.selection.createRange();
      sel.text = myValue;
      this.focus();
      sel.moveStart('character', -l);
      var wee = sel.text.length;
      if (arguments.length == 2) {
        var l = $t.value.length;
        sel.moveEnd("character", wee + t);
        t <= 0 ? sel.moveStart("character", wee - 2 * t - myValue.length) : sel.moveStart("character", wee - t - myValue.length);
 
        sel.select();
      }
    } else if ($t.selectionStart || $t.selectionStart == '0') {
      var startPos = $t.selectionStart;
      var endPos = $t.selectionEnd;
      var scrollTop = $t.scrollTop;
      $t.value = $t.value.substring(0, startPos) + myValue + $t.value.substring(endPos, $t.value.length);
      this.focus();
      $t.selectionStart = startPos + myValue.length;
      $t.selectionEnd = startPos + myValue.length;
      $t.scrollTop = scrollTop;
      if (arguments.length == 2) {
        $t.setSelectionRange(startPos - t, $t.selectionEnd + t);
        this.focus();
      }
    }
    else {
      this.value += myValue;
      this.focus();
    }       
    };
})(jQuery);


function rawcon(con){
  return con.replace(/@([^:：?\s@]+)/g,"<a href='/mem/nc/$1' target='_blank'>@$1</a>");
}