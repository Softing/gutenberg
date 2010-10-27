Inprint.documents.briefcase.Interaction = function(panels) {

    var grid = panels.grid;
    
    grid.on("render", function() {
        grid.filter.getForm().findField("fascicle").on("afterrender", function(combo) {
            combo.setValue(_("Briefcase"));
            combo.hiddenField.value = "00000000-0000-0000-0000-000000000000";
            combo.disable();
        });
        grid.filter.getForm().findField("headline").on("render", function(combo) {
            combo.enable();
        });
    });

    grid.on("afterrender", function(grid) {
        grid.btnCreate.enable();
        grid.btnBriefcase.hide();
        grid.btnRestore.hide();
        grid.btnDelete.hide();
    });

};
