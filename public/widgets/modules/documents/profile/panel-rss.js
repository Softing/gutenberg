Inprint.documents.Profile.Rss = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.access = {};
        this.record = {};

        this.title = _("Rss");
        this.initialized = false;

        this.urls = {
            "read":   _url("/documents/rss/read/"),
            "update": _url("/documents/rss/update/")
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
            "->",
            {
                icon: _ico("arrow-circle-double"),
                cls: "x-btn-text-icon",
                text: _("Reload"),
                scope:this,
                handler: this.cmpFill
            }
        ];

        this.items = {
            xtype: "form",
            url: this.urls["update"],
            border:false,
            labelWidth: 100,
            bodyStyle: "padding:5px 5px",
            defaults: {
                anchor: "100%",
                allowBlank:false
            },
            items: [
                {
                    xtype: "hidden",
                    name: "document",
                    value: this.oid,
                    allowBlank:false
                },
                {
                    xtype:"checkbox",
                    fieldLabel: _("Published"),
                    boxLabel: _("Yes"),
                    name: "published"
                },
                {
                    xtype:"textfield",
                    fieldLabel: _("URL"),
                    name: "link"
                },
                {
                    xtype:"textfield",
                    fieldLabel: _("Title"),
                    name: "title"
                },
                {
                    xtype:"textarea",
                    fieldLabel: _("Description"),
                    name: "description"
                },
                {
                    xtype:'htmleditor',
                    name: "fulltext",
                    fieldLabel: _("Text"),
                    height:200
                }
            ]
        }

        Ext.apply(this, {
            border:false,
            layout: "fit"
        });

        // Call parent (required)
        Inprint.documents.Profile.Rss.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.documents.Profile.Rss.superclass.onRender.apply(this, arguments);
        this.form = this.findByType("form")[0].getForm();

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
                //this.form.findField("published").setValue(action.result.data.id);
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
    }

});
