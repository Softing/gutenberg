Inprint.advertising.advertisers.actionDelete = function() {
    Ext.MessageBox.confirm(
        _("Warning"),
        _("You really wish to do this?"),
        function(btn) {
            if (btn == "yes") {

                Ext.Ajax.request({
                    scope:this,
                    success: this.cmpReload,
                    url: _source("advertisers.delete"),
                    params: { id: this.getValues("id") }
                });

            }
        }, this).setIcon(Ext.MessageBox.WARNING);
};
