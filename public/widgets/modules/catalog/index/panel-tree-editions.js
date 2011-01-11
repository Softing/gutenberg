Inprint.catalog.indexes.TreeEditions = Ext.extend(Ext.tree.TreePanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            "tree":    _url("/catalog/indexes/editions/")
        };

        Ext.apply(this, {
            title:_("Editions"),
            autoScroll:true,
            dataUrl: this.urls.tree,
            border:false,
            rootVisible: true,
            root: {
                id:'00000000-0000-0000-0000-000000000000',
                nodeType: 'async',
                expanded: true,
                draggable: false,
                icon: _ico("blue-folders"),
                text: _("All editions")
            }
        });

        Inprint.catalog.indexes.TreeEditions.superclass.initComponent.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {
            node.attributes.icon = _ico(node.attributes.icon);
        });

    },

    onRender: function() {

        Inprint.catalog.indexes.TreeEditions.superclass.onRender.apply(this, arguments);

        this.getRootNode().on("expand", function(node) {
            node.firstChild.expand();
            node.select();
        });

        this.getLoader().on("beforeload", function() { this.body.mask(_("Loading")); }, this);
        this.getLoader().on("load", function() { this.body.unmask(); }, this);

    }

});
