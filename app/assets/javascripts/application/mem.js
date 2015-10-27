$(function(){
	$(".mem-top-menus li[data-on="+$('#mem-on').val()+"]").addClass('on');
})

//- 我的收藏
siteApp.controller('FavorCtrl',['$scope','$http',function($scope,$http){


  $scope.init = function(model,mid){
  	$scope.list =  list_data($scope,$http,'/mem/favors/'+ model +'.json','items',$('#pag-favors'));
  	$scope.list(1,12,mid);
  }

  $scope.destroy = function(model,item){
    $http.post('/favor/destroy',{typ: model,idcd: item.id}).success(function(data){
      if(data.status){
        $scope.items = _.without($scope.items,item)
      }
    })
  }
  
}])

//- 我的发布 
siteApp.controller('PubedCtrl',['$scope','$http',function($scope,$http){

  $scope.model = 'plugin';

  $scope.init = function(model,mid){
    $scope.list =  list_data($scope,$http,'/mem/pubeds/'+ model+'.json','items',$('#pag-favors'));
    $scope.list(1,12,mid);
  }

  $scope.switch = function(model,mid){
    $scope.model = model; 
    $scope.init(model,mid);
  }
  
  $scope.csson =function(model){
    return $scope.model == model ? 'on' : ''
  }
}])



//- 我的消息
siteApp.controller('MsgCtrl',['$scope','$http',function($scope,$http){

  //- 所有消息
  $scope.list =  list_data($scope,$http,'/mem/msg.json','items',$('#pag-msgs'));

  //- 未读消息
  $scope.list_unread =  list_data($scope,$http,'/mem/unread.json','unreads',$('#unread-page'));
}])

//- 我的资料
siteApp.controller('InfoCtrl',['$scope','$http',function($scope,$http){

  //- 第三方账号
  $scope.account_list =  list_data($scope,$http,'/mem/auths.json','accounts',null);
  $scope.has_account = function(auth){
    return _.contains($scope.accounts, auth)? "on" : '';
  } 

}])

//- 关注
siteApp.controller('FollowCtrl',['$scope','$http',function($scope,$http){
  //- 我的关注
  $scope.following_list = list_data($scope,$http,'/mem/following.json','items',$('#page-follow'))
  
  //- 我的粉丝
  $scope.follower_list = list_data($scope,$http,'/mem/followers.json','items',$('#page-follow'))
  

  //- 添加 / 取消关注
  $scope.update = function(to_id,item){
    $http.post('/follow/update.json',{to: to_id}).success(function(data){
      $scope.followstatus = item.followstatus = data.isfollow;
    })
  }

  //- 是否关注
  $scope.isfollow = function(to_id){
    $http.post('/follow/isfollow.json',{to: to_id}).success(function(data){
      $scope.followstatus = data.isfollow;
    })
  }
}])

//- 订单
siteApp.controller('OrderCtrl',['$scope','$http',function($scope,$http){
  $scope.list = list_data($scope,$http,'/mem/orders.json','items',$('#page-order'))
}])

//- 积分记录
siteApp.controller('RecordCtrl',['$scope','$http',function($scope,$http){
  $scope.list = list_data($scope,$http,'/mem/record.json','items',$('#page-record'))
}])

//签到
siteApp.controller('CheckinCtrl',['$scope','$http',function($scope,$http){
  $scope.init = function(){
    $http.get('/mem/ischeckin.json',{}).success(function(data){
      $scope.ischeckin = data.ischeck;
      $scope.days = data.days;
    });
  };

  $scope.checkin = function(){
     $http.post('/mem/checkin.json',{}).success(function(data){
      $scope.ischeckin = data.ischeck;
      $scope.days = data.days;
    });
  }
}])


// 我的回答
siteApp.controller('MyAnswerCtrl',['$scope','$http',function($scope,$http){
  $scope.list = list_data($scope,$http,'/mem/ask/answers.json','items',$('#pag-favors'))
}])
