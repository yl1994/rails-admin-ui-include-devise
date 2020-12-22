// ztree 数据，初始化
require('../../shared/ztree/jquery.ztree.all.min')
$(function() {
  var role_menus_tree = 'role_menus_tree'
  var zTree;
  var demoIframe;

  var setting = {
    view: {
      dblClickExpand: false,
      showLine: true,
      selectedMulti: false
    },
    data: {
      simpleData: {
        enable:true,
        idKey: "id",
        pIdKey: "pId",
        rootPId: ""
      }
    },
    check: {
      enable:true,
      chkboxType: { "Y" : "ps", "N" : "ps" }
    },
    callback: {
      onCheck: function(event,  tree_id, tree_node) {
        var nodes = $.fn.zTree.getZTreeObj(tree_id).getChangeCheckedNodes();
        var checked_data = {true: [],false: []};
        for(var i=0; i < nodes.length; i++){
          checked_data[nodes[i].checked].push(nodes[i].id)
        }
        ajax({
           url:  $("#assign_menus_url").val(),
           type: "post",
           dataType: "text",
           data: {checked_data: checked_data},
           success: function(msg){
             window.location.reload();
           }
         })
      },
      beforeClick: function(treeId, treeNode) {
        var zTree = $.fn.zTree.getZTreeObj(role_menus_tree);
        if (treeNode.isParent) {
          zTree.expandNode(treeNode);
          return false;
        } else {
          return true;
        }
      }
    }
  };
  var zNodes = JSON.parse($("#menus").val());
  var t = $("#"+role_menus_tree);
  t = $.fn.zTree.init(t, setting, zNodes);

})
