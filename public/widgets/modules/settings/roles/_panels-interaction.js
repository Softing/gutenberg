Inprint.settings.roles.Interaction = function(panels) {

    var tab    = panels.tab;
    var tree   = panels.tree;
    var grid   = panels.grid;
    var edit   = panels.edit;
    var help   = panels.help;
    var access = panels.access;

    grid.enable();

    // Grid
    grid.btnAdd.enable();

    grid.getSelectionModel().on("selectionchange", function(sm) {

        // Select
        if (sm.getCount()) {
            _enable(grid.btnEnable, grid.btnDisable, grid.btnRemove);
        } else {
            _disable(grid.btnEnable, grid.btnDisable, grid.btnRemove);
        }

        // Single select
        if (sm.getCount() == 1) {
            edit.enable();
            access.enable();
            tab.activate(edit);
            edit.cmpFill( grid.getSelectionModel().getSelected() );
        } else {
            edit.disable();
            access.disable();
            tab.activate(help);
        }

    });

    // Card
    edit.on("actioncomplete", function() {
        grid.cmpReload();
    });

    //Access
    access.on("activate", function() {
        access.params = {
            role: grid.getValue("id")
        }
        access.cmpLoad();
    });

}