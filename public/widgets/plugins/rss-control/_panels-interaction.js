Inprint.plugins.rss.control.Interaction = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;
    var help = panels.help;

    var managed = false;

    // Tree

    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node && node.id) {
            grid.enable();
            grid.cmpFill(node.id);
        } else {
            grid.disable();
        }
    });

};
