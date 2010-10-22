Inprint.cmp.CopyDocument.Interaction = function(panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    // Tree
    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        grid.enable();
        if (node) {
            grid.cmpLoad({ edition: node.id });
        }
    });

}
