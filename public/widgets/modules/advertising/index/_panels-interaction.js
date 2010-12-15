Inprint.advert.index.Interaction = function(parent, panels) {

    var tree = panels["places"];
    var grid = panels["modules"];

    // Tree
    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        grid.disable();
        if (node && node.attributes.type == "module") {
            
            grid.enable();
            grid.cmpLoad({ id: node.attributes.id, type: node.attributes.type });
            grid.params["place"] = node.attributes.id;
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
