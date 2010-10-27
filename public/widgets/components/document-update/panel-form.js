Inprint.cmp.UpdateDocument.Form = Ext.extend(Ext.FormPanel, {

    initComponent: function() {

        var xc = Inprint.factory.Combo;

        Ext.apply(this, {
            url: _url("/documents/update/"),
            border:false,
            autoScroll:true,
            labelWidth: 80,
            bodyStyle: "padding: 20px 10px 20px 10px",
            defaults: {
                anchor: "100%"
            },
            items: [
                _FLD_HDN_ID,
                {
                    xtype: 'textfield',
                    fieldLabel: _("Title"),
                    name: 'title',
                    allowBlank:false
                },
                {
                    xtype: 'textfield',
                    fieldLabel: _("Author"),
                    name: 'author'
                },
                {
                    xtype: 'numberfield',
                    fieldLabel: _("Size"),
                    name: 'size',
                    allowDecimals: false,
                    allowNegative: false
                },
                {
                    xtype: 'xdatefield',
                    name: 'enddate',
                    format:'F j, Y',
                    altFormats: 'c',
                    submitFormat:'Y-m-d',
                    minValue: new Date(),
                    allowBlank:false,
                    fieldLabel: _("Date")
                }
            ]
        });

        Inprint.cmp.UpdateDocument.Form.superclass.initComponent.apply(this, arguments);
        this.getForm().url = this.url;
    },

    onRender: function() {
        Inprint.cmp.UpdateDocument.Form.superclass.onRender.apply(this, arguments);
    }

});
