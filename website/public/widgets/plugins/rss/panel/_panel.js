Inprint.plugins.rss.Profile = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.initialized = false;

        this.urls = {
            "read":   _url("/plugin/rss/read/")
        };

        this.panels = {
            "form": new Inprint.plugins.rss.profile.Form({
                parent: this
            }),
            "grid": new Inprint.plugins.rss.profile.Grid({
                parent: this
            })
        };

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
            this.panels.form,
            this.panels.grid
        ];

        Ext.apply(this, {
            border:false
        });

        // Call parent (required)
        Inprint.plugins.rss.Profile.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.plugins.rss.Profile.superclass.onRender.apply(this, arguments);

        this.grid = this.panels.grid;
        this.form = this.panels.form.getForm();

        this.panels.form.on("actioncomplete", function (form, action) {
            if (action.type == "submit") {
                this.btnUpload.enable();
                this.grid.getStore().reload();
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
        this.getEl().mask(_("Loading data...") + "...");

        this.form.load({
            url: this.urls.read,
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
        if (access && access.manage === true) {
            this.btnSave.enable();
            if (access.upload === true) {
                this.btnUpload.enable();
            }
            this.getEl().unmask();
        } else {
            this.getEl().mask(_("Access denide"));
        }
    },

    cmpSave: function() {
        this.getEl().mask(_("Saving")+"...");
        this.form.submit({
            submitEmptyText: false
        });
        this.getEl().unmask();
    },

    cmpUpload: function() {

        var Uploader = new Inprint.cmp.Uploader({
            config: {
                document: this.oid,
                uploadUrl: _url("/plugin/rss/files/upload/")
            }
        });

        Uploader.on("fileUploaded", function() {
            Uploader.hide();
            this.cmpReload();
        }, this);

        Uploader.show();

    }

});
