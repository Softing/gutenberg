Inprint.settings.departments.Interaction = function(panels) {

    var tree    = panels.tree;
    var grid    = panels.grid;
    var edit    = panels.edit;
    var help    = panels.help;
    var members = panels.members;

    // Tree

    tree.cmpExpand({
        accessFilterBy: "departments"
    });

    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node.id == "root-node") {
            grid.disable();
            grid.cmpClear();
        } else {
            grid.enable();
            grid.cmpLoad({ edition: node.id });
        }
    });

    // Grid
    grid.on("enable", function() {
        grid.btnAdd.enable();
    });

    grid.getSelectionModel().on("selectionchange", function(sm) {

        // Select
        if (sm.getCount())
            _enable(grid.btnEnable, grid.btnDisable, grid.btnRemove);
        else
            _disable(grid.btnEnable, grid.btnDisable, grid.btnRemove);

        // Single select
        if (sm.getCount() == 1) {
            edit.enable();
            members.enable();
            panels.tab.activate(edit);
            edit.cmpFill( grid.getSelectionModel().getSelected() );
        } else {
            edit.disable();
            members.disable();
            panels.tab.activate(help);
        }

    });

    // Card
    edit.on("actioncomplete", function() {
        grid.cmpReload();
    });

    //Members
    members.on("activate", function() {
        members.params = {
            edition: grid.getValue("edition"),
            department: grid.getValue("id")
        }
        members.cmpLoad();
    });

}