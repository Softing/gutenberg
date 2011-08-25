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

    modules.on("templateDroped", function(mapping) {

        Ext.Ajax.request({
            url: parent.urls.modulesCreate,
            scope:this,
            params: {
                fascicle: parent.fascicle,
                pages: parent.selection,
                templates: mapping
            },
            success: function() {
                flash.cmpInit();
                modules.cmpReload();
            }
        });

    }, modules);

};
