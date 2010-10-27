Inprint.documents.recycle.Interaction = function(panels) {

    var grid = panels.grid;

    grid.on("render", function() {
        grid.filter.getForm().findField("fascicle").on("afterrender", function(combo) {
            combo.setValue(_("Recycle bin"));
            combo.hiddenField.value = "99999999-9999-9999-9999-999999999999";
            combo.disable();
        });
        grid.filter.getForm().findField("headline").on("render", function(combo) {
            combo.enable();
        });
    });

    grid.on("afterrender", function(grid) {
        grid.btnCreate.enable();
        grid.btnRecycle.hide();
    });

    grid.getSelectionModel().on("selectionchange", function(sm) {
        if (sm.getCount() > 0 ) {
            _enable(grid.btnUpdate, grid.btnCapture, grid.btnTransfer, grid.btnBriefcase, grid.btnCopy,
                    grid.btnDuplicate, grid.btnRecycle, grid.btnRestore, grid.btnDelete);
        } else if (sm.getCount() == 1) {
            _enable(grid.btnUpdate, grid.btnCapture, grid.btnTransfer, grid.btnBriefcase, grid.btnCopy,
                    grid.btnDuplicate, grid.btnRecycle, grid.btnRestore, grid.btnDelete);
        } else {
            _disable(grid.btnUpdate, grid.btnCapture, grid.btnTransfer, grid.btnBriefcase, grid.btnCopy,
                    grid.btnDuplicate, grid.btnRecycle, grid.btnRestore, grid.btnDelete);
        }
    });


};
