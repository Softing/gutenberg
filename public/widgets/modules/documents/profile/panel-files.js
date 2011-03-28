Inprint.documents.Profile.Files = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.access = {};
        this.record = {};

        this.title = _("Files");

        this.config = {
            document: this.oid
        };

        this.urls = {
            "create":       _url("/documents/files/create/"),
            "read":         _url("/documents/files/read/"),
            "update":       _url("/documents/files/update/"),
            "delete":       _url("/documents/files/delete/"),
            "rename":       _url("/documents/files/rename/"),
            "publish":      _url("/documents/files/publish/"),
            "unpublish":    _url("/documents/files/unpublish/"),
            "description":  _url("/documents/files/description/")
        };

        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.store = new Ext.data.JsonStore({
            root: "data",
            autoLoad:false,
            url: _url("/documents/files/list/"),
            baseParams: { document: this.config.document },
            fields: [ "id", "document", "name", "description", "mime", "extension", "published",  "size", "length", "created", "updated" ]
        });

        // Column model
        this.columns = [
            this.selectionModel,
            {
                id:"published",
                width: 32,
                dataIndex: "published",
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
                dataIndex: "id",
                sortable: false,
                scope: this,
                renderer: function(v, p, record) {

                    if(record.get("name").match(/^.+\.(jpg|jpeg|png|gif|tiff|png)$/i)) {
                        return  String.format(
                            "<a target=\"_blank\" href=\"/files/preview/{0}\"><img src=\"/files/preview/{0}x80\" style=\"border:1px solid silver;\"/></a>",
                        v);
                    }

                    if(record.get("name").match(/^.+\.(rtf|txt|doc|docx|odt)$/i)) {
                        var file     = record.get("id");
                        var filename = record.get("name");
                        var document = record.get("document");
                        return String.format(
                            "<a href=\"/?aid=document-editor&oid={0}&pid={1}&text={2}\" "+
                                "onClick=\"Inprint.ObjectResolver.resolve({'aid':'document-editor','oid':'{0}','pid':'{1}','description':'{2}'});return false;\">"+
                                "<img src=\"/files/preview/{3}x80\" style=\"border:1px solid silver;\"/></a></a>",
                            file, document, escape(filename), v
                        );
                    }

                    return String.format("<img src=\"/files/preview/{0}x80\" style=\"border:1px solid silver;\"/></a>", v);
                }
            },
            { id:'name', header: _("File"),dataIndex:'name', width:250},
            { id: 'description', header: _("Description"),dataIndex:'description', width:150},
            { id: 'size', header: _("Size"), dataIndex:'size', width:100, renderer:Ext.util.Format.fileSize},
            { id: 'size', header: _("Length"), dataIndex:'length', width:100},
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
                icon: _ico("arrow-transition-270"),
                cls: "x-btn-text-icon",
                text: _("Upload files"),
                disabled:true,
                ref: "../btnUpload",
                scope:this,
                handler: this.cmpUpload
            },
            "->",
            {
                icon: _ico("arrow-transition-090"),
                cls: "x-btn-text-icon",
                text: _("Get archive"),
                scope:this,
                handler: function() {
                    window.location = "/files/download/?rnd="+ Math.random() +"&document="+ this.oid;
                }
            },
            {
                icon: _ico("documents-stack"),
                cls: "x-btn-text-icon",
                text: _("Documents"),
                scope:this,
                handler: function() {
                    window.location = "/files/download/?rnd="+ Math.random() +"&filter=documents&document="+ this.oid;
                }
            },
            {
                icon: _ico("pictures-stack"),
                cls: "x-btn-text-icon",
                text: _("Images"),
                scope:this,
                handler: function() {
                    window.location = "/files/download/?rnd="+ Math.random() +"&filter=images&document="+ this.oid;
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

        this.on("rowcontextmenu", function(thisGrid, rowIndex, evtObj) {

            evtObj.stopEvent();

            var rowCtxMenuItems = [];

            var record = thisGrid.getStore().getAt(rowIndex);
            var selCount = thisGrid.getSelectionModel().getCount();

            if ( selCount > 0 ) {

                if ( selCount == 1 ) {
                    if(record.get("name").match(/^.+\.(doc|docx|odt|rtf|txt)$/i)) {

                        var btnIcon = (this.access["fedit"]  === true) ? _ico("pencil") : _ico("pencil");
                        var btnText = (this.access["fedit"]  === true) ? _("Edit text") : _("View text");

                        rowCtxMenuItems.push({
                            scope:this,
                            icon: btnIcon,
                            text: btnText,
                            cls: "x-btn-text-icon",
                            handler : function() {
                                Inprint.ObjectResolver.resolve({
                                    aid: "document-editor",
                                    oid: record.get("id"),
                                    pid: record.get("document"),
                                    description: escape(record.get("filename"))
                                });
                            }
                        });

                    }
                }

                rowCtxMenuItems.push({
                    icon: _ico("arrow-transition-270"),
                    cls: "x-btn-text-icon",
                    text: _("Download file"),
                    scope:this,
                    handler : function() {
                        var items = [];
                        Ext.each(this.getSelectionModel().getSelections(), function(record) {
                            items.push("id="+ record.get("id"));
                        });
                        window.location = "/files/download/?" + items.join("&");
                    }
                });


                if (this.access["fedit"]  === true) {

                    rowCtxMenuItems.push("-");

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

                    if ( selCount == 1 ) {

                        rowCtxMenuItems.push("-");

                        //rowCtxMenuItems.push({
                        //    icon: _ico("edit-drop-cap"),
                        //    cls: "x-btn-text-icon",
                        //    text: _("Rename file"),
                        //    scope:this,
                        //    handler : this.cmpRenameFile
                        //});

                        rowCtxMenuItems.push({
                            icon: _ico("edit-column"),
                            cls: "x-btn-text-icon",
                            text: _("Change description"),
                            scope:this,
                            handler : this.cmpChangeDescription
                        });

                    }

                }

                if (this.access["fdelete"]  === true) {
                    rowCtxMenuItems.push("-");
                    rowCtxMenuItems.push({
                        icon: _ico("document-shred"),
                        cls: "x-btn-text-icon",
                        text: _("Delete file"),
                        scope:this,
                        handler : this.cmpDelete
                    });
                }

                rowCtxMenuItems.push("-");

            }

            rowCtxMenuItems.push({
                icon: _ico("arrow-circle-double"),
                cls: "x-btn-text-icon",
                text: _("Reload"),
                scope:this,
                handler : this.cmpReload
            });

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
        if (access["fadd"]     === true) {
            this.btnCreate.enable();
            this.btnUpload.enable();
        }
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
                this.cmpReload();
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
            url: this.urls.publish,
            scope:this,
            success: this.cmpReload,
            params: { document: this.config.document, file: this.getValues("id") }
        });
    },

    cmpUnpublish: function() {
        var document = this.getStore().baseParams.document;
        var file = this.getValues("id");
        Ext.Ajax.request({
            url: this.urls.unpublish,
            scope:this,
            success: this.cmpReload,
            params: { document: this.config.document, file: this.getValues("id") }
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
                        url: this.urls.rename,
                        success: this.cmpReload,
                        scope:this,
                        params: { document: this.config.document, file: this.getValues("id"), filename: text }
                    });
                }
            }, this);
    },

    cmpChangeDescription: function() {

        var record = this.getSelectionModel().getSelected();

        var box = Ext.MessageBox.show({
            width:300,
            scope:this,
            multiline: true,
            buttons: Ext.MessageBox.OKCANCEL,
            title: _("Modification of the file description"),
            msg: _("Enter a new description for file"),
            fn: function(btn, text) {
                if (btn == "ok") {
                    Ext.Ajax.request({
                        url: this.urls.description,
                        scope:this,
                        success: this.cmpReload,
                        params: { document: this.config.document, file: this.getValues("id"), description: text }
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
                        params: { document: this.config.document, file: this.getValues("id") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }

});
