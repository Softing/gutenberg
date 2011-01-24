Inprint.plugins.rss.Access = function(parent, panels) {

    var grid = panels.grid;

    grid.getSelectionModel().on("selectionchange", function(sm) {

        //var records = grid.getSelectionModel().getSelections();
        //var access = _arrayAccessCheck(records, ['delete', 'recover', 'update', 'capture', 'move', 'transfer', 'briefcase']);
        //
        //_disable(grid.btnUpdate, grid.btnCapture, grid.btnTransfer, grid.btnMove, grid.btnBriefcase, grid.btnCopy,
        //            grid.btnDuplicate, grid.btnRecycle, grid.btnRestore, grid.btnDelete);
        //
        //if (sm.getCount() == 1) {
        //    if (access["move"]      == 'enabled') grid.btnCopy.enable();
        //    if (access["move"]      == 'enabled') grid.btnDuplicate.enable();
        //}
        //
        //if (sm.getCount() > 0 ) {
        //    if (access["move"]      == 'enabled') grid.btnCopy.enable();
        //    if (access["move"]      == 'enabled') grid.btnDuplicate.enable();
        //}

    });

};
