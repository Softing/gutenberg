Inprint.cmp.PrincipalsBrowser.Tree = Ext.extend(Ext.tree.TreePanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            "tree":    _url("/catalog/organization/tree/")
        };

        Ext.apply(this, {
            autoScroll:true,
            dataUrl: this.urls.tree,
            border:false,
            rootVisible: false,
            root: {
                id:'root-node',
                nodeType: 'async',
                expanded: true,
                draggable: false,
                icon: _ico("node"),
                text: _("Root node")
            }
        });

        Inprint.cmp.PrincipalsBrowser.Tree.superclass.initComponent.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {

            if (node.attributes.icon == undefined) {
                node.attributes.icon = 'folder-open';
            }

            node.attributes.icon = _ico(node.attributes.icon);

            if (node.attributes.color) {
                node.text = "<span style=\"color:#"+ node.attributes.color +"\">" + node.attributes.text + "</span>";
            }

        });

    },

    onRender: function() {

        Inprint.cmp.PrincipalsBrowser.Tree.superclass.onRender.apply(this, arguments);

        this.on("beforeload", function() {
            this.body.mask(_("Please wait..."));
        });

        this.on("load", function() {
            this.body.unmask();
        });

        this.on("afterrender", function() {

            this.getRootNode().expand();
            this.getRootNode().on("expand", function(node) {
                node.firstChild.expand();
                node.firstChild.select();
            });

            this.getLoader().on("beforeload", function() { this.body.mask(_("Loading")); }, this);
            this.getLoader().on("load", function() { this.body.unmask(); }, this);

        }, this);

    }

});
