Inprint.catalog.roles.Interaction = function(panels) {

    var grid   = panels.grid;
    var help   = panels.help;

    // Grid
    grid.enable();
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
            _enable(grid.btnManageRules);
        } else {
            _disable(grid.btnManageRules);
        }
    });

}
