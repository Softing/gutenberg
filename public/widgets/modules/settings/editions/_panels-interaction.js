Inprint.settings.editions.Interaction = function(panels) {

    var acl_view   = _a(null, "settings.edition.view");
    var acl_manage = _a(null, "settings.edition.manage");
    var acl_remove = _a(null, "settings.edition.remove");

    var grid = panels.grid;
    var edit = panels.edit;
    var help = panels.help;
    var tabs = panels.tab;
    
    if (acl_manage) {
        grid.btnAdd.enable();
    }

    grid.getSelectionModel().on("selectionchange", function(sm) {

        if (sm.getCount()) {
            if (acl_manage) {
                _enable(grid.btnEnable, grid.btnDisable);
            }
            if (acl_remove) {
                _enable(grid.btnRemove);
            }
        } else {
            _disable(grid.btnEnable, grid.btnDisable);
            _disable(grid.btnRemove);
        }

        if (acl_manage) {
            if (sm.getCount() == 1) {
                edit.enable();
                tabs.activate(edit);
                edit.cmpFill(grid.getSelectionModel().getSelected());
            } else {
                edit.disable();
                tabs.activate(help);
            }
        }

    });

    edit.on("actioncomplete", function() {
        grid.cmpReload();
    });

}