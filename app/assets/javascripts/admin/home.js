//- 会员
adminApp.controller('MemCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'mem') 
}])

//- 订单
adminApp.controller('OrderCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'order');
}]) 

//- 充值卡
adminApp.controller('CardCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'card');
}])

//积分记录
adminApp.controller('RecordCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'record');
}])

//- 评论
adminApp.controller('CommentCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'comment');
}])

//- 搜索记录
adminApp.controller('SearchCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'search');
}])

//- bug
adminApp.controller('BugCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'bug');
}])

//- Feedback
adminApp.controller('FeedbackCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'feedback');
}])

//- 插件
adminApp.controller('PluginCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'plugin');
}])

//- 代码
adminApp.controller('CodeCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'code');
}])

//- 视频
adminApp.controller('VideoCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'video');
}])

//- 插件内容
adminApp.controller('PluginconCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'plugincon');
}])


//- 问题
adminApp.controller('AskCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'ask');
}])

//- 回答
adminApp.controller('AnswerCtrl',['$scope','$http',function($scope,$http){
  get_data($scope,$http,'answer');
}])








function get_data($scope,$http,collection,data_callback){
  var list_url = '/admin/'+collection+'s.json';
  var remove_url = '/admin/'+collection+'/destroy';
  var reset_url = '/admin/'+collection+'/reset';
  var confirm_url = '/admin/'+ collection +'/confirm';

  var now_page = 1;

  $scope.where = {};

  $scope.get_list = function(page,para,pagesize){
    if (!para) {para = {}};
    if(!pagesize){pagesize = 15};
    $http.post(list_url,{page : page,pagesize: pagesize, para : para}).success(function(data){
      if(data_callback){
        data = data_callback(data);
      }
      $('#totalc').html(data.count);
      $('#pagenation').pagination(data.count,{
        items_per_page : pagesize,
        current_page : page-1,
        callback : function(page){
          now_page = page; 
          $scope.get_list(page+1,para);
        } 
      });
      $scope.items = data.items; 
    })
  }

  $scope.search = function(field){   
    if ($scope['filter_' + field] == '') {
     $scope.where =  _.omit($scope.where,field);
    }else{ 
      eval("_.extend($scope.where,{'"+field+"': $scope['filter_' + field]}); ")
    }
    $scope.get_list(1,$scope.where); 

  }

  $scope.destroy=function(id){
    if(collection == 'video' || collection == 'plugin' || collection == 'code'){
      var reson = prompt('请输入删除原因？');
      if (reson != null) { 
        $http.post(remove_url,{id : id,reson : reson}).success(function(data){
          angular.element($('#list')).scope().get_list(now_page);
        });
      }
    }else{
      if(confirm('确定删除该记录？')){
        $http.post(remove_url,{id : id,reson : reson}).success(function(data){
          angular.element($('#list')).scope().get_list(now_page);
        });
      }
    } 
    
  }

  $scope.reset = function(id){
    $http.post(reset_url,{id : id}).success(function(data){ 
      angular.element($('#list')).scope().get_list(now_page);
    })
  }

  $scope.confirm = function(id){
    if(confirm('确定此操作？')){
      $http.post(confirm_url,{id : id}).success(function(data){ 
        angular.element($('#list')).scope().get_list(now_page);
      });
    }
    
  }

  $scope.notify = function(mem_id){
    current_mem_id = mem_id;
  }
}

//上传文件
function uplaod_form($files,callback){
  $files.each(function(){
    var obj = $(this);
    obj.wrap('<div class="upwrap"></div>')
    obj.parent().append('<div class="upbtn"  data-loading-text="上传中...">'+obj.attr('data-text')+'</div>')

    obj.change(function(){
      if(obj.val() == ''){return false;}
      var upbtn = obj.parent().find(".upbtn");
      upbtn.button('loading');
      var upouter = obj.closest('.upwrap');
      upouter.wrap("<form class='up-form' method='post' enctype='multipart/form-data' action='" + obj.attr('data-post') + "'></form>"); 
      var fol = $('<input type="hidden" name="folder" value="'+obj.attr('data-folder')+'" />')
      upouter.append(fol)

      upouter.parent().ajaxSubmit(function(data){
        upouter.unwrap();
        fol.remove();
        if(data.status){ 
          var txt = obj.attr('data-for');
          if($(txt)){
            $(txt).val(data.src);
          }
          if(callback){
            callback(data)
          }
        }else{
        }
        upbtn.button('reset');
      });
    }); 
  })
}