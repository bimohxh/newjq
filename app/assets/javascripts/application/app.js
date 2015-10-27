var siteApp = angular.module('siteApp',[])

siteApp.config(['$httpProvider',function($httpProvider) {
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
}])



//angularjs 公共方法
//- 列表公共方法
function list_data($scope,$http,list_url,$scopeitems,$pagnation,callback){
  var me =  function(page,pagesize,id,paras){
    var curl = list_url;
    if(id){
      curl = list_url.replace(/(.+?)\//,'$1/'+ id +'/');
    }
    var params = {page: page,pagesize: pagesize}
    if(paras){
      params = _.extend(params,paras)
    }
    $http.get(curl,{params: params}).success(function(data){
      if(callback){callback(data)}
      $scope[$scopeitems] = data.items; 
      if ($pagnation) {
        $('h3.nodata').remove();
        if(data.count > 0){
          $pagnation.pagination(data.count,{
            items_per_page : pagesize,
            current_page : page-1,
            callback : function(cpage){
              me(cpage + 1,pagesize,id,paras) 
              return false;
            } 
          });
          $pagnation.show() 
        }else{
          $("<h3 class='nodata'>暂时没有数据！</h3>").insertAfter($pagnation);
          $pagnation.hide()
          $('h3.nodata').show() 
        }
      } 
    }) 
  }
  return me
} 

//- 全站
siteApp.controller('SiteCtrl',['$scope','$http',function($scope,$http){


}])

//-评论
siteApp.controller('CommentCtrl',['$scope','$http','$sce',function($scope,$http,$sce){
  $scope.init_comment = function(com){
    if (!com) {return false};
    $scope.comment_obj = com 

    $scope.editorstate = 'expand';
    $scope.editorheight = '100%';

    $scope.switch_state = function(){
      if($scope.editorstate == 'expand'){
        $scope.editorstate = 'compress';
        $scope.editorheight = $(window).height() - 40 + 'px';
      }else{
        $scope.editorstate = 'expand';
        $scope.editorheight = '100%';
      }
    }

    $scope.insert_code = function(){
      $("#com-txt").insertContent('<pre class="brush:html;toolbar:false">\r\n//- 代码区\r\n</pre>');
    }

    //- 获取评论
    $scope.list = list_data($scope,$http,"/comment/list?typ="+$scope.comment_obj.typ+"&idcd="+$scope.comment_obj.id,'comments',null,function(data){ 
      _.each(data.items,function(item){ 
        item.rawcontent = item.raw_con.replace(/@([^:：?\s@]+)/g,"<a href='/mem/nc/$1' target='_blank'>@$1</a>")
        item.rawcontent = $sce.trustAsHtml(item.rawcontent);
        item.ismine = (item.mem_id == Rails.mem_id);
      })
      $scope.comcount = data.count;

    })

    $scope.list(1,100,$scope.comment_obj.id) 

    //- 添加评论 
    $scope.comment_add = function(){ 
      if($scope.comment_con == undefined || $scope.comment_con == ''){return false}
      $http.post('/comment/create',{id: $scope.comment_obj.id,typ: $scope.comment_obj.typ,con: $scope.comment_con}).success(function(data){
        $scope.list(1,100,$scope.comment_obj.id)
        $scope.comment_con = ''
      })
    }

    //- 删除评论
    $scope.destroy = function(item){
      if(!confirm("确定删除该条评论？")){return false}
      $http.post('/comment/destroy',{id: item.id}).success(function(data){
        $scope.comments = _.without($scope.comments,item)
      })
    } 


  }
}])


//- 登陆
siteApp.controller('LoginCtrl',['$scope','$http',function($scope,$http){ 
  $scope.action = 'login';
  $scope.form_url = '/mem/login';
  $scope.init = function(){
    
  }
  $scope.switch_status = function(action){
    $scope.action = action;
    if (action == 'login') {
      $scope.form_url = '/mem/login';
    }else{
      $scope.form_url = '/mem/singup';
    };
  }

  $scope.third_login = function(url){
    window.open(url,'newwindow','width=500,height=500');
  }

}])

