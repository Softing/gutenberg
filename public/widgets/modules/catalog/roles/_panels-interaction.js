Inprint.catalog.roles.Interaction = function(panels) {

    var grid   = panels.grid;
    var help   = panels.help;

    // Grid
    grid.enable();
    grid.btnCreate.enable();

    grid.getSelectionModel().on("selectionchange", function(sm) {
        
        _disable(grid.btnUpdate, grid.btnManageRules, grid.btnDelete);

        if (sm.getCount() == 1) {
            _enable(grid.btnUpdate, grid.btnManageRules, grid.btnDelete);
        } else if (sm.getCount() > 1) {
            _enable(grid.btnDelete);
        }
        
    });

}
