Inprint.cmp.Adverta.Interaction = function(parent, panels) {

    var request   = panels.request;
    var templates = panels.templates;
    var modules   = panels.modules;
    var flash     = panels.flash;

    if (modules) {

        var gridModules   = modules.panels.modules;
        var gridTemplates = modules.panels.templates;

        gridModules.getSelectionModel().on("selectionchange", function(sm, node) {
            if (node) {
                if(node.leaf) {
                    flash.cmpMoveBlocks({
                        module: node.attributes.mapping,
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

        gridModules.on("templateDroped", function(id) {

            Ext.Ajax.request({
                url: _url("/fascicle/modules/create/"),
                scope:this,
                params: {
                    fascicle: parent.fascicle,
                    pages: parent.selection,
                    template: id
                },
                success: function() {
                    flash.cmpInit();
                    gridModules.cmpReload();
                }
            });

        }, gridModules);

    }

    request.getForm().on("actioncomplete", function(form, action){
            if (action.type == "submit") {
                this.hide();
                this.fireEvent("actioncomplete", form, action);
            }
        }, parent);

    request.getForm().on("actionfailed", function(form, action){
            if (action.type == "submit") {
                this.fireEvent("actionfailed", form, action);
            }
        }, parent);


};
