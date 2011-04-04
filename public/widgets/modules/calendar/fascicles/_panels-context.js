Inprint.calendar.fascicles.Context = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    grid.on("contextmenu", function(node) {

        var items = [];

        node.select();

        var edition = node.attributes.edition;
        var parent  = node.attributes.parent;
        var fastype = node.attributes.fastype;

        if (fastype == "issue") {
            items.push({
                icon: _ico("folder--plus"),
                cls: 'x-btn-text-icon',
                text    : _('Create attachment'),
                scope:this,
                handler: this.cmpCreateAttachment
            });
        }

        if (fastype == "attachment") {

            items.push({
                icon: _ico("folder--pencil"),
                cls: 'x-btn-text-icon',
                text    : _('Edit attachment'),
                scope:this,
                handler : this.cmpUpdateAttachment
            });

            items.push({
                icon: _ico("folder--minus"),
                cls: 'x-btn-text-icon',
                text    : _('Delete attachment'),
                scope:this,
                handler: this.cmpRemove
            });

            items.push("-", {
                icon: _ico("clock-select"),
                cls: 'x-btn-text-icon',
                text: _("Deadline"),
                scope: this,
                handler: this.cmpDeadline
            });

            items.push("-", {
                icon: _ico("plug-connect"),
                cls: 'x-btn-text-icon',
                text    : _('Enable'),
                scope: this,
                handler : this.cmpEnable
            }, {
                icon: _ico("plug-disconnect"),
                cls: 'x-btn-text-icon',
                text    : _('Disable'),
                scope: this,
                handler : this.cmpDisable
            });
        }

        items.push("-", {
            icon: _ico("table"),
            cls: 'x-btn-text-icon',
            text    : _('View plan'),
            handler : function() {
                Inprint.ObjectResolver.resolve({ aid:'fascicle-plan', oid: node.id, text: node.text });
            }
        });

        items.push({
            icon: _ico("clock"),
            cls: 'x-btn-text-icon',
            text    : _('View composer'),
            handler : function() {
                Inprint.ObjectResolver.resolve({ aid:'fascicle-planner', oid: node.id, text: node.text });
            }
        });

        items.push('-', {
            text: _("Format"),
            icon: _ico("eraser"),
            cls: 'x-btn-text-icon',
            scope: this,
            handler: this.cmpFormat
        });

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
