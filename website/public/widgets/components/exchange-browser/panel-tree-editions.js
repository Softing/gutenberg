Inprint.cmp.ExcahngeBrowser.TreeEditions = Ext.extend(Ext.tree.TreePanel, {

    initComponent: function() {

        this.loader = new Ext.tree.TreeLoader({
            url: _url("/common/tree/editions/"),
            baseParams:{ term: 'editions.documents.work:*' }
            });

        Ext.apply(this, {
            title:_("Editions"),
            autoScroll:true,
            border:false,
            rootVisible: false,
            root: {
                id:'00000000-0000-0000-0000-000000000000',
                nodeType: 'async',
                expanded: true,
                draggable: false,
                icon: _ico("book"),
                text: _("Editions")
            }
        });

        Inprint.cmp.ExcahngeBrowser.TreeEditions.superclass.initComponent.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {
            node.attributes.icon = _ico(node.attributes.icon);
        });

    },

    onRender: function() {

        Inprint.cmp.ExcahngeBrowser.TreeEditions.superclass.onRender.apply(this, arguments);

        this.on("beforeload", function() {
            this.body.mask(_("Loading data..."));
        });

        this.on("load", function() {
            this.body.unmask();
        });

    }

});
