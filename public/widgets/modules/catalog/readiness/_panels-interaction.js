Inprint.catalog.readiness.Interaction = function(panels) {
    
    var grid = panels.grid;
    var help = panels.help;

    // Grid behaviour

    grid.btnCreate.enable();

    grid.on("afterrender", function (grid) {
        grid.getStore().load();
    });

    grid.getSelectionModel().on("selectionchange", function(sm) {

        _disable(grid.btnUpdate, grid.btnDelete);

        if (sm.getCount() == 1) {
            _enable(grid.btnUpdate, grid.btnDelete);
        } else if (sm.getCount() > 1) {
            _enable(grid.btnDelete);
        }
        
    });
}
