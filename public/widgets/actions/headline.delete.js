Inprint.setAction("headline.delete", function(tree, node) {

    var url = _url("/catalog/headlines/delete/");

    var success = function() {
        node.parentNode.reload();
    };

    var params = {
        id: node.id
    };

    Ext.MessageBox.confirm(
        _("Delete headline"),
        _("You really wish to do this?"),
        function(btn) {
            if (btn == "yes") {
                Ext.Ajax.request({ url: url, success: success, params: params });
            }
        }).setIcon(Ext.MessageBox.WARNING);

});
