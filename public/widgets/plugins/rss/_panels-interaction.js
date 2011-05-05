Inprint.plugins.rss.Interaction = function(parent, panels) {

    var grid = panels.grid;
    var profile = panels.profile;

    profile.on("render", function() {
        var el = this.getEl();
        setTimeout(function() { el.mask( _("Please, select document") ); }, 10);
    }, profile);

    profile.panels.form.on("actioncomplete", function (form, action) {
        if (action.type == "submit") {
            this.getStore().reload();

            AlertBox.show(
                _("System event"),
                _("Changes have been saved"),
                'success', {timeout: 1});

        }
    }, grid);

    grid.getSelectionModel().on("selectionchange", function(sm) {
        if (sm.getCount() == 1) {
           profile.cmpFill(sm.getSelected().get("id"));
        }
        if (sm.getCount() > 1) {
            profile.getEl().mask( _("Please, select document") );
        }
        if (sm.getCount() === 0) {
            profile.getEl().mask( _("Please, select document") );
        }
    });

};
