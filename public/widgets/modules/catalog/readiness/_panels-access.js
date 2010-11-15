Inprint.catalog.readiness.Access = function(parent, panels) {
    var grid   = panels.grid;
    _disable(grid.btnCreate, grid.btnUpdate, grid.btnManageRules, grid.btnDelete);
    _a(["domain.readiness.manage"], null, function(terms) {
        if(terms["domain.readiness.manage"]) {
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
