Inprint.advert.modules.Interaction = function(parent, panels) {

    var tree = panels["editions"];
    var grid = panels["pages"];

    // Tree
    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        grid.disable();
        if (node) {
            
            parent.edition = node.attributes.id;
            
            grid.enable();
            grid.cmpLoad({ edition: node.attributes.id });
        }
    });

    //Grids
    grid.getSelectionModel().on("selectionchange", function(sm) {
        _disable(grid.btnUpdate, grid.btnDelete);
        if (sm.getCount() == 1) {
            _enable(grid.btnUpdate, grid.btnDelete);
        } else if (sm.getCount() > 1) {
            _enable(grid.btnDelete);
        }
    }, parent);

}
