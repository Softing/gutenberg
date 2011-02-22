Inprint.cmp.composer.Interaction = function(parent, panels) {

    var modules   = panels.modules;
    var templates = panels.templates;
    var flash     = panels.flash;

    modules.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node) {
            if(node.leaf) {
                flash.cmpMoveBlocks({
                    module: node.attributes.module,
                    page: node.attributes.page
                });
            }
        }
    }, modules);

    modules.on("contextmenu", function(node, e) {
        e.stopEvent();
        var items = [];
        items.push({
            icon: _ico("minus-button"),
            cls: "x-btn-text-icon",
            text: _("Remove"),
            ref: "../btnRemove",
            scope:this,
            handler: this.cmpDelete
        });
        var coords = e.getXY();
        new Ext.menu.Menu({ items : items }).show(node.ui.getAnchor());
    }, modules);

    modules.on("afterrender", function() {

        Ext.dd.DropTarget(modules.getEl(), {
            ddGroup    : 'principals-selector',
            notifyDrop : function(ddSource, e, data){
                var ids = [];
                Ext.each(ddSource.dragData.selections, function(r) {
                    ids.push(r.data.id);
                });
                Ext.Ajax.request({
                    url: _url("/fascicle/modules/create/"),
                    scope:this,
                    success: function() {
                        flash.cmpInit();
                        modules.cmpReload();
                    },
                    params: {
                        fascicle: parent.fascicle,
                        page: parent.selection,
                        module: ids
                    }
                });
                return true;
            }
        });

    }, this);

};
