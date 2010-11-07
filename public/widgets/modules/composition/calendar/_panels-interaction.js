Inprint.edition.calendar.Interaction = function(panels) {

    var tree = panels.tree;
    var grid = panels.grid;
    var help = panels.help;

    var managed = false;

    // Tree

    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node && node.id) {
            grid.enable();
            grid.currentEdition = node.id;
            grid.cmpLoad({ edition: grid.currentEdition });
        } else {
            grid.disable();
        }
    });

    // Grid
    
    grid.getStore().on("load", function(){
        
        managed = false;
        grid.btnCreate.disable();
        
        Ext.Ajax.request({
            url: _url("/access/"),
            params: {
                term: "editions.calendar.manage",
                binding: grid.currentEdition
            },
            scope: this,
            success: function(result) {
                var data = Ext.util.JSON.decode(result.responseText);
                if (data.success == true) {
                    managed = true;
                    grid.btnCreate.enable();
                }
            }
        });
    });
    
    grid.getSelectionModel().on("selectionchange", function(sm) {
        
        this.btnUpdate.disable();
        this.btnDelete.disable();
        this.btnEnable.disable();
        this.btnDisable.disable();
        
        if (sm.getCount() == 1 && managed) {
            this.btnUpdate.enable();
            this.btnDelete.enable();
            this.btnEnable.enable();
            this.btnDisable.enable();
        }
        
        if (sm.getCount() > 1 && managed) {
            this.btnUpdate.disable();
            this.btnDelete.enable();
            this.btnEnable.enable();
            this.btnDisable.enable();
        }
    
    }, grid);
    

}
