Inprint.advert.index.Modules = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.params = {};
        this.components = {};
        this.urls = {
            "list":      "/advertising/index/modules/",
            "save": _url("/advertising/index/save/")
        };

        this.store = Inprint.factory.Store.json(this.urls.list);

        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            this.selectionModel,
            {
                id:"page_shortcut",
                header: _("Page"),
                width: 150,
                sortable: true,
                dataIndex: "page_title"
            },
            {
                id:"title",
                header: _("Title"),
                width: 150,
                sortable: true,
                dataIndex: "title"
            },
            {
                id:"shortcut",
                header: _("Shortcut"),
                width: 150,
                sortable: true,
                dataIndex: "shortcut"
            },
            {
                id:"description",
                header: _("Description"),
                sortable: true,
                dataIndex: "description"
            },
            {
                id:"amount",
                header: _("Amount"),
                sortable: true,
                dataIndex: "amount"
            },
            {
                id:"area",
                header: _("Area"),
                sortable: true,
                dataIndex: "area"
            },
            {
                id:"x",
                header: _("X"),
                sortable: true,
                dataIndex: "x"
            },
            {
                id:"y",
                header: _("Y"),
                sortable: true,
                dataIndex: "y"
            },
            {
                id:"w",
                header: _("W"),
                sortable: true,
                dataIndex: "w"
            },
            {
                id:"h",
                header: _("H"),
                sortable: true,
                dataIndex: "h"
            }
        ];

        this.tbar = [
            {
                scope:this,
                disabled:true,
                text: _("Save"),
                ref: "../btnSave",
                cls: "x-btn-text-icon",
                icon: _ico("disk-black"),
                handler: this.cmpSave
            }
        ];

        Ext.apply(this, {
            border: false,
            disabled:true,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "description"
        });

        Inprint.advert.index.Modules.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.advert.index.Modules.superclass.onRender.apply(this, arguments);

        this.getStore().on("load", function() {
            var sm = this.getSelectionModel();
            var ds = this.store;
            sm.clearSelections();
            for (i = 0; i < ds.getCount(); i++) {
                var record = ds.getAt(i);
                if (  record.data.selected ) {
                    sm.selectRow(i, true);
                }
            }
        }, this);

    },

    cmpSave: function() {
        Ext.MessageBox.confirm(
            _("Warning"),
            _("You really wish to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls.save,
                        scope:this,
                        success: this.cmpReload,
                        params: {
                            edition: this.parent.edition,
                            place: this.place,
                            entity: this.getValues("id"),
                            type: "module"
                        }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }

});
