Inprint.advertising.downloads.Files = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.store = new Ext.data.JsonStore({
            root: "data",
            url: _source("requests.files.list"),
            fields: [
                "id", "document", "name", "description", "mime", "extension",
                "published", "size", "length",
                { name: "created", type: "date", dateFormat: "c" },
                { name: "updated", type: "date", dateFormat: "c" }
            ]
        });

        // Column model
        var  columns  = Inprint.grid.columns.Files();
        this.colModel = new Ext.grid.ColumnModel({
            defaults: {
                sortable: true,
                menuDisabled:true
            },
            columns: [
                this.selectionModel,
                columns.published,
                columns.preview,
                columns.name,
                columns.created,
                columns.updated,
            ]
        });

        this.tbar = [
            {
                scope:this,
                disabled:true,
                ref: "../btnUpload",
                handler: this.cmpUpload,
                cls: "x-btn-text-icon",
                text: _("Upload files"),
                icon: _ico("arrow-transition-270")
            }
        ];

        Ext.apply(this, {
            border: false,
            disabled: true,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel
        });

        // Call parent (required)
        Inprint.advertising.downloads.Files.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.advertising.downloads.Files.superclass.onRender.apply(this, arguments);

        this.on("rowcontextmenu", function(thisGrid, rowIndex, evtObj) {

            evtObj.stopEvent();

            var rowCtxMenuItems = [];

            var record = thisGrid.getStore().getAt(rowIndex);
            var selCount = thisGrid.getSelectionModel().getCount();

            thisGrid.rowCtxMenu = new Ext.menu.Menu({
                items : rowCtxMenuItems
            });

            thisGrid.rowCtxMenu.showAt(evtObj.getXY());

        }, this);

    },

    setPkey: function(id) {
        this.pkey = id;
    },

    cmpUpload: function() {

        var Uploader = new Inprint.cmp.Uploader({
            config: {
                pkey: this.pkey,
                uploadUrl: _source("requests.files.upload")
            }
        });

        Uploader.on("fileUploaded", function() {
            Uploader.hide();
            this.cmpReload();
        }, this);

        Uploader.show();
    }

});
