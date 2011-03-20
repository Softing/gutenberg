Inprint.plugins.rss.Interaction = function(parent, panels) {

    var grid = panels.grid;
    var profile = panels.profile;

    profile.on("render", function() {
        var el = this.getEl();
        setTimeout(function() { el.mask("Please, select document"); }, 10);
    }, profile);

    profile.panels.form.on("actioncomplete", function (form, action) {
        if (action.type == "submit") {
            this.getStore().reload();
            new Ext.ux.Notification({
                iconCls: 'event',
                title: _("System event"),
                html: _("Changes have been saved")
            }).show(document);
        }
    }, grid);

    grid.getSelectionModel().on("selectionchange", function(sm) {
        if (sm.getCount() == 1) {
           profile.cmpFill(sm.getSelected().get("id"));
        }
        if (sm.getCount() > 1) {
            profile.getEl().mask("Please, select document");
        }
        if (sm.getCount() === 0) {
            profile.getEl().mask("Please, select document");
        }
    });

};
