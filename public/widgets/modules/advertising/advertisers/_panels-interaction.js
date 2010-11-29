Inprint.advert.advertisers.Interaction = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    // Tree
    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node) {
            grid.getStore().baseParams = { edition: node.id  };
            grid.getStore().reload();
        }
    });

    //Grids
    grid.getSelectionModel().on("selectionchange", function(sm) {
        if (sm.getCount() > 0) {
            this.buttons[0].enable();
        } else {
            this.buttons[0].disable();
        }
    }, parent);

}
