Inprint.documents.profile.Rss = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.access = {};
        this.record = {};

        this.title = _("Rss");
        this.initialized = false;

        this.urls = {
            "read":   _url("/documents/rss/read/"),
            "update": _url("/documents/rss/update/")
        }

        this.children = {
            "form": new Inprint.documents.profile.rss.Form({
                parent: this,
                oid: this.oid
            }),
            "grid": new Inprint.documents.profile.rss.Grid({
                parent: this,
                oid: this.oid
            })
        }

        this.tbar = [
            {
                icon: _ico("disk-black"),
                cls: "x-btn-text-icon",
                text: _("Save"),
                disabled:true,
                ref: "../btnSave",
                scope:this,
                handler: this.cmpSave
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

            "->",
            {
                icon: _ico("arrow-circle-double"),
                cls: "x-btn-text-icon",
                text: _("Reload"),
                scope:this,
                handler: this.cmpFill
            }
        ];

        this.layout = 'hbox';
        this.layoutConfig = {
            align : 'stretch',
            pack  : 'start'
        };

        this.items = [
            this.children["form"],
            this.children["grid"]
        ];

        Ext.apply(this, {
            border:false
        });

        // Call parent (required)
        Inprint.documents.profile.Rss.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.documents.profile.Rss.superclass.onRender.apply(this, arguments);
        this.form = this.children["form"].getForm();
        this.form.url = this.urls["update"];
        this.on("activate", function() {
            this.cmpInitialize();
        }, this);
    },

    cmpInitialize: function() {
        if (this.initialized == true) {
            return;
        }
        this.cmpFill();
    },

    cmpFill: function() {
        this.form.load({
            url: this.urls["read"],
            scope:this,
            params: {
                document: this.oid
            },
            success: function(form, action) {
                this.initialized = true;
                this.record = action.result.data;
            }
        });
    },

    cmpAccess: function(access) {
        this.access = access;
        _disable(this.btnSave);
        if (access["documents.update"] == true) this.btnSave.enable();
    },

    cmpSave: function() {
        this.form.submit();
    },

    cmpUpload: function() {

        var cookies = document.cookie.split(";");
        var Session;

        Ext.each(cookies, function(cookie) {
            var nvp = cookie.split("=");
            if (nvp[0].trim() == 'sid')
            {
                Session = nvp[1];
            }
        });

        var UploadPanel = {
            xtype:'awesomeuploader',
            border:false,
            gridWidth:470,
            gridHeight:120,
            height:180,
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
                        this.cmpReload();
                    }
                }
            }
        }

        var Uploader = new Ext.Window({
            title: _('Download files'),
            modal:true,
            layout:"fit",
            width: 500,
            height: 200,
            bodyBorder:false,
            border:false,
            items: UploadPanel
        });

        Uploader.show();

    }

});
