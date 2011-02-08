Inprint.plugins.rss.profile.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = new Ext.data.JsonStore({
            autoLoad:false,
            root: "data",
            idProperty: "name",
            url: _url('/plugin/rss/files/list/'),
            fields: [ "name", "description", "cache", "preview", "isdraft", "isapproved",  "size", "created", "updated" ]
        });

        this.columns = [
            {
                id:"approved",
                width: 32,
                dataIndex: "isapproved",
                sortable: false,
                renderer: function(v) {
                    var image = '';
                    if (v==1) { image = '<img src="'+ _ico("light-bulb") +'"/>'; }
                    return image;
                }
            },
            {
                id:"preview",
                header:_("Preview"),
                width: 100,
                dataIndex: "cache",
                sortable: false,
                renderer: function(v) {
                    return '<img src="/files/preview/'+ v +'x80" style="border:1px solid silver;"/>';
                }
            },
            { id:'name', header: _("File"),dataIndex:'name', width:250},
            { id: 'description', header: _("Description"),dataIndex:'description', width:150},
            { id: 'size', header: _("Size"), dataIndex:'size', width:100, renderer:Ext.util.Format.fileSize},
            { id: 'created', header: _("Created"), dataIndex:'created', width:120 },
            { id: 'updated', header: _("Updated") ,dataIndex:'updated', width:120 }
        ];

        Ext.apply(this, {
            flex:1,
            xtype: "grid",
            border:false,
            enableHdMenu:false,
            maskDisabled: true,
            loadMask: false,
            bodyStyle: "padding:5px 5px",
            autoExpandColumn: "description"
        });

        // Call parent (required)
        Inprint.plugins.rss.profile.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {

        Inprint.plugins.rss.profile.Grid.superclass.onRender.apply(this, arguments);

        this.on("rowcontextmenu", function(thisGrid, rowIndex, evtObj) {

            evtObj.stopEvent();

            var rowCtxMenuItems = [];

            rowCtxMenuItems.push({
                icon: _ico("light-bulb"),
                cls: "x-btn-text-icon",
                text: _("Publish"),
                scope:this,
                handler: this.cmpPublish
            });

            rowCtxMenuItems.push({
                icon: _ico("light-bulb-off"),
                cls: "x-btn-text-icon",
                text: _("Unpublish"),
                scope:this,
                handler: this.cmpUnpublish
            });

            rowCtxMenuItems.push("-");

            rowCtxMenuItems.push({
                icon: _ico("edit-drop-cap"),
                cls: "x-btn-text-icon",
                text: _("Rename file"),
                scope:this,
                handler : this.cmpRenameFile
            });
            rowCtxMenuItems.push({
                icon: _ico("edit-column"),
                cls: "x-btn-text-icon",
                text: _("Change description"),
                scope:this,
                handler : this.cmpChangeDescription
            });

            rowCtxMenuItems.push("-");
            rowCtxMenuItems.push({
                icon: _ico("document-shred"),
                cls: "x-btn-text-icon",
                text: _("Delete file"),
                scope:this,
                handler : this.cmpDelete
            });

            thisGrid.rowCtxMenu = new Ext.menu.Menu({
                items : rowCtxMenuItems
            });

            thisGrid.rowCtxMenu.showAt(evtObj.getXY());

        }, this);

    },

    cmpPublish: function() {
        var document = this.getStore().baseParams.document;
        var file = this.getValues("cache");
        Ext.Ajax.request({
            url: _url("/plugin/rss/files/publish/"),
            scope:this,
            success: this.cmpReload,
            params: { document: document, file: file }
        });
    },

    cmpUnpublish: function() {
        var document = this.getStore().baseParams.document;
        var file = this.getValues("cache");
        Ext.Ajax.request({
            url: _url("/plugin/rss/files/unpublish/"),
            scope:this,
            success: this.cmpReload,
            params: { document: document, file: file }
        });
    },

    cmpRenameFile: function() {
        var document = this.getStore().baseParams.document;
        var file = this.getValues("cache");
        Ext.MessageBox.prompt(
            _("Modification of the file"),
            _("Change the file name"),
            function(btn, text) {
                if (btn == "ok") {
                    Ext.Ajax.request({
                        url: _url("/plugin/rss/files/rename/"),
                        scope:this,
                        success: this.cmpReload,
                        params: { document: document, file: file, text: text }
                    });
                }
            }, this);
    },

    cmpChangeDescription: function() {
        var document = this.getStore().baseParams.document;
        var file = this.getValues("cache");
        Ext.MessageBox.show({
            width:300,
            scope:this,
            multiline: true,
            buttons: Ext.MessageBox.OKCANCEL,
            title: _("Modification of the file"),
            msg: _("Change the file description"),
            fn: function(btn, text) {
                if (btn == "ok") {
                    Ext.Ajax.request({
                        url: _url("/plugin/rss/files/description/"),
                        scope:this,
                        success: this.cmpReload,
                        params: { document: document, file: file, text: text }
                    });
                }
            }
        });
    },

    cmpDelete: function() {
        var document = this.getStore().baseParams.document;
        var file = this.getValues("cache");
        Ext.MessageBox.confirm(
            _("Delete the file?"),
            _("This change can not be undone!"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: _url("/plugin/rss/files/delete/"),
                        scope:this,
                        success: this.cmpReload,
                        params: { document: document, file: file }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }

});
