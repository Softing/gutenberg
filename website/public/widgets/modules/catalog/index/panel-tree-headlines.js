Inprint.catalog.indexes.TreeHeadlines = Ext.extend(Ext.tree.TreePanel, {

    initComponent: function() {

        this.edition = null;

        this.loader = new Ext.tree.TreeLoader({
            dataUrl: _url("/catalog/headlines/tree/"),
            baseParams: this.baseParams
        });

        this.root = {
            id:'00000000-0000-0000-0000-000000000000',
            nodeType: 'async',
            draggable: false
        };

        Ext.apply(this, {
            title:_("Headlines"),
            border:false,
            disabled:true,
            autoScroll:true,
            rootVisible: false
        });

        Inprint.catalog.indexes.TreeHeadlines.superclass.initComponent.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {
            node.attributes.icon = _ico(node.attributes.icon);
        });

    },

    onRender: function() {
        Inprint.catalog.indexes.TreeHeadlines.superclass.onRender.apply(this, arguments);
        this.getLoader().on("beforeload", function() { this.body.mask(_("Loading")); }, this);
        this.getLoader().on("load", function() { this.body.unmask(); }, this);
    },

    getEdition: function() {
        return this.edition;
    },

    setEdition: function(id) {
        this.edition = id;
    }

});
