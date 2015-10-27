
//上传文件
function uplaod_form($file,callback){
  $file.wrap('<div class="upwrap"></div>')
  $file.parent().append('<div class="upbtn"  data-loading-text="上传中...">'+ $file.attr('data-text')+'</div>')

  $file.change(function(){
    if($file.val() == ''){return false;}
    var upbtn = $file.parent().find(".upbtn");
    upbtn.button('loading');
    var upouter = $file.closest('.upwrap');

    upouter.wrap("<form class='uploadform' method='post' enctype='multipart/form-data' action='" + $file.attr('data-post') + "'></form>");

    var _width = $file.attr('data-width');
    var _height = $file.attr('data-height');
    var whinput = "";
    if(_width && _height){
      whinput = "<input type='hidden' name='width' value='"+_width+"'/><input type='hidden' name='height' value='"+_height+"'/>";
    }

    var fol = $('<input type="hidden" name="folder" value="'+ $file.attr('data-folder') + '" />' + whinput)
    upouter.append(fol)

    upouter.parent().ajaxSubmit(function(data){
      upouter.unwrap();
      fol.remove();
      data  = $.parseJSON(data);
      if(data.status){
        $($file.attr('data-for')).val(data.src);
        if(callback){callback(data)}
      }else{
      }
      upbtn.button('reset');
    });
  });
}

// 提示 success  info  warning  danger
function show_tip($ele,typ,con){
  var _div = '<div class="alert alert-'+typ+' alert-dismissible" role="alert">  <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>'+con+'</div>';
  $('div.alert').remove();
  $(_div).insertAfter($ele).stop(1).delay(3000).fadeOut();;

}


//简单模板替换
function simple_replace($temp,arr) {
  var tmp = $temp.html();
  _.each(arr,function(item,index){
    reg = new RegExp("@"+index+"@","gi");
    tmp = tmp.replace(reg,item);
  });
  return tmp;
  
}


// 代码运行
function get_iframe($ele){
  ifrm = $ele[0];
  if (ifrm.contentWindow) {
      ifrm = ifrm.contentWindow;
  } else {
    if (ifrm.contentDocument && ifrm.contentDocument.document) {
      ifrm = ifrm.contentDocument.document;
    } else {
      ifrm = ifrm.contentDocument;
    }
  }
  return ifrm;
}

function run_code(shtml,sjs,scss,ifrm){
  var _js = "<script type='text/javascript'>" + sjs + "</script>";
  var _css = "<style>" + scss + "</style>";
  //var _html =  template_replace($("#iframe-temp"),{css: cssCodeMirror.getValue(),javascript: js,html: htmlCodeMirror.getValue()});
  var _html = shtml.replace(/(\s+)(<\/head>)/,'$1  ' + _js + _css+'$1$2');
  ifrm.document.open();
  ifrm.document.write(_html); 
  ifrm.document.close();
}
