Inprint.documents.Profile.Files = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.access = {};
        this.record = {};

        this.title = _("Files");

        this.config = {
            document: this.oid
        }

        this.urls = {
            "create":       _url("/documents/files/create/"),
            "read":         _url("/documents/files/read/"),
            "update":       _url("/documents/files/update/"),
            "delete":       _url("/documents/files/delete/"),
            "rename":       _url("/documents/files/rename/"),
            "publish":      _url("/documents/files/publish/"),
            "unpublish":    _url("/documents/files/unpublish/"),
            "description":  _url("/documents/files/description/")
        }

        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.store = new Ext.data.JsonStore({
            root: "data",
            autoLoad:true,
            url: _url("/documents/files/list/"),
            baseParams: { document: this.config.document },
            fields: [ "name", "description", "cache", "preview", "isdraft", "isapproved",  "size", "created", "updated" ]
        });

        // Column model
        this.columns = [
            this.selectionModel,
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

        this.tbar = [
            {
                icon: _ico("document--plus"),
                cls: "x-btn-text-icon",
                text: _("Create"),
                disabled:true,
                ref: "../btnCreate",
                scope:this,
                handler: this.cmpCreate
            },
            "-",
            {
                icon: _ico("document-globe"),
                cls: "x-btn-text-icon",
                text: _("Upload multiple"),
                disabled:true,
                ref: "../btnUpload",
                scope:this,
                handler: this.cmpUpload
            },

            //{
            //    xtype: "fileuploadfield",
            //    buttonOnly: true,
            //    buttonText: _("Upload quickly"),
            //    buttonCfg: {
            //        icon: _ico("document-globe"),
            //        cls: "x-btn-text-icon"
            //    },
            //    listeners: {
            //        'fileselected': function(fb, v){
            //        }
            //    }
            //},

            "->",
            {
                icon: _ico("arrow-270-medium"),
                cls: "x-btn-text-icon",
                text: _("Download zip"),
                scope:this,
                handler: function() {
                    window.location = "/documents/"+ this.oid +"/zip/all/?rnd="+ Math.random();
                }
            },
            {
                icon: _ico("arrow-270-medium"),
                cls: "x-btn-text-icon",
                text: _("Download documents"),
                scope:this,
                handler: function() {
                    window.location = "/documents/"+ this.oid +"/zip/txt/?rnd="+ Math.random();
                }
            },
            {
                icon: _ico("arrow-270-medium"),
                cls: "x-btn-text-icon",
                text: _("Download images"),
                scope:this,
                handler: function() {
                    window.location = "/documents/"+ this.oid +"/zip/img/?rnd="+ Math.random();
                }
            }
        ];

        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "description"
        });

        // Call parent (required)
        Inprint.documents.Profile.Files.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {

        Inprint.documents.Profile.Files.superclass.onRender.apply(this, arguments);

        this.on("rowdblclick", function(thisGrid, rowIndex, evtObj) {

            evtObj.stopEvent();

            var record = thisGrid.getStore().getAt(rowIndex);

            if(record.get("name").match(/^.+\.(doc?x|odt|rtf|txt)$/i)) {
                Inprint.ObjectResolver.resolve({
                    aid: "document-editor",
                    oid:  record.get("cache"),
                    text: record.get("filename"),
                    description: _("Text editing")
                });
            }

        }, this);

        this.on("rowcontextmenu", function(thisGrid, rowIndex, evtObj) {

            evtObj.stopEvent();

            var record = thisGrid.getStore().getAt(rowIndex);

            var rowCtxMenuItems = [];

            if(record.get("name").match(/^.+\.(doc?x|odt|rtf|txt)$/i)) {
                rowCtxMenuItems.push({
                    icon: _ico("pencil"),
                    cls: "x-btn-text-icon",
                    text: _("Edit Text"),
                    scope:this,
                    handler : function() {
                        Inprint.ObjectResolver.resolve({
                            aid: "document-editor",
                            oid:  record.get("cache"),
                            text: record.get("filename"),
                            description: _("Text editing")
                        });
                    }
                });
                rowCtxMenuItems.push("-");
            }

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

            if (this.access["files.delete"]  == true) {
                rowCtxMenuItems.push("-");
                rowCtxMenuItems.push({
                    icon: _ico("document-shred"),
                    cls: "x-btn-text-icon",
                    text: _("Delete file"),
                    scope:this,
                    handler : this.cmpDelete
                });
            }

            thisGrid.rowCtxMenu = new Ext.menu.Menu({
                items : rowCtxMenuItems
            });

            thisGrid.rowCtxMenu.showAt(evtObj.getXY());

        }, this);

    },

    cmpFill: function(record) {
        if (record){
            this.record = record;
            if (record.access){
                this.cmpAccess(record.access);
            }
        }
    },

    cmpAccess: function(access) {
        this.access = access;
        _disable(this.btnCreate, this.btnUpload, this.btnDelete);
        if (access["files.add"]     == true) this.btnCreate.enable();
        if (access["files.add"]     == true) this.btnUpload.enable();
        //if (access["files.delete"]  == true) this.btnDelete.enable();
    },

    cmpCreate: function() {

        var form = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            border:false,
            labelWidth: 75,
            url: _url("/documents/files/create/"),
            bodyStyle: "padding:5px 5px",
            defaults: {
                anchor: "100%",
                allowBlank:false,
                hideLabel: true
            },
            items: [
                {
                    xtype: "hidden",
                    name: "document",
                    value: this.config.document
                },
                _FLD_FILENAME,
                _FLD_DESCRIPTION
            ],
            keys: [ _KEY_ENTER_SUBMIT ],
            buttons: [ _BTN_SAVE, _BTN_CLOSE ]
        });

        var win = new Ext.Window({
            title: _("Create a new file" + " [RTF]"),
            layout: "fit",
            closeAction: "hide",
            width:400, height:180,
            items: form
        });

        form.on("actioncomplete", function (form, action) {
            if (action.type == "submit") {
                win.hide();
                this.getStore().load();
            }
        }, this);

        win.show();
    },

    cmpUpdate: function() {
        var Uploader = new Inprint.cmp.Uploader({
            config: {
                document: this.config.document,
                uploadUrl: _url("/documents/files/upload/")
            }
        });

        Uploader.on("fileUploaded", function() {
            Uploader.hide();
            this.cmpReload();
        }, this);

        Uploader.show();
    },

    cmpUpload: function() {
        var Uploader = new Inprint.cmp.Uploader({
            config: {
                document: this.config.document,
                uploadUrl: _url("/documents/files/upload/")
            }
        });

        Uploader.on("fileUploaded", function() {
            Uploader.hide();
            this.cmpReload();
        }, this);

        Uploader.show();
    },

    // Publish and unpublish file
    cmpPublish: function() {
        Ext.Ajax.request({
            url: this.urls["publish"],
            scope:this,
            success: this.cmpReload,
            params: { document: this.config.document, file: this.getValues("cache") }
        });
    },
    cmpUnpublish: function() {
        var document = this.getStore().baseParams.document;
        var file = this.getValues("cache");
        Ext.Ajax.request({
            url: this.urls["unpublish"],
            scope:this,
            success: this.cmpReload,
            params: { document: this.config.document, file: this.getValues("cache") }
        });
    },

    // Rename file
    cmpRenameFile: function() {
        Ext.MessageBox.prompt(
            _("Renaming a file"),
            _("Enter a new filename"),
            function(btn, text) {
                if (btn == "ok") {
                    Ext.Ajax.request({
                        url: this.urls["rename"],
                        success: this.cmpReload,
                        scope:this,
                        params: { document: this.config.document, file: this.getValues("cache"), filename: text }
                    });
                }
            }, this);
    },

    cmpChangeDescription: function() {
        Ext.MessageBox.show({
            width:300,
            scope:this,
            multiline: true,
            buttons: Ext.MessageBox.OKCANCEL,
            title: _("Modification of the file description"),
            msg: _("Enter a new description for file"),
            fn: function(btn, text) {
                if (btn == "ok") {
                    Ext.Ajax.request({
                        url: this.urls["description"],
                        scope:this,
                        success: this.cmpReload,
                        params: { document: this.config.document, file: this.getValues("cache"), description: text }
                    });
                }
            }
        });
    },

    cmpDelete: function() {
        Ext.MessageBox.confirm(
            _("Irrevocable action!"),
            _("Remove selected files?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls["delete"],
                        scope:this,
                        success: this.cmpReload,
                        params: { document: this.config.document, file: this.getValues("cache") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }

});
