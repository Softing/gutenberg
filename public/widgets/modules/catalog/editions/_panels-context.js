Inprint.catalog.editions.Context = function(panels) {

    var tree = panels.tree;

    tree.on("contextmenu", function(node) {

        this.selection = node;

        var items = [];

        items.push({
            icon: _ico("book--plus"),
            cls: "x-btn-text-icon",
            text: _("Create"),
            ref: "../btnCreate",
            scope:this,
            handler: function() { this.cmpCreate(node); }
        }, {
            icon: _ico("book--pencil"),
            cls: "x-btn-text-icon",
            text: _("Edit"),
            ref: "../btnEdit",
            scope:this,
            handler: function() { this.cmpUpdate(node); }
        });

        if (node.attributes.id != NULLID) {
            items.push({
                icon: _ico("book--minus"),
                cls: "x-btn-text-icon",
                text: _("Remove"),
                ref: "../btnRemove",
                scope:this,
                handler: function() { this.cmpDelete(node); }
            });
        }
        
        items.push('-', {
            icon: _ico("arrow-circle-double"),
            cls: "x-btn-text-icon",
            text: _("Reload"),
            scope: this,
            handler: this.cmpReload
        });

        new Ext.menu.Menu({ items : items }).show(node.ui.getAnchor());

    }, tree);

}
