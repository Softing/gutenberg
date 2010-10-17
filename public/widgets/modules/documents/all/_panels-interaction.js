Inprint.documents.all.Interaction = function(panels) {

    var grid = panels.grid;

    grid.on("afterrender", function(grid) {
        grid.btnCreate.enable();
        grid.btnRestore.hide();
        grid.btnDelete.hide();
    });

    grid.getSelectionModel().on("selectionchange", function(sm) {
        if (sm.getCount() > 0 ) {
            _enable(grid.btnUpdate, grid.btnCapture, grid.btnTransfer, grid.btnBriefcase, grid.btnCopy,
                    grid.btnDuplicate, grid.btnRecycle, grid.btnRestore, grid.btnDelete);
        }

        if (sm.getCount() == 1) {
            _enable(grid.btnUpdate, grid.btnCapture, grid.btnTransfer, grid.btnBriefcase, grid.btnCopy,
                    grid.btnDuplicate, grid.btnRecycle, grid.btnRestore, grid.btnDelete);
        }

        if (sm.getCount() == 0 ) {
            _disable(grid.btnUpdate, grid.btnCapture, grid.btnTransfer, grid.btnBriefcase, grid.btnCopy,
                    grid.btnDuplicate, grid.btnRecycle, grid.btnRestore, grid.btnDelete);
        }
    });

};
