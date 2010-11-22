Inprint.documents.archive.Interaction = function(parent, panels) {

    var grid = panels.grid;

    grid.on("render", function(grid) {
        grid.btnRestore.hide();
        grid.btnDelete.hide();
    });

};
