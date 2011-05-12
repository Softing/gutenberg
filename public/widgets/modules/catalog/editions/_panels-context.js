Inprint.catalog.editions.Context = function(parent, panels) {

    var tree = panels.tree;

    tree.on("contextmenu", function(node) {

        this.selection = node;

        var disabled = true;
        var items = [];

        if (parent.access.editions) {
            disabled = false;
        }

        items.push( Inprint.getAction("edition.create", this, { disabled: disabled }) );

        if (node.id != NULLID) {
            items.push( Inprint.getAction("edition.update", this, { disabled: disabled }) );
            items.push( Inprint.getAction("edition.delete", this, { disabled: disabled }) );
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

};
