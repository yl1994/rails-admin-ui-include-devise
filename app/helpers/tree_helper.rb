module TreeHelper


  def tree_content(link_title = '', opts = {})
    if link_title.empty?
      header = ''.html_safe
    else
      title_link = link_to link_title, opts[:url], :class => "btn btn-primary btn-sm"
      header = content_tag :div, title_link , class: 'page-header'
    end
    right_content = content_tag :div, '', class: "menu_content fl"
    list_content = content_tag :div, tree_list(link_title, style: '') + right_content
    js = '$(document).ready(function(){'
    js += '$(".menu_content").load("' + opts[:current_url] + '");' if opts[:current_url].present?
    js += 'var current_node = $.fn.zTree.getZTreeObj("tree-list").getNodeByParam("id", '+ opts[:current_id] +');
           $.fn.zTree.getZTreeObj("tree-list").selectNode(current_node);
          ' if opts[:current_id].present?
    js += '});'
    content_tag(:section, header + list_content + javascript_tag(js), id: 'tables')
  end

  def ztree_settings(opts = {})
    default_settings = {
      view: {
        addHoverDom: opts.dig(:view,:addHoverDom) || "addHoverDom",
        removeHoverDom: opts.dig(:view,:removeHoverDom) || "addHoverDom",
        selectedMulti: false,
      },
      check: {
        #enable: true
      },
      edit: {
        enable: opts.dig(:edit,:enable) || true,
        editNameSelectAll: opts.dig(:edit,:editNameSelectAll) || true,
        showRemoveBtn: opts.dig(:edit,:showRemoveBtn) || false,
        showRenameBtn: opts.dig(:edit,:showRenameBtn) || false,
        drag: {
          isCopy: true,
          isMove: true,
          prev: true,
          inner: false,
          next: true,
        }
      },
      data: {
        simpleData: {
          enable: true
        }
      },
      callback: {
        beforeDrag:  opts.dig(:callback,:beforeDrag) || "beforeDrag",
        beforeDrop:  opts.dig(:callback,:beforeDrop) || "beforeDrop",
        beforeEditName: opts.dig(:callback,:beforeEditName) || "beforeEditName",
        beforeRemove:  opts.dig(:callback,:beforeRemove) || "beforeRemove",
        onDrop:  opts.dig(:callback,:onDrop) || "onDrop",
        onRemove: opts.dig(:callback,:onRemove) || "onRemove",
        beforeRename: opts.dig(:callback,:beforeRename) || "beforeRename",
        onRename: opts.dig(:callback,:onRename) || "onRename",
        onClick: opts.dig(:callback,:onClick) || "onClick",
      }
    }
    default_settings.merge(opts).to_json.html_safe.delete("\"").gsub("=>",": ")
  end
end
