//- 评论
siteApp.controller('PluginCtrl',['$scope','$http',function($scope,$http){
  $scope.init = function(id){
    $scope.is_collect_follow(id);
    $scope.visitinc(id); 
  }

  //- 是否收藏
  $scope.is_collect_follow = function(id) {
    if(!Rails.islogin){return false}
  	$http.post('/plugin/collect_follow',{id: id}).success(function(data){
      $scope.isfavor = data.isfavor;
      $scope.isfollow = data.isfollow;
    })
  }

  //- 收藏
  $scope.collect = function(id) {
    if(!show_login()){return false};
  	$http.post('/collect',{typ:'plugin',idcd: id}).success(function(data){
    	$scope.isfavor = data.isfavor;
    })
  }

  //- 浏览量+1
  $scope.visitinc = function(id){
    setTimeout(function(){
      $http.post('/plugin/visitinc',{id: id}).success(function(data){})
    },3000);
  } 

  //- 获取评论
  $scope.list_comments = list_data($scope,$http,'/api/plugin/comments','comments',$('#pag-comment'),function(data){
    _.each(data.items,function(item){ 
      item.rawcontent = _.escape(item.content).replace(/@([^:：?\s@]+)/g,"<a href='/mem/nc/$1' target='_blank'>@$1</a>")
      item.rawcontent = $sce.trustAsHtml($.raw_emoji(item.rawcontent))
    })
  })

  //- 下载
  $scope.download = function(id){
    if(!show_login()){return false};
    
    $('#downloadModal').modal('show');

    $http.post('/mem/balance.json',{typ:'plugin',idcd: id}).success(function(data){
      $scope.integral = data.integral;
      $scope.downright = data.right;
    })
    
  }

  //- 添加 / 取消关注
  $scope.follow = function(to_id){
    if(!show_login()){return false};
    $http.post('/follow/update.json',{to: to_id}).success(function(data){
      $scope.isfollow = data.isfollow;
    })
  }

}])


siteApp.controller('PluginOperCtrl',['$scope','$http',function($scope,$http){

  $scope.init = function(recsts){
    $scope.recsts =  recsts;
    $scope.award = 5;
  }

  $scope.destroy=function(id){
    if (!confirm('确定删除？')) {
      return false;
    };
    $http.post('/admin/plugin/destroy',{id : id,reason : $scope.reason}).success(function(data){
      if (data.status) {
        window.location.href="/admin/plugins";    
      };      
    });
  }

  $scope.reset = function(id){
    $http.post('/admin/plugin/reset',{id : id}).success(function(data){ 
      $scope.recsts =  data;
    })
  }

  $scope.check = function(id){
    $http.post('/admin/plugin/check',{id : id,award: $scope.award}).success(function(data){ 
      $scope.recsts =  data;
    })
  }
}])