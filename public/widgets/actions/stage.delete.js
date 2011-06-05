Inprint.setAction("stage.delete", function(grid) {

    var url = _url("/catalog/stages/delete/");

    var success = function() {
        grid.cmpReload();
    };

    var params = {
        id: grid.getValues("id")
    };

    Ext.MessageBox.confirm(
        _("Delete stage"),
        _("You really wish to do this?"),
        function(btn) {
            if (btn == "yes") {
                Ext.Ajax.request({ url: url, success: success, params: params });
            }
        }).setIcon(Ext.MessageBox.WARNING);

});
