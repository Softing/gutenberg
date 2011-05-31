Inprint.catalog.editions.Context = function(parent, panels) {

    var tree = panels.tree;

    tree.on("contextmenu", function(node) {

        this.selection = node;

        var disabled = true;
        var items = [];

        if (parent.access.editions) {
            disabled = false;
        }

        var btnCreate = Inprint.getButton("create.item");
        btnCreate.handler = Inprint.getAction("edition.create").createDelegate(parent, [tree]);

        items.push( btnCreate );

        if (node.id != NULLID) {

            var btnUpdate = Inprint.getButton("update.item");
            btnUpdate.handler = Inprint.getAction("edition.update").createDelegate(parent, [tree]);
            items.push( btnUpdate );

            var btnDelete = Inprint.getButton("delete.item");
            btnDelete.handler = Inprint.getAction("edition.delete").createDelegate(parent, [tree]);
            items.push( btnDelete );

        }

        items.push('-');
        items.push({
            icon: _ico("arrow-circle-double"),
            cls: "x-btn-text-icon",
            text: _("Reload"),
            scope: this,
            handler: this.cmpReload
        });

        new Ext.menu.Menu({ items : items }).show(node.ui.getAnchor());

    }, tree);

};
