Inprint.catalog.editions.Access = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    _a(["domain.editions.manage", "domain.exchange.manage"], null, function(terms) {
        if(terms["domain.editions.manage"]) {
            parent.access.editions = true;
        }
        if(terms["domain.exchange.manage"]) {

            parent.access.exchange = true;

            grid.btnCreateItem.enable();

            grid.getSelectionModel().on("selectionchange", function(sm) {
                if (sm.getCount()) {
                    _enable(grid.btnDeleteItem);
                } else {
                    _disable(grid.btnDeleteItem);
                }
                if (sm.getCount() == 1) {
                    currentStage = grid.getValue("id");
                   _enable(grid.btnUpdateItem, grid.btnSelectPrincipals);
                } else {
                   _disable(grid.btnUpdateItem, grid.btnSelectPrincipals);
                }
            });

        }
    });

};
