Inprint.calendar.archive.Context = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    grid.on("contextmenu", function(node) {

        var items = [];

        node.select();

        var edition = node.attributes.edition;
        var parent  = node.attributes.parent;

        //items.push({
        //    icon: _ico("blueprint--plus"),
        //    cls: 'x-btn-text-icon',
        //    text    : _('Create attachment'),
        //    scope:this,
        //    handler: this.cmpCreateAttachment
        //});
        //
        //items.push({
        //    icon: _ico("blueprint--pencil"),
        //    cls: 'x-btn-text-icon',
        //    text    : _('Edit attachment'),
        //    scope:this,
        //    handler : this.cmpUpdateAttachment
        //});
        //
        //items.push({
        //    icon: _ico("blueprint--minus"),
        //    cls: 'x-btn-text-icon',
        //    text    : _('Delete attachment'),
        //    scope:this,
        //    handler: this.cmpDeleteAttachment
        //});

        items.push({
            icon: _ico("blue-folder--minus"),
            cls: 'x-btn-text-icon',
            text    : _('Unarchive'),
            scope: grid,
            handler: function() {
                grid.cmpUnarchive(id);
            }
        });

        items.push("-");

        items.push({
            icon: _ico("table"),
            cls: 'x-btn-text-icon',
            text    : _('View plan'),
            handler : function() {
                Inprint.ObjectResolver.resolve({ aid:'fascicle-plan', oid: node.id, text: node.text });
            }
        });

        //items.push({
        //    icon: _ico("clock"),
        //    cls: 'x-btn-text-icon',
        //    text    : _('View composer'),
        //    handler : function() {
        //        Inprint.ObjectResolver.resolve({ aid:'fascicle-planner', oid: node.id, text: node.text });
        //    }
        //});

        items.push('-', {
            icon: _ico("arrow-circle-double"),
            cls: "x-btn-text-icon",
            text: _("Reload"),
            scope: this,
            handler: this.cmpReload
        });

        new Ext.menu.Menu({ items : items }).show(node.ui.getAnchor());

    }, grid);

};
