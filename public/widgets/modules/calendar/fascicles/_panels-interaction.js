Inprint.calendar.fascicles.Interaction = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    // Open issues Tree
    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node && node.id) {

            grid.enable();
            grid.currentEdition = node.id;

            _disable(grid.btnUpdate, grid.btnDelete, grid.btnArchive, grid.btnDeadline, grid.btnTemplate, grid.btnFormat);

            _a(["editions.calendar.manage:*"], grid.currentEdition, function(access) {

                (access["editions.calendar.manage"] === true) ?
                    _enable(grid.btnCreate) : _disable(grid.btnCreate) ;

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
        _disable(grid.btnUpdate, grid.btnDelete, grid.btnEnable, grid.btnDisable,
            grid.btnArchive, grid.btnDeadline, grid.btnTemplate, grid.btnFormat);
        if (node && node.attributes.fastype == "issue") {
            _enable(grid.btnUpdate, grid.btnDelete, grid.btnEnable, grid.btnDisable,
                grid.btnArchive, grid.btnDeadline, grid.btnTemplate, grid.btnFormat);
        }
    });

};
