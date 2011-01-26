Inprint.plugins.rss.profile.Form = Ext.extend(Ext.FormPanel, {

    initComponent: function() {

        this.urls = {
            "update": _url("/plugin/rss/update/")
        }

        Ext.apply(this, {
            xtype: "form",
            url: this.urls["update"],
            width: 600,
            border:false,
            labelWidth: 100,
            bodyStyle: "padding:5px 5px",
            defaults: {
                anchor: "100%",
                allowBlank:false,
                hideLabel:true
            },
            items: [
                {
                    xtype: "hidden",
                    name: "document",
                    value: this.oid,
                    allowBlank:false
                },
                {
                    xtype:"textfield",
                    emptyText: _("URL"),
                    name: "link"
                },
                {
                    xtype:"textfield",
                    emptyText: _("Title"),
                    name: "title"
                },
                {
                    xtype:"textarea",
                    emptyText: _("Description"),
                    name: "description",
                    height:36
                },
                {
                    xtype:'htmleditor',
                    name: "fulltext",
                    allowBlank:false,
                    hideLabel:true,
                    height:200
                }
            ]
        });

        Inprint.plugins.rss.profile.Form.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.plugins.rss.profile.Form.superclass.onRender.apply(this, arguments);
        this.getForm().url = this.urls["update"];
    }

});
