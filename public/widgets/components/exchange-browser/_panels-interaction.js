Inprint.cmp.ExcahngeBrowser.Interaction = function(parent, panels) {

    var editions = panels.editions;
    var stages = panels.stages;
    var principals = panels.principals;

    // Tree
    editions.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node) {
            stages.getRootNode().id = node.id;
            stages.getRootNode().reload();
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
