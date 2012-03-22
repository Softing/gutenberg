Inprint.cmp.PrincipalsBrowser.Interaction = function(panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        grid.enable();
        if (node) {
            grid.cmpLoad({ node: node.id });
            grid.setTitle(_("Members") +' - '+ node.text);
        }
    });


};
