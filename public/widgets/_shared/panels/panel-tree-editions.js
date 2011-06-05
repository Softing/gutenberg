Inprint.panel.tree.Editions = Ext.extend(Ext.tree.TreePanel, {

    initComponent: function() {

        this.loader = new Ext.tree.TreeLoader({
            dataUrl: _source("common.tree.editions"),
            baseParams: this.baseParams
        });

        this.root = {
            id:'00000000-0000-0000-0000-000000000000',
            nodeType: 'async',
            expanded: true,
            draggable: false,
            icon: _ico("book"),
            text: _("Editions")
        };

        Ext.apply(this, {
                title:_("Editions"),
                border:false,
                autoScroll:true,
                rootVisible: false
            });

        Inprint.panel.tree.Editions.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {

        Inprint.panel.tree.Editions.superclass.onRender.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {
            node.attributes.icon = _ico(node.attributes.icon);
        });

        this.getRootNode().on("expand", function(node) {
            if (node.firstChild) {
                node.firstChild.select();
            }
        });

        this.getLoader().on("beforeload", function() { this.body.mask(_("Loading")); }, this);
        this.getLoader().on("load", function() { this.body.unmask(); }, this);

    }

});

Ext.reg('inprint.panel.tree.editions', Inprint.panel.tree.Editions);
