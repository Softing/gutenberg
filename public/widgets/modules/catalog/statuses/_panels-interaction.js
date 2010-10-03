Inprint.catalog.statuses.Interaction = function(panels) {

    var acl_view   = _a(null, "settings.edition.view");
    var acl_manage = _a(null, "settings.edition.manage");
    var acl_remove = _a(null, "settings.edition.remove");

    var grid = panels.grid;
    var help = panels.help;

    var tabs    = panels.tab;
    var edit    = panels.edit;

    // Grid behaviour

    grid.btnAdd.enable();

    grid.on("afterrender", function (grid) {
        grid.getStore().load();
    });

    grid.getSelectionModel().on("selectionchange", function(sm) {

        if (sm.getCount()) {
            if (acl_manage) _enable(grid.btnEnable, grid.btnDisable);
            if (acl_remove) _enable(grid.btnRemove);
        } else {
            _disable(grid.btnEnable, grid.btnDisable, grid.btnRemove);
        }

        if (acl_manage) {
            if (sm.getCount() == 1) {
                edit.enable();
                tabs.activate(edit);
                edit.cmpFill(grid.getValue("id"));
            } else {
                edit.disable();
                tabs.activate(help);
            }
        }

    });

    // Card behaviour

    edit.cmpGetId = function() {
        return grid.getSelectionModel().getSelected().get("id");
    }

    edit.on("activate", function() {
        edit.cmpFill();
    });

    edit.on("actioncomplete", function(form, action) {
        if (action.type == "submit")
            grid.cmpReload();
    });

}
