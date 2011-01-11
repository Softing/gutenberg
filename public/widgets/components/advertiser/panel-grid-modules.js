Inprint.cmp.adverta.GridModules = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.pageId = null;
        this.pageW  = null;
        this.pageH  = null;

        this.params = {};
        this.components = {};

        this.urls = {
            "list":        "/fascicle/modules/list/",
            "create": _url("/fascicle/modules/create/"),
            "delete": _url("/fascicle/modules/delete/")
        }

        this.store = Inprint.factory.Store.json(this.urls["list"], {
            baseParams: {
                fascicle: this.fascicle,
                page: this.parent.selection
            }
        });

        this.selectionModel = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });

        this.columns = [
            this.selectionModel,
            {
                id:"place_title",
                header: _("Place"),
                width: 80,
                sortable: true,
                dataIndex: "place_title"
            },
            {
                id:"title",
                header: _("Title"),
                width: 120,
                sortable: true,
                dataIndex: "title"
            }
        ];

        Ext.apply(this, {

            title: _("Modules"),

            enableDragDrop: true,
            ddGroup: 'principals-selector',

            layout:"fit",
            region: "center",

            viewConfig: {
                forceFit: true
            },

            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel

        });

        Inprint.cmp.adverta.GridModules.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.adverta.GridModules.superclass.onRender.apply(this, arguments);

        this.getStore().load();
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
