Inprint.fascicle.places.Context = function(parent, panels) {

    var tree = panels["places"];

    tree.on("contextmenu", function(node) {
        
        this.selection = node;

        var nodeid = node.attributes.id;
        var nodetype = node.attributes.type;
        
        var disabled = false;
        var items = [];
        
        if (nodetype == 'edition') {
            items.push({
                icon: _ico("zone--plus"),
                cls: "x-btn-text-icon",
                text: _("Create"),
                disabled: disabled,
                ref: "../btnCreate",
                scope:this,
                handler: function() { this.cmpCreate(node); }
            });
        }
        if (nodetype == 'module') {
            items.push({
                icon: _ico("zone--pencil"),
                cls: "x-btn-text-icon",
                text: _("Edit"),
                disabled: disabled,
                ref: "../btnEdit",
                scope:this,
                handler: function() { this.cmpUpdate(node); }
            });
            items.push({
                icon: _ico("zone--minus"),
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
