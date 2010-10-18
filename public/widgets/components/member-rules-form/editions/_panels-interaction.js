Inprint.cmp.memberRulesForm.Editions.Interaction = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    // Tree
    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        grid.enable();
        if (node) {
            grid.cmpFill(parent.memberId, node.id);
        }
    });
}
