Inprint.plugins.rss.Profile = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.initialized = false;

        this.urls = {
            "read":   _url("/plugin/rss/read/")
        }

        this.children = {
            "form": new Inprint.plugins.rss.profile.Form({
                parent: this
            }),
            "grid": new Inprint.plugins.rss.profile.Grid({
                parent: this
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
                handler: this.cmpReload
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
        Inprint.plugins.rss.Profile.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.plugins.rss.Profile.superclass.onRender.apply(this, arguments);

        this.grid = this.children["grid"];
        this.form = this.children["form"].getForm();

        this.children["form"].on("actioncomplete", function (form, action) {
            if (action.type == "submit") {
                this.btnUpload.enable();
            }
        }, this);

    },

    cmpReload: function(id) {
        this.grid.getStore().reload();
    },

    cmpFill: function(id) {

        if (id) {
            this.oid = id;
        }

        this.form.reset();
        this.form.baseParams = {
            document: this.oid
        };

        this.cmpAccess();
        this.getEl().mask(_("Loading") + "...");

        this.form.load({
            url: this.urls["read"],
            scope:this,
            params: {
                document: this.oid
            },
            success: function(form, action) {
                this.initialized = true;
                this.cmpAccess(action.result.data.access);
            }
        });

        this.grid.getStore().baseParams = { document: this.oid };
        this.grid.getStore().reload();

    },

    cmpAccess: function(access) {
        _disable(this.btnSave, this.btnUpload);

        if (access && access["rss"] == true) {
            this.btnSave.enable();
        }

        if (access && access["rss"] == true && access["upload"] == true) {
            this.btnUpload.enable();
        }

        if (access && access["rss"] == true) {
            this.getEl().unmask();
        } else {
            this.getEl().mask(_("Access denide"));
        }
    },

    cmpSave: function() {
        this.getEl().mask(_("Saving")+"...");
        this.form.submit();
        this.getEl().unmask();
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
                document: this.oid
            },
            xhrUploadUrl: _url("/plugin/rss/files/upload/"),
            flashUploadUrl: _url("/plugin/rss/files/upload/"),
            standardUploadUrl: _url("/plugin/rss/files/upload/"),
            awesomeUploaderRoot: _url("/plugins/uploader/"),
            listeners:{
                scope:this,
                fileupload:function(uploader, success, result){
                    if(success){
                        alert("success");
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
