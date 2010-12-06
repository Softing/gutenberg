Inprint.cmp.memberRulesForm.Editions.Tree = Ext.extend(Ext.tree.TreePanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            "tree":    _url("/catalog/editions/tree/")
        };

        Ext.apply(this, {
            title:_("Editions1"),
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

        Inprint.cmp.memberRulesForm.Editions.Tree.superclass.initComponent.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {
            node.attributes.icon = _ico(node.attributes.icon);
        });
        
    },

    onRender: function() {
        Inprint.cmp.memberRulesForm.Editions.Tree.superclass.onRender.apply(this, arguments);

        this.getLoader().on("load", function() { this.body.unmask(); }, this);
        this.getLoader().on("beforeload", function(treeLoader, node) {
            this.body.mask(_("Loading"));
            treeLoader.baseParams.show_briefcase = true;
        }, this);
        
        this.getRootNode().expand();
    }

});
