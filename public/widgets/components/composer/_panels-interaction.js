Inprint.cmp.composer.Interaction = function(parent, panels) {

    var modules = panels["modules"];
    var flash   = panels["flash"];

    modules.getSelectionModel().on("selectionchange", function(sm) {

        if (sm.getCount() > 0) {
            modules.btnDelete.enable();
        }
        if (sm.getCount() == 0) {
            modules.btnDelete.disable();
        }
        
        if (sm.getCount() == 1) {
            Ext.Ajax.request({
                url: _url("/fascicle/modules/read/"),
                scope:this,
                success: function ( result, request ) {
                    var responce = Ext.util.JSON.decode(result.responseText);
                    flash.cmpMoveBlocks(responce.data.pages);
                },
                params: { id: modules.getValue("id") }
            });
        }
        
    }, parent);
    
    //parent.buttons[0].on("click", function(){
    //    
    //    var data = [];
    //    Ext.each(grid.getSelectionModel().getSelections(), function(record) {
    //        data.push(record.get("id") +'::'+ record.get("headline") +'::'+ record.get("rubric"));
    //    });
    //    
    //    Ext.Ajax.request({
    //        scope:this,
    //        url: _url("/documents/copy/"),
    //        params: {
    //            id: this.oid,
    //            copyto: data
    //        },
    //        success: function(form, action) {
    //            this.hide();
    //            this.fireEvent("actioncomplete", this);
    //        }
    //    });
    //}, parent)

}
