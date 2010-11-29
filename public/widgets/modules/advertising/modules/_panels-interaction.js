Inprint.advert.modules.Interaction = function(parent, panels) {

    var tree = panels["places"];
    var grid = panels["modules"];

    // Tree
    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node) {
            grid.cmpLoad({ edition: node.attributes.edition, fascicle: node.attributes.fascicle });
        }
    });

    //Grids
    grid.getSelectionModel().on("selectionchange", function(sm) {
        if (sm.getCount() > 0) {
            this.buttons[0].enable();
        } else {
            this.buttons[0].disable();
        }
    }, parent);

}
