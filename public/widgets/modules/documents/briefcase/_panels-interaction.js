Inprint.documents.briefcase.Interaction = function(panels) {

    var grid = panels.grid;

    grid.on("render", function() {
        var flt_fascicle = grid.getHeaderFilterField("flt_fascicle");
        flt_fascicle.setValue("00000000-0000-0000-0000-000000000000");
        flt_fascicle.setRawValue(_("Briefcase"));
        flt_fascicle.disable();
        grid.applyHeaderFilters(false);
    });

    grid.on("afterrender", function(grid) {
        grid.btnCreate.enable();
        grid.btnBriefcase.hide();
        grid.btnRestore.hide();
        grid.btnDelete.hide();
    });

};
