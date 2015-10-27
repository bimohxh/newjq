adminApp.controller('PluginconOperCtrl',['$scope','$http',function($scope,$http){
  $scope.destroy=function(id){
    if (!confirm('确定删除？')) {
      return false;
    };

    $http.post('/admin/plugincon/destroy',{id : id,reason : $scope.reason}).success(function(data){
      if (data.status) {
        window.location.href="/admin/plugincons";    
      };      
    });
  }

  $scope.update = function(id){
    $http.post('/admin/plugincon/update',{id : id,con: con_editor.getValue()}).success(function(data){ 
      window.location.reload();
    })
  }

  $scope.merge = function(id){
    $http.post('/admin/plugincon/merge',{id : id,award: $scope.award}).success(function(data){ 
      window.location.reload();
    })
  }

}])
