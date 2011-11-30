Inprint.cmp.composer.Templates = Ext.extend(Ext.ux.tree.TreeGrid, {

    initComponent: function() {

        this.params = {};
        this.components = {};

        this.urls = {
            "list": "/fascicle/templates/modules/tree/"
        };

        this.fascicle = this.parent.fascicle;

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
                fascicle: this.fascicle,
                page: this.parent.selection
            }
        });

        Ext.apply(this, {

            flex:2,
            margins: "0 3 0 3",

            height:300,
            layout:"fit",
            region: "south",
            title: _("Templates"),

            enableSort : false,
            enableDrag: true,
            ddGroup: 'TreeDD',

            singleExpand: true,
            hideHeaders: true

        });

        Inprint.cmp.composer.Templates.superclass.initComponent.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {
            node.attributes.icon = _ico(node.attributes.icon);
        });

        this.getLoader().on("load", function (loader, node, responce) {
            node.firstChild.expand();
        });

        this.getSelectionModel().on("beforeselect", function(model, node) {
            if (node.attributes.type != "module") {
                node.expand();
                return false;
            }
            return true;
        });

    },

    onRender: function() {
        Inprint.cmp.composer.Templates.superclass.onRender.apply(this, arguments);
    },

    cmpGetSelectedNode: function() {
        return this.getSelectionModel().getSelectedNode();
    },

    cmpReload: function() {
        this.getRootNode().reload();
    }

});
