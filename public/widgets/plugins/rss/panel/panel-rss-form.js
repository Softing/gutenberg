Inprint.plugins.rss.profile.Form = Ext.extend(Ext.FormPanel, {

    initComponent: function() {

        Ext.apply(this, {
            flex:1,
            xtype: "form",
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
        });

        Inprint.plugins.rss.profile.Form.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.plugins.rss.profile.Form.superclass.onRender.apply(this, arguments);
    }

});
