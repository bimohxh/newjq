siteApp.controller('VideoCtrl',['$scope','$http',function($scope,$http){

  //- 是否收藏
  $scope.is_collect = function(id) {
    if (!Rails.islogin){return false;}
    $http.post('/isfavor',{typ:'video',idcd: id}).success(function(data){
      $scope.isfavor = data.isfavor;
    })
  }

  //- 收藏
  $scope.collect = function(id) {
    if(!show_login()){return false};
    $http.post('/collect',{typ:'video',idcd: id}).success(function(data){
      $scope.isfavor = data.isfavor;
    })
  }
  
}])