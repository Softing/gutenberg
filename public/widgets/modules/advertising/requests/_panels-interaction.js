Inprint.advert.requests.Interaction = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    // Tree
    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node) {
            grid.enable();
            grid.cmpLoad({ id: node.attributes.id, type: node.attributes.type });
            parent.currentEdition  = node.attributes.edition;
            parent.currentFascicle = node.attributes.fascicle;
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

};
