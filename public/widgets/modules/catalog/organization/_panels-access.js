Inprint.catalog.organization.Access = function(parent, panels) {
    
    var tree = panels.tree;
    var grid = panels.grid;
    
    _a(["domain.departments.manage", "domain.employees.manage"], null, function(terms) {
        if(terms["domain.departments.manage"]) {
            parent.access["departments"] = true;
        }
        if(terms["domain.employees.manage"]) {
            parent.access["employees"] = true;
            
            grid.btnAdd.enable();
            grid.btnAddToGroup.enable();
        
            grid.getSelectionModel().on("selectionchange", function(sm) {
                _disable( grid.btnDelete, grid.btnDeleteFromGroup );
                _disable( grid.btnViewProfile, grid.btnUpdateProfile, grid.btnManageRules);
                if (sm.getCount()) {
                    _enable( grid.btnDelete, grid.btnDeleteFromGroup );
                }
                if (sm.getCount() == 1) {
                    _enable( grid.btnViewProfile, grid.btnUpdateProfile, grid.btnManageRules);
                }
            });
            
        }
    });
    
}
