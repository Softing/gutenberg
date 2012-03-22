Inprint.catalog.readiness.Interaction = function(parent, panels) {

    var grid = panels.grid;
    var help = panels.help;

    // Set Actions
    grid.btnCreateItem.on("click",       Inprint.getAction("readiness.create")    .createDelegate(parent, [grid]));
    grid.btnUpdateItem.on("click",       Inprint.getAction("readiness.update")    .createDelegate(parent, [grid]));
    grid.btnDeleteItem.on("click",       Inprint.getAction("readiness.delete")    .createDelegate(parent, [grid]));

    // Grid Readiness Events
    grid.getSelectionModel().on("selectionchange", function(sm) {
        _disable(grid.btnUpdateItem, grid.btnDeleteItem);
        if(parent.access["domain.readiness.manage"]) {
            if (sm.getCount() == 1) {
                _enable(grid.btnUpdateItem, grid.btnDeleteItem);
            } else if (sm.getCount() > 1) {
                _enable(grid.btnDeleteItem);
            }
        }
    });

    // Set Access
    _a(["domain.readiness.manage"], null, function(terms) {
        parent.access = terms;
        if(parent.access["domain.readiness.manage"]) {
            grid.btnCreateItem.enable();
        }
    });

};
