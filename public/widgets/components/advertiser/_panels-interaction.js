Inprint.cmp.adverta.Interaction = function(parent, panels) {
    
    var request   = panels["request"];
    var templates = panels["templates"];
    var modules   = panels["modules"];
    var flash     = panels["flash"];
    
    var gridModules   = modules.panels["modules"];
    var gridTemplates = modules.panels["templates"];
    
    request.getForm().on("actioncomplete", function(form, action){
            if (action.type == "submit") {
                this.hide();
                this.fireEvent("actioncomplete");
            }
        }, parent);

    gridModules.getSelectionModel().on("selectionchange", function(sm) {
        if (sm.getCount() == 1) {
            Ext.Ajax.request({
                url: _url("/fascicle/modules/read/"),
                scope:this,
                success: function ( result, request ) {
                    var responce = Ext.util.JSON.decode(result.responseText);
                    flash.cmpMoveBlocks(responce.data.pages);
                },
                params: { id: gridModules.getValue("id") }
            });
        }
    }, parent);
    
    
}
