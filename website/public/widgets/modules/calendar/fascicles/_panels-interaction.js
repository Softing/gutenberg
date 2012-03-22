Inprint.calendar.fascicles.Interaction = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    // Open issues Tree
    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node && node.id) {

            grid.enable();

            grid.currentEdition = node.id;

            _disable(grid.btnUpdate, grid.btnDelete, grid.btnArchive, grid.btnDeadline, grid.btnTemplate, grid.btnFormat);

            _a(["editions.fascicle.manage:*", "editions.attachment.manage:*"], grid.currentEdition, function(access) {

                (access["editions.fascicle.manage"] === true) ?
                    _enable(grid.btnCreate) : _disable(grid.btnCreate) ;

                (access["editions.attachment.manage"] === true) ?
                    _enable(grid.btnCreateAttachment) : _disable(grid.btnCreateAttachment) ;

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

        _disable(
            grid.btnEnable, grid.btnDisable,
            grid.btnDoApproval, grid.btnDoWorking, grid.btnDoArchive,
            grid.btnArchive, grid.btnDeadline, grid.btnTemplate, grid.btnFormat);

        if (!node) return;

        _a(["editions.fascicle.manage:*", "editions.attachment.manage:*"], node.attributes.edition, function(access) {

            if (access["editions.fascicle.manage"] && node.attributes.fastype == "issue") {
                _enable(
                    grid.btnEnable, grid.btnDisable,
                    grid.btnDoApproval, grid.btnDoWorking, grid.btnDoArchive,
                    grid.btnArchive, grid.btnDeadline, grid.btnTemplate, grid.btnFormat);
            }

            if (access["editions.attachment.manage"] && node.attributes.fastype == "attachment") {
                _enable(
                    grid.btnEnable, grid.btnDisable,
                    grid.btnDoApproval, grid.btnDoWorking, grid.btnDoArchive,
                    grid.btnDeadline, grid.btnTemplate, grid.btnFormat);
            }

        });

    });

};
