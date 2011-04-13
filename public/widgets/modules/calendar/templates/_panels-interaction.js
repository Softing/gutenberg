Inprint.calendar.templates.Interaction = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    // Open issues Tree
    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node && node.id) {

            grid.enable();
            grid.currentEdition = node.id;
            _disable(grid.btnCreateFascicle, grid.btnCreateAttachment);

            _a(["editions.template.manage:*"], grid.currentEdition, function(access) {

                if (access["editions.template.manage"] === true) {
                    _enable(grid.btnCreateFascicle, grid.btnCreateAttachment);
                }

                grid.cmpLoad({
                    archive: "false",
                    fastype: "issue",
                    edition: grid.currentEdition
                });

            });

        } else {
            grid.disable();
        }
    });

    // Grid
    grid.getSelectionModel().on("selectionchange", function(sm, node) {

    });

};
