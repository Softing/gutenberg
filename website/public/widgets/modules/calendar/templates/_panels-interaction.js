Inprint.calendar.templates.Interaction = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    // Open issues Tree
    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        grid.disable();
        if (node && node.id) {
            grid.enable();
            grid.currentEdition = node.id;
            _a(["editions.template.manage:*"], grid.currentEdition, function(access) {
                grid.cmpLoad({
                    edition: grid.currentEdition
                });
            });
        }
    });

};
