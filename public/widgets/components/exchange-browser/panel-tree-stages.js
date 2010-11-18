Inprint.cmp.ExcahngeBrowser.TreeStages = Ext.extend(Ext.tree.TreePanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            "tree":    _url("/common/transfer/branches/")
        };

        Ext.apply(this, {
            title:_("Stages"),
            autoScroll:true,
            dataUrl: this.urls.tree,
            border:false,
            rootVisible: false,
            root: {
                id:'00000000-0000-0000-0000-000000000000',
                nodeType: 'async',
                draggable: false,
                icon: _ico("book"),
                text: _("Editions")
            }
        });

        Inprint.cmp.ExcahngeBrowser.TreeStages.superclass.initComponent.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {
            node.attributes.icon = _ico(node.attributes.icon);
        });

    },

    onRender: function() {

        Inprint.cmp.ExcahngeBrowser.TreeStages.superclass.onRender.apply(this, arguments);

        this.on("beforeload", function() {
            this.body.mask(_("Please wait..."));
        });

        this.on("load", function() {
            this.body.unmask();
        });

        this.on("afterrender", function() {

            //this.getRootNode().expand();
            //
            //this.getRootNode().on("expand", function(node) {
            //    node.firstChild.expand();
            //    node.firstChild.select();
            //});
            //
            //this.getLoader().on("beforeload", function() { this.body.mask(_("Loading")); }, this);
            //this.getLoader().on("load", function() { this.body.unmask(); }, this);

        }, this);

    }

});
