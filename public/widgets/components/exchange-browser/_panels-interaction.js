Inprint.cmp.ExcahngeBrowser.Interaction = function(parent, panels) {

    var editions = panels.editions;
    var stages = panels.stages;
    var principals = panels.principals;

    editions.autoSelect = true;
    stages.autoSelect = true;

    // Tree
    editions.getLoader().on("load", function(loader, node, rsp) {
        var selection = node.findChild("id", parent.edition);
        if (selection && editions.autoSelect) {
            editions.getSelectionModel().select(selection);
            editions.autoSelect = false;
        }
    });
    editions.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node) {
            stages.getRootNode().id = node.id;
            stages.getRootNode().reload();
        }
    });

    stages.getLoader().on("load", function(loader, node, rsp) {
        var selection = node.findChild("id", parent.stage);
        if (selection && stages.autoSelect) {
            stages.getSelectionModel().select(selection);
            stages.autoSelect = false;
        }
    });

    stages.getSelectionModel().on("selectionchange", function(sm, node) {
        principals.enable();
        if (node) {
            principals.cmpLoad({ node: node.id });
        }
    });

    //Grids
    principals.getSelectionModel().on("selectionchange", function(sm) {
        if (sm.getCount() > 0) {
            this.buttons[0].enable();
        } else {
            this.buttons[0].disable();
        }
    }, parent);

};
