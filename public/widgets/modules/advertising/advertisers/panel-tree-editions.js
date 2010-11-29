Inprint.advert.advertisers.Tree = Ext.extend(Ext.tree.TreePanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            "tree":    _url("/advertising/common/editions/")
        };

        Ext.apply(this, {
            title:_("Editions"),
            autoScroll:true,
            dataUrl: this.urls.tree,
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

        Inprint.advert.advertisers.Tree.superclass.initComponent.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {
            node.attributes.icon = _ico(node.attributes.icon);
        });

    },

    onRender: function() {

        Inprint.advert.advertisers.Tree.superclass.onRender.apply(this, arguments);

        //this.getRootNode().expand();
        //
        this.getRootNode().on("expand", function(node) {
            node.firstChild.expand();
            node.firstChild.select();
        });
        
        this.getLoader().on("beforeload", function() { this.body.mask(_("Loading")); }, this);
        this.getLoader().on("load", function() { this.body.unmask(); }, this);

    }

});
