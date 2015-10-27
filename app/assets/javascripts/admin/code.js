adminApp.controller('CodeOperCtrl',['$scope','$http',function($scope,$http){

  $scope.init = function(recsts){
    $scope.recsts =  recsts;
    $scope.award = 3;
  }

  $scope.destroy=function(id){
    if (!confirm('确定删除？')) {
      return false;
    };
    $http.post('/admin/code/destroy',{id : id,reason : $scope.reason}).success(function(data){
      if (data.status) {
        window.location.href="/admin/codes";    
      };      
    });
  }

  $scope.reset = function(id){
    $http.post('/admin/code/reset',{id : id}).success(function(data){ 
      $scope.recsts =  data;
    })
  }

  $scope.check = function(id){
    $http.post('/admin/code/check',{id : id,award: $scope.award}).success(function(data){ 
      $scope.recsts =  data;
    })
  }
}])
