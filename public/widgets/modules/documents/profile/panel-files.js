Inprint.documents.Profile.Files = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.record = {};
        this.urls = {
            "list":        "/documents/files/list/",
            "create": _url("/documents/files/create/"),
            "read":   _url("/documents/files/read/"),
            "update": _url("/documents/files/update/"),
            "delete": _url("/documents/files/delete/")
        }

        this.store = Inprint.factory.Store.json(this.urls["list"], {
            autoLoad:true
        });
        
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

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
            {
                icon: _ico("pencil"),
                cls: "x-btn-text-icon",
                text: _("Edit"),
                disabled:true,
                ref: "../btnUpdate",
                scope:this,
                handler: this.cmpUpdate
            },
            {
                icon: _ico("document-globe"),
                cls: "x-btn-text-icon",
                text: _("Upload"),
                disabled:true,
                ref: "../btnUpload",
                scope:this,
                handler: this.cmpUpload
            },
            {
                icon: _ico("document-shred"),
                cls: "x-btn-text-icon",
                text: _("Delete"),
                disabled:true,
                ref: "../btnDelete",
                scope:this,
                handler: this.cmpDelete
            },
            '->',
            {
                icon: _ico("pencil"),
                cls: "x-btn-text-icon",
                text: _("Editor"),
                //disabled:true,
                ref: "../btnEditor",
                scope:this,
                handler: function() {
                    
                    Inprint.ObjectResolver.resolve({
                        aid: "document-editor",
                        oid: this.oid,
                        text: this.record.title,
                        description: _("Text editing")
                    });
                    
                }
            },
            
        ];

        // Column model
        this.columns = [
            this.selectionModel,
            {
                id:"preview",
                width: 100,
                dataIndex: "preview",
                sortable: false,
                renderer: function(v) {
                    return '<img src="'+ v +'" style="border:1px solid silver;"/>';
                }
            },
            {
                id:"title",
                header: _("File name"),
                width: 200,
                sortable: true,
                dataIndex: "filename"
            },
            {
                id:"description",
                header: _("Description"),
                width: 300,
                sortable: true,
                dataIndex: "description"
            },
            
            {
                id:"size",
                header: _("Size"),
                width: 80,
                sortable: true,
                dataIndex: "size"
            },
            {
                id:"created",
                header: _("Created"),
                width: 100,
                sortable: true,
                dataIndex: "created"
            },
            {
                id:"updated",
                header: _("Updated"),
                width: 100,
                sortable: true,
                dataIndex: "updated"
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

    // Override other inherited methods
    onRender: function() {
        // Call parent (required)
        Inprint.documents.Profile.Files.superclass.onRender.apply(this, arguments);
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
        _disable(this.btnCreate, this.btnUpload, this.btnDelete);
        if (access["files.add"]     == true) this.btnCreate.enable();
        if (access["files.add"]     == true) this.btnUpload.enable();
        if (access["files.delete"]  == true) this.btnDelete.enable();
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
                    value: this.oid
                },
                _FLD_TITLE,
                _FLD_DESCRIPTION
            ],
            keys: [ _KEY_ENTER_SUBMIT ],
            buttons: [ _BTN_SAVE,_BTN_CLOSE ]
        });

        var win = new Ext.Window({
            title: _("Add file"),
            layout: "fit",
            closeAction: "hide",
            width:400, height:200,
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

        var form = new Ext.FormPanel({
            border:false,
            labelWidth: 75,
            url: _url("/documents/files/update/"),
            bodyStyle: "padding:5px 5px",
            defaults: {
                anchor: "100%",
                allowBlank:false
            },
            items: [
                _FLD_HDN_ID,
                _FLD_TITLE,
                _FLD_DESCRIPTION
            ],
            keys: [ _KEY_ENTER_SUBMIT ],
            buttons: [ _BTN_SAVE,_BTN_CLOSE ]
        });

        var win = new Ext.Window({
            title: _("Add file"),
            layout: "fit",
            closeAction: "hide",
            width:400, height:260,
            items: form
        });

        form.on("actioncomplete", function (form, action) {
            if (action.type == "submit")
                win.hide();
            this.getStore().load();
        }, this);

        win.show();
    },
    
    cmpUpload: function() {

        var cookies = document.cookie.split(";");
        var Session;
        Ext.each(cookies, function(cookie)
        {
            var nvp = cookie.split("=");
            if (nvp[0].trim() == 'sid')
            {
                Session = nvp[1];
            }
        });
        
        var AwesomeUploader = new Ext.Window({
            title:'Awesome Uploader in a Window!',
            frame:true,
            width:500,
            height:200,
            items:{
                    xtype:'awesomeuploader',
                    gridHeight:100,
                    height:160,
                    extraPostData: {
                        sid: Session,
                        document: this.parent.document
                    },
                    flashUploadUrl:_url("/documents/files/upload/"),
                    standardUploadUrl:_url("/documents/files/upload/"),
                    xhrUploadUrl:_url("/documents/files/upload/"),
                    awesomeUploaderRoot: "/plugins/uploader/",
                    listeners:{
                            scope:this,
                            fileupload:function(uploader, success, result){
                                    if(success){
                                            Ext.Msg.alert('File Uploaded!','A file has been uploaded!');
                                    }
                            }
                    }
            }
        });
        
        AwesomeUploader.show();
        
        //var panel = new Ext.ux.PluploadPanel({
        //    runtimes: 'flash,gears,silverlight,html5,browserplus,html4',
        //    max_file_size: '20mb',
        //    
        //    //multipart: true,
        //    //multipart_params: {
        //    //    document: this.parent.document
        //    //},
        //    
        //    url: _url("/documents/files/upload/"),
        //    flash_swf_url : '/plupload/js/plupload.flash.swf',
        //    silverlight_xap_url: '/plupload/js/plupload.silverlight.xap',
        //    
        //    addBtnIcn: _ico("plus-button"),
        //    addBtnTxt: _("Add files"),
        //    uploadBtnIcn: _ico("arrow-skip-270"),
        //    uploadBtnTxt: _("Upload"),
        //    cancelBtnIcn: _ico("cross-button"),
        //    cancelBtnTxt: _("Cancel"),
        //    deleteBtnIcn: _ico("minus-button"),
        //    deleteBtnTxt: _("Delete")
        //});
        //
        //win = new Ext.Window({
        //    title: _("Upload"),
        //    layout: "fit",
        //    width:640, height:380,
        //    items: panel
        //});
        //
        //win.show();
        //
        //panel.on("uploadcomplete", function (panel, success, failures) {
        //    if( success.length ) {
        //        alert("uploadcomplete");
        //    }
        //}, this);
        
    },
    
    cmpDelete: function() {
        Ext.MessageBox.confirm(
            _("Warning"),
            _("You really wish to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: _url("/documents/files/delete/"),
                        scope:this,
                        success: this.cmpReload,
                        params: {
                            document: this.parent.document,
                            files: this.getValues("id")
                        }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }
    
});
