Inprint.advert.index.Headlines = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.params = {};
        this.components = {};
        this.urls = {
            "list":      "/advertising/index/headlines/",
            "save": _url("/advertising/index/save/")
        }

        this.store = Inprint.factory.Store.json(this.urls["list"]);
        
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            this.selectionModel,
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
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "description"
        });

        Inprint.advert.index.Headlines.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.advert.index.Headlines.superclass.onRender.apply(this, arguments);
        
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
                        url: this.urls["save"],
                        scope:this,
                        success: this.cmpReload,
                        params: {
                            edition: this.parent.edition,
                            entity: this.getValues("id"),
                            type: "headline"
                        }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }
    
});
