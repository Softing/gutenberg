Inprint.catalog.roles.Interaction = function(panels) {

    var tab    = panels.tab;
    var tree   = panels.tree;
    var grid   = panels.grid;
    var edit   = panels.edit;
    var help   = panels.help;
    var access = panels.access;

    grid.enable();

    // Grid
    grid.btnCreate.enable();

    grid.getSelectionModel().on("selectionchange", function(sm) {

        // Select
        if (sm.getCount()) {
            _enable(grid.btnDelete);
        } else {
            _disable(grid.btnDelete);
        }

        // Single select
        if (sm.getCount() == 1) {
            _enable(edit, access);
            edit.cmpFill();
            access.cmpFill();
        } else {
            _disable(edit, access);
        }

    });

    // Card
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

    //Access
    access.cmpGetId = function() {
        return grid.getSelectionModel().getSelected().get("id");
    }

    access.on("activate", function() {
        access.cmpFill();
    });

}
