Inprint.plugins.rss.control.Context = function(parent, panels) {

    var tree = panels.tree;

    tree.on("contextmenu", function(node) {

        this.selection = node;

        var disabled = true;
        var items = [];

        //if (parent.access.editions) {
            disabled = false;
        //}

        items.push({
            icon: _ico("feed--plus"),
            cls: "x-btn-text-icon",
            text: _("Create"),
            disabled: disabled,
            ref: "../btnCreate",
            scope:this,
            handler: function() { this.cmpCreate(node); }
        });

        if (node.id != NULLID) {
            items.push({
                icon: _ico("feed--pencil"),
                cls: "x-btn-text-icon",
                text: _("Edit"),
                disabled: disabled,
                ref: "../btnEdit",
                scope:this,
                handler: function() { this.cmpUpdate(node); }
            });
            items.push({
                icon: _ico("feed--minus"),
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

};
