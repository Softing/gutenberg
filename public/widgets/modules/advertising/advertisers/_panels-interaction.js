Inprint.advert.advertisers.Interaction = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    // Tree
    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node) {
            parent.currentEdition = node.id;
            grid.getStore().baseParams = { edition: parent.currentEdition  };
            grid.getStore().reload();
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
