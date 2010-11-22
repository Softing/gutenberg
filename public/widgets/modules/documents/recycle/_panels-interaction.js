Inprint.documents.recycle.Interaction = function(parent, panels) {

    var grid = panels.grid;

    grid.on("render", function() {
        grid.filter.getForm().findField("fascicle").on("afterrender", function(combo) {
            combo.setValue("99999999-9999-9999-9999-999999999999", _("Recycle bin"));
            combo.disable();
        });
        grid.btnRecycle.hide();
    });
    
};
