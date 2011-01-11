Inprint.catalog.organization.Context = function(parent, panels) {

    var tree = panels.tree;

    tree.on("contextmenu", function(node) {

        this.selection = node;

        var disabled = true;
        var items = [];

        if (parent.access["departments"]) {
            disabled = false;
        }

        items.push(
            {
                icon: _ico("folder--plus"),
                cls: "x-btn-text-icon",
                text: _("Create"),
                disabled: disabled,
                ref: "../btnCreate",
                scope:this,
                handler: function() { this.cmpCreate(node); }
            },
            {
                icon: _ico("folder--pencil"),
                cls: "x-btn-text-icon",
                text: _("Edit"),
                disabled: disabled,
                ref: "../btnEdit",
                scope:this,
                handler: function() { this.cmpUpdate(node); }
            }
        );

        if (node.attributes.id != NULLID) {
            items.push({
                icon: _ico("folder--minus"),
                cls: "x-btn-text-icon",
                text: _("Remove"),
                disabled: disabled,
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
