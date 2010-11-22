Inprint.documents.Profile.Files = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.record = {};

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

        Ext.apply(this, {
            border: false
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

        var form = new Ext.FormPanel({
            border:false,
            labelWidth: 75,
            url: _url("/documents/files/create/"),
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

        var panel = new Ext.ux.PluploadPanel({
            runtimes: 'flash',
            max_file_size: '10mb',
            url: _url("/documents/files/upload/"),
            flash_swf_url : '/plupload/js/plupload.flash.swf',
            addBtnIcn: _ico("plus-button"),
            addBtnTxt: _("Add files"),
            uploadBtnIcn: _ico("arrow-skip-270"),
            uploadBtnTxt: _("Upload"),
            cancelBtnIcn: _ico("cross-button"),
            cancelBtnTxt: _("Cancel"),
            deleteBtnIcn: _ico("minus-button"),
            deleteBtnTxt: _("Delete")
        });
        
        win = new Ext.Window({
            title: _("Upload"),
            layout: "fit",
            width:640, height:380,
            items: panel
        });
        
        win.show();
        
        panel.on("uploadcomplete", function (panel, success, failures) {
            if( success.length ) {
                alert("uploadcomplete");
            }
        }, this);
        
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
                        params: { id: this.getValues("id") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }
    
});
