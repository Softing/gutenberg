Inprint.plugins.rss.profile.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = new Ext.data.JsonStore({
            autoLoad:false,
            root: "data",
            idProperty: "name",
            url: _url('/plugin/rss/files/list/'),
            fields: [ "preview", "extension", "isdraft", "isapproved", "name", "description", "size", "created", "digest", "updated" ]
        });

        this.columns = [
            {
                id:"preview",
                width: 100,
                dataIndex: "preview",
                sortable: false,
                renderer: function(v) {
                    return '<img src="/files/preview'+ v +'/" style="border:1px solid silver;"/>';
                }
            },
            { id:'name', header:'File',dataIndex:'name', width:250},
            { id: 'description', header:'Description',dataIndex:'description', width:150},
            { id: 'size', header:'Size',dataIndex:'size', width:100, renderer:Ext.util.Format.fileSize},
            { id: 'approved', header:'Approved',dataIndex:'isapproved', width:60},
            { id: 'created', header:'Created',dataIndex:'created', width:120 },
            { id: 'updated', header:'Updated',dataIndex:'updated', width:120 }
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
                icon: _ico("minus-button"),
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

    cmpDelete: function() {
        Ext.MessageBox.confirm(
            _("Irreversible removal"),
            _("You can't cancel this action!"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: _url("/plugin/rss/files/delete/"),
                        scope:this,
                        success: this.cmpReload,
                        params: { document: this.getStore().baseParams.document, file: this.getValues("name") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    },

    cmpPublish: function() {
        Ext.Ajax.request({
            url: _url("/plugin/rss/files/publish/"),
            scope:this,
            success: this.cmpReload,
            params: { document: this.getStore().baseParams.document, file: this.getValues("name") }
        });
    },

    cmpUnpublish: function() {
        Ext.Ajax.request({
            url: _url("/plugin/rss/files/unpublish/"),
            scope:this,
            success: this.cmpReload,
            params: { document: this.getStore().baseParams.document, file: this.getValues("name") }
        });
    }

});
