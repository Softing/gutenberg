Inprint.calendar.archive.Tree = Ext.extend(Ext.tree.TreePanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            "tree":    _url("/calendar/tree/")
        };

        Ext.apply(this, {
            border:false,
            autoScroll:true,
            dataUrl: this.urls.tree,
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

        Inprint.calendar.archive.Tree.superclass.initComponent.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {
            if (node.attributes.icon === undefined) {
                node.attributes.icon = 'folder-open';
            }
            node.attributes.icon = _ico(node.attributes.icon);
            if (node.attributes.color) {
                node.text = "<span style=\"color:#"+ node.attributes.color +"\">" + node.attributes.text + "</span>";
            }
        });

    },

    onRender: function() {
        Inprint.calendar.archive.Tree.superclass.onRender.apply(this, arguments);
        this.getRootNode().on("expand", function(node) {
            node.firstChild.select();
        });
        this.getLoader().baseParams = { term: "editions.calendar.view:*" };
        this.getLoader().on("beforeload", function() { this.body.mask(_("Loading")); }, this);
        this.getLoader().on("load", function() { this.body.unmask(); }, this);
        this.getRootNode().expand();
    }

});
