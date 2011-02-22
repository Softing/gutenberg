Inprint.edition.calendar.TreeArchive = Ext.extend(Ext.tree.TreePanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            "tree":    _url("/calendar/tree/")
        };

        Ext.apply(this, {
            title: _("Archive issues"),
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

        Inprint.edition.calendar.TreeArchive.superclass.initComponent.apply(this, arguments);

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
        Inprint.edition.calendar.TreeArchive.superclass.onRender.apply(this, arguments);
        this.getRootNode().on("expand", function(node) {
            node.firstChild.select();
        });
        this.getLoader().baseParams = { term: "editions.calendar.view" };
        this.getLoader().on("beforeload", function() { this.body.mask(_("Loading")); }, this);
        this.getLoader().on("load", function() { this.body.unmask(); }, this);
        this.getRootNode().expand();
    }

});
