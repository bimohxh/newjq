//-圆角
siteApp.controller('ToolRaiusCtrl',['$scope','$http',function($scope,$http){
  $scope.paras = {
    leftTop: 0,
    rightTop: 0, 
    rightBottom: 0, 
    leftBottom: 0,
  }

  $scope.setpara = function(leftTop,rightTop,rightBottom,leftBottom){
    $scope.paras.leftTop = leftTop;
    $scope.paras.leftBottom = leftBottom;
    $scope.paras.rightTop = rightTop;
    $scope.paras.rightBottom = rightBottom;
  }

  
}])

//-变换

siteApp.controller('ToolTransformCtrl',['$scope','$http',function($scope,$http){

}])
