adminApp.controller('VideoOperCtrl',['$scope','$http',function($scope,$http){

  $scope.init = function(recsts){
    $scope.recsts =  recsts;
    $scope.award = 10;
  }

  $scope.destroy=function(id){
    if (!confirm('确定删除？')) {
      return false;
    };
    $http.post('/admin/video/destroy',{id : id,reason : $scope.reason}).success(function(data){
      if (data.status) {
        window.location.href="/admin/videos";    
      };      
    });
  }

  $scope.reset = function(id){
    $http.post('/admin/video/reset',{id : id}).success(function(data){ 
      $scope.recsts =  data;
    })
  }

  $scope.check = function(id){
    $http.post('/admin/video/check',{id : id,award: $scope.award}).success(function(data){ 
      $scope.recsts =  data;
    })
  }
}])
