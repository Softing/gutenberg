Inprint.cmp.adverta.Templates = Ext.extend(Ext.ux.tree.TreeGrid, {

    initComponent: function() {

        this.params = {};
        this.components = {};

        this.urls = {
            "list": "/fascicle/templates/modules/tree/"
        };

        this.columns = [
            {
                id: "title",
                header: _("Title"),
                width: 280,
                sortable: true,
                dataIndex: "title"
            }
        ];

        this.loader  = new Ext.tree.TreeLoader({
            dataUrl: this.urls.list,
            baseParams: {
                fascicle: this.fascicle
            }
        });

        Ext.apply(this, {

            flex:2,
            margins: "0 3 0 3",

            layout:"fit",
            title: _("Templates"),

            enableSort : false,
            enableDrop: false,

            singleExpand: true,
            hideHeaders: true

        });

        Inprint.cmp.adverta.Templates.superclass.initComponent.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {
            node.attributes.icon = _ico(node.attributes.icon);
        });

        var sm = this.getSelectionModel( );
        sm.on("beforeselect", function(model, node) {
            if (node.attributes.type != "module") {
                node.expand();
                return false;
            }
            return true;
        });

    },

    onRender: function() {
        Inprint.cmp.adverta.Templates.superclass.onRender.apply(this, arguments);
    },

    cmpGetSelectedNode: function() {
        return this.getSelectionModel().getSelectedNode();
    },

    cmpGetValue: function() {

        if (this.getSelectionModel().getSelectedNode()) {
            return this.getSelectionModel().getSelectedNode().attributes.id;
        }

        return false;
    },

    cmpReload: function() {
        this.getRootNode().reload();
    }

});
