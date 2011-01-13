Inprint.documents.Profile.Rss = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.access = {};
        this.record = {};

        this.title = _("Rss");

        this.urls = {
            "read":   _url("/documents/files/read/"),
            "update": _url("/documents/files/update/")
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
            }
        ];

        this.items = {
            xtype: "form",
            url: this.urls["update"],
            border:false,
            labelWidth: 75,
            bodyStyle: "padding:5px 5px",
            defaults: {
                anchor: "100%",
                allowBlank:false
            },
            items: [
                {
                    xtype:"checkbox",
                    fieldLabel: _("Published"),
                    boxLabel: _("Yes"),
                    name: "published"
                },
                {
                    xtype:"textfield",
                    fieldLabel: _("URL"),
                    name: "url"
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
        _disable(this.btnSave);
        if (access["documents.update"] == true) this.btnSave.enable();
    }

});
