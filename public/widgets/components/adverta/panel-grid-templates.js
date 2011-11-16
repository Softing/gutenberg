Inprint.cmp.adverta.GridTemplates = Ext.extend(Ext.ux.tree.TreeGrid, {

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
                fascicle: this.fascicle
            }
        });

        Ext.apply(this, {

            flex:2,
            margins: "0 3 0 3",

            height:200,
            layout:"fit",
            region: "south",
            title: _("Templates"),

            enableSort : false,
            enableDrag: true,
            ddGroup: 'TreeDD',

            singleExpand: true,
            hideHeaders: true

        });

        Inprint.cmp.adverta.GridTemplates.superclass.initComponent.apply(this, arguments);

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
        Inprint.cmp.adverta.GridTemplates.superclass.onRender.apply(this, arguments);
    },

    cmpGetSelectedNode: function() {
        return this.getSelectionModel().getSelectedNode();
    },

    cmpReload: function() {
        this.getRootNode().reload();
    }

});

//Inprint.cmp.adverta.GridTemplates = Ext.extend(Ext.grid.GridPanel, {
//
//    initComponent: function() {
//
//        this.urls = {
//            "list": "/fascicle/composer/templates/"
//        };
//
//        var selection = this.parent.selection;
//        var selLength = this.parent.selLength;
//
//        var pages = [];
//        for (var c = 1; c < selection.length+1; c++) {
//            var array = selection[c-1].split("::");
//            pages.push(array[0]);
//        }
//
//        this.store = Inprint.factory.Store.json(this.urls.list, {
//            baseParams: {
//                fascicle:this.fascicle,
//                page: pages
//            }
//        });
//
//        this.selectionModel = new Ext.grid.CheckboxSelectionModel();
//
//        this.columns = [
//            this.selectionModel,
//            {
//                id:"place_title",
//                header: _("Place"),
//                width: 100,
//                sortable: true,
//                dataIndex: "place_title"
//            },
//            {
//                id:"title",
//                header: _("Title"),
//                width: 100,
//                sortable: true,
//                dataIndex: "title"
//            }
//        ];
//
//        Ext.apply(this, {
//
//            title: _("Templates"),
//
//            enableDrag: true,
//            ddGroup: 'TreeDD',
//
//            height:200,
//            layout:"fit",
//            region: "south",
//
//            stripeRows: true,
//            columnLines: true,
//            sm: this.selectionModel
//        });
//
//        Inprint.cmp.adverta.GridTemplates.superclass.initComponent.apply(this, arguments);
//    },
//
//    onRender: function() {
//        Inprint.cmp.adverta.GridTemplates.superclass.onRender.apply(this, arguments);
//        this.getStore().load();
//    }
//});
