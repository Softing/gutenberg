Inprint.cmp.Adverta.Interaction = function(parent, panels) {

    var request   = panels["request"];
    var templates = panels["templates"];
    var modules   = panels["modules"];
    var flash     = panels["flash"];

    if (modules) {

        var gridModules   = modules.panels["modules"];
        var gridTemplates = modules.panels["templates"];

        gridModules.getSelectionModel().on("selectionchange", function(sm, node) {
            if (node) {
                if(node.leaf) {
                    flash.cmpMoveBlocks({
                        module: node.attributes.module,
                        page: node.attributes.page
                    });
                }
            }
        }, gridModules);

        gridModules.on("contextmenu", function(node, e) {
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
        }, gridModules);

        gridModules.on("afterrender", function() {
            new Ext.dd.DropTarget(modules.getEl(), {
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
                            gridModules.cmpReload();
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

        }, gridModules);

        //modules.on("rowcontextmenu", function(grid, rindex, e) {
        //    e.stopEvent();
        //    var items = [];
        //    items.push({
        //        icon: _ico("minus-button"),
        //        cls: "x-btn-text-icon",
        //        text: _("Remove"),
        //        ref: "../btnRemove",
        //        scope:this,
        //        handler: this.cmpDelete
        //    });
        //    var coords = e.getXY();
        //    new Ext.menu.Menu({ items : items }).showAt([coords[0], coords[1]]);
        //}, modules);
        //
        //modules.on("afterrender", function(panel) {
        //
        //    var selection = panel.parent.selection;
        //    var fascicle  = panel.parent.fascicle;
        //
        //    new Ext.dd.DropTarget(modules.getView().scroller.dom, {
        //
        //        ddGroup    : 'principals-selector',
        //        notifyDrop : function(ddSource, e, data){
        //
        //            var ids = [];
        //
        //            Ext.each(ddSource.dragData.selections, function(r) {
        //                ids.push(r.data.id);
        //            });
        //
        //            Ext.Ajax.request({
        //                url: _url("/fascicle/modules/create/"),
        //                scope: panel.parent,
        //                success: function() {
        //                    this.panels["flash"].cmpInit();
        //                    this.panels["modules"].panels["modules"].cmpReload();
        //                },
        //                params: {
        //                    fascicle: fascicle,
        //                    page: selection,
        //                    module: ids
        //                }
        //            });
        //
        //            return true;
        //        }
        //
        //    });
        //
        //}, this);

    }

    request.getForm().on("actioncomplete", function(form, action){
            if (action.type == "submit") {
                this.hide();
                this.fireEvent("actioncomplete");
            }
        }, parent);

}
