Inprint.cmp.PrincipalsSelector.Interaction = function(panels) {

    var tree = panels.tree;
    var principals = panels.principals;
    var selection  = panels.selection;

    // Tree
    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        principals.enable();
        if (node) {
            principals.cmpLoad({ node: node.id });
        }
    });

    //Grids
    selection.on("rowcontextmenu", function(grid, rindex, e) {
        e.stopEvent();
        var items = [];
        items.push({
            icon: _ico("book--minus"),
            cls: "x-btn-text-icon",
            text: _("Remove"),
            ref: "../btnRemove",
            scope:this,
            handler: function() {
                this.fireEvent("delete", this, this.getValues("id"));
            }
        });
        var coords = e.getXY();
        new Ext.menu.Menu({ items : items }).showAt([coords[0], coords[1]]);
    }, selection);

    selection.on("afterrender", function() {
        var firstGridDropTarget = new Ext.dd.DropTarget(selection.getView().scroller.dom, {
                ddGroup    : 'principals-selector',
                notifyDrop : function(ddSource, e, data){
                    var catalog = tree.cmpGetNodeId();
                    var ids = [];
                    Ext.each(ddSource.dragData.selections, function(r) {
                        ids.push(r.data.id);
                    });
                    selection.fireEvent("save", selection, catalog, ids);
                    return true;
                }
        });
    });

};
