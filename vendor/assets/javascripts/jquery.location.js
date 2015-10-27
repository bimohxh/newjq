(function($){
  var defaults = {
    data: undefined,
    dataurl: '/locations',
    sel_province: '.sel_province',
    sel_city: '.sel_city',
    sel_area: '.sel_area',
    renderBefore: function(){},
    renderAfter: function(obj){},
    insertAfter: function(){}
  };

  var render = function($obj,areas,options) {
    $obj.empty();
    _val = parseInt($obj.attr('data-val'));
    _.each(areas,function(item){
      if(_val > 0 && item.cd == _val){
        $obj.append("<option value='"+item.cd+"' selected>"+item.nm+"</option>");
      }else{
        $obj.append("<option value='"+item.cd+"'>"+item.nm+"</option>");
      }
    })
    $obj.removeAttr('data-val')
    options.renderAfter($obj);
  }






  $.fn.locations = function(opt){
    var options = $.extend({}, defaults, opt || {});

    var areas = function(items,id){
      return _.where(items,{parent: id});
    };


    return this.each(function(){
      $(this).children("select").width(120);
      if (!options.data) {
        $.ajax({
          url: options.dataurl,
          async : false,
          type : "POST",
          success : function(data) {
            options.data = data.items;
          }
        })
      }
      var province = $(this).find(options.sel_province);
      var city = $(this).find(options.sel_city);
      var area = $(this).find(options.sel_area);

      render(province,areas(options.data,1),options);

      province.change(function(){
        render(city,areas(options.data,parseInt($(this).val())),options);
        city.change();
      }).change();

      city.change(function(){
        render(area,areas(options.data,parseInt($(this).val())),options);
      }).change();

    });




  }

})(jQuery)


;
