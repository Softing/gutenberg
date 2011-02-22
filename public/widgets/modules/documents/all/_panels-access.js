Inprint.documents.all.Access = function(parent, panels) {

    var grid = panels.grid;

    grid.btnCreate.enable();

    grid.getSelectionModel().on("selectionchange", function(sm) {

        var records = grid.getSelectionModel().getSelections();
        var access = _arrayAccessCheck(records, ['delete', 'recover', 'update', 'capture', 'move', 'transfer', 'briefcase']);

        _disable(grid.btnUpdate, grid.btnCapture, grid.btnTransfer, grid.btnMove, grid.btnBriefcase, grid.btnCopy,
                    grid.btnDuplicate, grid.btnRecycle, grid.btnRestore, grid.btnDelete);

        if (sm.getCount() == 1) {
            if (access.update    == 'enabled') {
                grid.btnUpdate.enable();
            }
            if (access.capture   == 'enabled') {
                grid.btnCapture.enable();
            }
            if (access.transfer  == 'enabled') {
                grid.btnTransfer.enable();
            }
            if (access.briefcase == 'enabled') {
                grid.btnBriefcase.enable();
            }
            if (access.move      == 'enabled') {
                grid.btnCopy.enable();
            }
            if (access.move      == 'enabled') {
                grid.btnDuplicate.enable();
            }
            if (access.recover   == 'enabled') {
                grid.btnRestore.enable();
            }
            if (access["delete"]    == 'enabled') {
                grid.btnRecycle.enable();
            }
            if (access["delete"]    == 'enabled') {
                grid.btnDelete.enable();
            }
        }

        if (sm.getCount() > 0 ) {
            if (access.update    == 'enabled') {
                grid.btnCapture.enable();
            }
            if (access.transfer  == 'enabled') {
                grid.btnTransfer.enable();
            }
            if (access.capture   == 'enabled') {
                grid.btnCapture.enable();
            }
            if (access.transfer  == 'enabled') {
                grid.btnTransfer.enable();
            }
            if (access.briefcase == 'enabled') {
                grid.btnBriefcase.enable();
            }
            if (access.move      == 'enabled') {
                grid.btnMove.enable();
            }
            if (access.move      == 'enabled') {
                grid.btnCopy.enable();
            }
            if (access.move      == 'enabled') {
                grid.btnDuplicate.enable();
            }
            if (access.recover   == 'enabled') {
                grid.btnRestore.enable();
            }
            if (access["delete"]    == 'enabled') {
                grid.btnRecycle.enable();
            }
            if (access["delete"]    == 'enabled') {
                grid.btnDelete.enable();
            }
        }

    });

};
