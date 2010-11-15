Inprint.catalog.roles.Access = function(parent, panels) {
    var grid   = panels.grid;
    _disable(grid.btnCreate, grid.btnUpdate, grid.btnManageRules, grid.btnDelete);
    _a(["domain.roles.manage"], null, function(terms) {
        if(terms["domain.roles.manage"]) {
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
    });
}
