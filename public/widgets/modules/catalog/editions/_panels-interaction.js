Inprint.catalog.editions.Interaction = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;
    var help = panels.help;

    var currentStage;

    // Tree

    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node && node.id) {
            grid.enable();
            grid.cmpLoad({ branch: node.id });
        } else {
            grid.disable();
        }
    });

    // Stages
    //grid.btnCreateStage.on("click", grid.actions.createStage.createDelegate(this));
    //grid.btnChangeStage.on("click", grid.actions.changeStage.createDelegate(this));
    //grid.btnRemoveStage.on("click", grid.actions.removeStage.createDelegate(this));
    //grid.btnManagePrincipals.on("click", grid.actions.managePrincipals.createDelegate(this));

};
