Inprint.plugins.rss.profile.Form = Ext.extend(Ext.FormPanel, {

    initComponent: function() {

        this.urls = {
            "update": _url("/plugin/rss/update/")
        };

        Ext.apply(this, {
            xtype: "form",
            url: this.urls.update,
            width: 600,
            border:false,
            labelWidth: 70,
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
                    xtype:"textfield",
                    fieldLabel: _("URL"),
                    emptyText: _("URL"),
                    name: "link"
                },
                {
                    xtype:"textfield",
                    fieldLabel: _("Title"),
                    emptyText: _("Title"),
                    name: "title"
                },
                {
                    xtype:"textarea",
                    fieldLabel: _("Description"),
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
        this.getForm().url = this.urls.update;
    }

});
