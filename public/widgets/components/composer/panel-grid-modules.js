Inprint.cmp.composer.Modules = Ext.extend(Ext.ux.tree.TreeGrid, {

    initComponent: function() {

        this.params = {};
        this.components = {};

        this.urls = {
            "list":        "/fascicle/composer/modules/",
            "create": _url("/fascicle/modules/create/"),
            "delete": _url("/fascicle/modules/delete/")
        }

        //this.store = Inprint.factory.Store.json(this.urls["list"], {
        //    autoLoad:true,
        //    baseParams: {
        //        page: this.parent.selection
        //    }
        //});
        //
        //this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            //this.selectionModel,
            {
                id:"title",
                width: 130,
                header: _("Title"),
                dataIndex: "title"
            },
            {
                id:"place_title",
                width: 100,
                header: _("Place"),
                dataIndex: "place_title"
            },
            {
                id:"amount",
                width: 80,
                header: _("Amount"),
                dataIndex: "amount"
            }
        ];

        this.loader  = new Ext.tree.TreeLoader({
            dataUrl: this.urls["list"],
            baseParams: {
                page: this.parent.selection
            }
        });

        Ext.apply(this, {

            title: _("Modules"),

            enableDragDrop: true,
            ddGroup: 'principals-selector',

            layout:"fit",
            region: "center"

            //stripeRows: true,
            //columnLines: true,
            //sm: this.selectionModel

        });

        Inprint.cmp.composer.Modules.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.composer.Modules.superclass.onRender.apply(this, arguments);
    },

    cmpDelete: function() {
        Ext.MessageBox.confirm(
            _("Warning"),
            _("You really wish to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls["delete"],
                        scope:this,
                        success: function() {
                            this.parent.panels["flash"].cmpInit();
                            this.cmpReload();
                        },
                        params: { id: this.getValues("id") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }

});

//Inprint.cmp.composer.Modules = Ext.extend(Ext.grid.GridPanel, {
//
//    initComponent: function() {
//
//        this.pageId = null;
//        this.pageW  = null;
//        this.pageH  = null;
//
//        this.params = {};
//        this.components = {};
//
//        this.urls = {
//            "list":        "/fascicle/composer/modules/",
//            "create": _url("/fascicle/modules/create/"),
//            "delete": _url("/fascicle/modules/delete/")
//        }
//
//        this.store = Inprint.factory.Store.json(this.urls["list"], {
//            autoLoad:true,
//            baseParams: {
//                page: this.parent.selection
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
//            },
//            {
//                id:"amount",
//                header: _("Amount"),
//                sortable: true,
//                dataIndex: "amount"
//            }
//        ];
//
//        Ext.apply(this, {
//
//            title: _("Modules"),
//
//            enableDragDrop: true,
//            ddGroup: 'principals-selector',
//
//            layout:"fit",
//            region: "center",
//
//            stripeRows: true,
//            columnLines: true,
//            sm: this.selectionModel
//
//        });
//
//        Inprint.cmp.composer.Modules.superclass.initComponent.apply(this, arguments);
//
//    },
//
//    onRender: function() {
//        Inprint.cmp.composer.Modules.superclass.onRender.apply(this, arguments);
//    },
//
//    cmpDelete: function() {
//        Ext.MessageBox.confirm(
//            _("Warning"),
//            _("You really wish to do this?"),
//            function(btn) {
//                if (btn == "yes") {
//                    Ext.Ajax.request({
//                        url: this.urls["delete"],
//                        scope:this,
//                        success: function() {
//                            this.parent.panels["flash"].cmpInit();
//                            this.cmpReload();
//                        },
//                        params: { id: this.getValues("id") }
//                    });
//                }
//            }, this).setIcon(Ext.MessageBox.WARNING);
//    }
//
//});
