//- 问答
siteApp.controller('AskListCtrl',['$scope','$http',function($scope,$http){
  $scope.orderby = 'created_at';
  $scope.get_list = function(orderby){
    $scope.orderby = orderby; 
     $scope.init();
  }

  $scope.init = function(){
    $scope.list = list_data($scope,$http,'/asks.json?order=' + $scope.orderby,'items',$('#pag-asks'));
    $scope.list(1,15);
  }
}])


//在线运行
siteApp.controller('OnlineCtrl',['$scope','$http',function($scope,$http){

  $scope.init = function(id){
    $scope.item = {
      title: '未命名*',
      collect: 0,
      comment: 0
    }
    $scope.ismy = false;
    $scope.isnew = false;
    $scope.issaved = true;
    $scope.isfavor = false;
    if (parseInt(id) > 0) {
      $http.get('/code/'+id+'.json',{}).success(function(data){
        $scope.ismy = data.ismy;
        $scope.item = data.item;
        $scope.isfavor = data.isfavor; 
        jsCodeMirror.setValue(data.item.sjs);
        cssCodeMirror.setValue(data.item.scss);
        htmlCodeMirror.setValue(data.item.shtml);
        onlie_run();
        $scope.issaved = true; 
      })
    }else{
      $scope.isnew = true;
      $scope.issaved = false;
    }


  }

  //- 收藏
  $scope.collect = function(item) {
    if(!show_login()){return false};
    $http.post('/collect',{typ:'code',idcd: item.id}).success(function(data){
      $scope.isfavor = data.isfavor;
    })
  }



  $scope.save = function(){
    if(!show_login()){return false}
    if ($scope.isnew) {
      $('#codeModal').modal('show');
    }else{
      $scope.save_sub();
    }
  }

  $scope.save_sub = function(){
    if ($scope.issaved || $scope.title == '') {return false};   
    if ($scope.isnew) {
      $http.post('/code/save',{title: $scope.title,shtml:  htmlCodeMirror.getValue(),scss: cssCodeMirror.getValue() ,sjs: jsCodeMirror.getValue() }).success(function(data){      
        if (data.status) {
          window.location.href = "/code/" + data.id;
        }
      })
    }else{
      $http.post('/code/' + $scope.item.id + '/update',{shtml:  htmlCodeMirror.getValue(),scss: cssCodeMirror.getValue() ,sjs: jsCodeMirror.getValue() }).success(function(data){      
        if (data.status) {
          $scope.issaved = true;
        }
      })
    }
    
  }
  
  $scope.destroy = function(){
    if (!confirm('确定删除该代码？')) {return false};
    $http.post('/code/'+ $scope.item.id +'/destroy/',{}).success(function(data){   
      window.location.reload();
    })
  }

  $scope.fork = function(){
    if(!show_login()){return false}
    $('#forkModal').modal('show');
  }
  
  $scope.fork_sub = function(){
    if ($scope.forktitle == '') {return false};
    $http.post('/code/'+ $scope.item.id +'/fork/',{title: $scope.forktitle}).success(function(data){   
      if (data.status) {
        window.location.href = "/code/" + data.id;
      }
    })
  }



  
}])
