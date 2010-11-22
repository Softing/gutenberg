Inprint.documents.todo.Interaction = function(parent, panels) {
    var grid = panels.grid;
    grid.on("afterrender", function(grid) {
        grid.btnCreate.enable();
        grid.btnRestore.hide();
        grid.btnDelete.hide();
    });
};
