Inprint.settings.exchange.EditPanel = Ext.extend(Ext.FormPanel, {
    initComponent: function() {

        Ext.apply(this, {

            disabled:true,

            labelWidth: 75,
            url: _url("/settings/exchange/update/"),

            title: _("Adjustment"),
            bodyStyle:"padding:15px 15px",

            defaults: { anchor: "100%" },
            defaultType: "textfield",

            items: [
                {   xtype:"hidden",
                    name:"id"
                },
                {   xtype:"hidden",
                    name:"edition"
                },
                {   xtype:"hidden",
                    name:"enabled"
                },
                {   xtype:"hidden",
                    name:"type"
                },
                {   xtype: "colorpickerfield",
                    fieldLabel: _("Color"),
                    editable: false,
                    name: "color",
                    value: "ffffff"
                },
                {   xtype: 'spinnerfield',
                    fieldLabel: _("Order"),
                    name: 'order',
                    minValue: 0,
                    maxValue: 100,
                    incrementValue: 5,
                    accelerate: true
                },
                {   fieldLabel: _("Title"),
                    name: "title"
                },
                {   xtype:"textarea",
                    fieldLabel: _("Description"),
                    name: "description"
                }
            ],

            tbar: [
                {
                    icon: _ico("disk-black.png"),
                    cls: "x-btn-text-icon",
                    text: _("Save"),
                    ref: "../btnASave",
                    scope:this,
                    handler: function() {
                        this.getForm().submit();
                    }
                },
                {
                    icon: _ico("slash.png"),
                    cls: "x-btn-text-icon",
                    text: _("Cancel"),
                    ref: "../btnCacnel",
                    scope:this,
                    handler: function() {
                        this.getForm().reset();
                    }
                }
            ]
        });

        Inprint.settings.exchange.EditPanel.superclass.initComponent.apply(this, arguments);

        this.getForm().url = this.url;

    },

    onRender: function() {
        Inprint.settings.exchange.EditPanel.superclass.onRender.apply(this, arguments);
    },

    cmpFill: function(record) {
        this.getForm().reset();
        if (record) {
            this.getForm().loadRecord(record);
        }
    }

});
