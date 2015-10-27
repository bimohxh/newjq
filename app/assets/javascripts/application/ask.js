siteApp.controller('AskCtrl',['$scope','$http',function($scope,$http){

  $scope.init = function(id) {
    $scope.is_collect(id);
    $scope.visitinc(id); 
  }

  //- 是否收藏
  $scope.is_collect = function(id) {
    $http.post('/isfavor',{typ:'ask',idcd: id}).success(function(data){
      $scope.isfavor = data.isfavor;
    })
  }

  //- 收藏
  $scope.collect = function(id) {
    if(!show_login()){return false};
    $http.post('/collect',{typ:'ask',idcd: id}).success(function(data){
      $scope.isfavor = data.isfavor;
    })
  }
  
  //- 浏览量+1
  $scope.visitinc = function(id){
    setTimeout(function(){
      $http.post('/ask/visitinc',{id: id}).success(function(data){})
    },3000);
  } 

  //- 追加悬赏
  $scope.reward= function(id){
    if ($scope.rewardnum > 0) {
      $http.post('/ask/reward',{id: id,num: $scope.rewardnum}).success(function(data){
        if (data.status) {
          window.location.reload();
        };
      })
    }
  }
}])


//- 回答
siteApp.controller('AnswerCtrl',['$scope','$http','$sce',function($scope,$http,$sce){
  $scope.init_answer = function(id,adopt_cd){
    $scope.adopt_cd = adopt_cd;
    $scope.qid = id;

    $scope.editorstate = 'expand';
    $scope.editorheight = '100%';

    $scope.adopted = 0;
    $scope.comcount = "获取中...";

    $scope.parentid = 0; // 回复ID

    $scope.insert_code = function(){
      $("#com-txt").insertContent('<pre class="brush:html;toolbar:false">\r\n//- 代码区\r\n</pre>');
    }

    $scope.switch_state = function(){
      if($scope.editorstate == 'expand'){
        $scope.editorstate = 'compress';
        $scope.editorheight = $(window).height() - 40 + 'px';
      }else{
        $scope.editorstate = 'expand';
        $scope.editorheight = '100%';
      }
    }

    //- 获取回答
    $scope.list = list_data($scope,$http,'/ask/answers','answers',null,function(data){
      _.each(data.items,function(item){ 
        item[0].rawcontent =  $sce.trustAsHtml(rawcon(item[0].raw_con));
        _.each(item[1],function(ritem){
          ritem.rawcontent =  $sce.trustAsHtml(rawcon(ritem.raw_con));
        });
      })
      $scope.comcount = data.count;
      $('[data-toggle="popover"]').popover();
    })

    $scope.list(1,100,$scope.qid) 

    //- 添加回答
    $scope.comment_add = function(){ 
      if($scope.comment_con == undefined || $scope.comment_con == ''){return false}
      $http.post('/answer/create',{aid: $scope.qid,con: $scope.comment_con,parent: $scope.parentid}).success(function(data){
        $scope.list(1,100,$scope.qid);
        $scope.comment_con = '';
      })
    }

    //- 回复
    $scope.reply = function(item){
      $scope.parentid = item.id;
    }

    //- 删除回答
    $scope.destroy = function(item){
      $http.post('/comment/destroy',{id: item.id}).success(function(data){
        $scope.comments = _.without($scope.comments,item)
      })
    } 

    //-采纳答案
    $scope.adopt = function(item){
      $http.post('/answer/adopt',{id: item.id,aid: $scope.qid}).success(function(data){
        if (data.status) {
          $scope.adopt_cd = item.id;
        };
      })
    } 

    //-voteup
    $scope.vote = function(item,act,$event){ 
      $http.post('/answer/vote',{id: item.id,act: act}).success(function(data){
        $scope.comments = _.without($scope.comments,item);
        if (data.status) {
          item.votes += 1;
        }else{
          popoverup($($event.target),data.msg);
        }
      })

      
    } 

  }
}])
