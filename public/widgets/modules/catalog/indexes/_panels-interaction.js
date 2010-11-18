Inprint.catalog.indexes.Interaction = function(parent, panels) {

    var editions  = panels.editions;
    var headlines = panels.headlines;
    var rubrics   = panels.rubrics;

    // Tree
    editions.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node) {
            headlines.getRootNode().id = node.id;
            headlines.getRootNode().reload();
        }
    });

    headlines.getSelectionModel().on("selectionchange", function(sm, node) {
        rubrics.enable();
        if (node) {
            rubrics.cmpLoad({ node: node.id });
        }
    });

    //Grids
    rubrics.getSelectionModel().on("selectionchange", function(sm) {
        if (sm.getCount() > 0) {
            this.buttons[0].enable();
        } else {
            this.buttons[0].disable();
        }
    }, parent);

}
