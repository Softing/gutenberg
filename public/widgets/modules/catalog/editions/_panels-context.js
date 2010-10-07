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
            handler: this.cmpCreate
        }, {
            icon: _ico("book--pencil"),
            cls: "x-btn-text-icon",
            text: _("Edit"),
            ref: "../btnEdit",
            scope:this,
            handler: this.cmpUpdate
        });

        if (node.attributes.id != NULLID) {
            items.push({
                icon: _ico("book--minus"),
                cls: "x-btn-text-icon",
                text: _("Remove"),
                ref: "../btnRemove",
                scope:this,
                handler: this.cmpDelete
            });
        }

        items.push('-', {
            text: _("Add chain"),
            icon: _ico("node-insert"),
            cls: "x-btn-text-icon",
            scope: this,
            handler: this.cmpReload
        }, {
            text: _("Change chain"),
            icon: _ico("node-design"),
            cls: "x-btn-text-icon",
            scope: this,
            handler: this.cmpReload
        }, {
            text: _("Delete chain"),
            icon: _ico("node-delete"),
            cls: "x-btn-text-icon",
            scope: this,
            handler: this.cmpReload
        });

        items.push('-', {
            icon: _ico("arrow-circle-double"),
            cls: "x-btn-text-icon",
            text: _("Reload"),
            scope: this,
            handler: this.cmpReload
        });

        new Ext.menu.Menu({ items : items }).show(node.ui.getAnchor());

    }, tree);

    //var grid = panels.grid;
    //
    //var items = [
    //    {   icon: _ico("plus-button"),
    //        cls: "x-btn-text-icon",
    //        text: _("Create chain"),
    //        handler: grid.actions.createChain
    //    },
    //    "-",
    //    {   icon: _ico("arrow-circle-double"),
    //        cls: "x-btn-text-icon",
    //        text: _("Reload"),
    //        scope: this,
    //        handler: function() {
    //            alert(2);
    //        }
    //    }
    //];
    //
    //var menu = new Ext.menu.Menu({ items : items });
    //
    //grid.on("contextmenu", function(e) {
    //    menu.showAt(e.getXY())
    //    e.preventDefault();
    //}, grid);

}
