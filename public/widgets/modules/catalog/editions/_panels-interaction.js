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

    // Set actions
    grid.btnCreateItem      .on("click", Inprint.getAction("stages.create")     .createDelegate(parent, [tree, grid]));
    grid.btnUpdateItem      .on("click", Inprint.getAction("stages.update")     .createDelegate(parent, [tree, grid]));
    grid.btnDeleteItem      .on("click", Inprint.getAction("stages.delete")     .createDelegate(parent, [tree, grid]));
    grid.btnSelectPrincipals.on("click", Inprint.getAction("stages.principals") .createDelegate(parent, [tree, grid]));

};
