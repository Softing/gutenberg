Inprint.documents.briefcase.Interaction = function(parent, panels) {

    var grid = panels.grid;
    
    grid.on("render", function() {
        grid.filter.getForm().findField("fascicle").on("afterrender", function(combo) {
            combo.setValue("00000000-0000-0000-0000-000000000000", _("Briefcase"));
            combo.disable();
        });
        grid.btnBriefcase.hide();
        grid.btnRestore.hide();
        grid.btnDelete.hide();
    });

};
