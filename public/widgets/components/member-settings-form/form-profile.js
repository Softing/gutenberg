Inprint.cmp.memberSettingsForm.Form = Ext.extend(Ext.FormPanel, {
    initComponent: function() {

        this.url = _url("/options/update/");

        Ext.apply(this,
        {
            border:false,
            autoScroll:true,
            layout: "fit",
            items: {
                xtype:'tabpanel',
                activeTab: 0,
                defaults:{
                    bodyStyle:'padding:10px'
                },
                items:[
                    {
                        title: _("Exchange"),
                        layout:'form',
                        labelWidth: 120,
                        defaults: {
                            width: 230
                        },
                        defaultType: 'textfield',
                        items: [
                            Inprint.factory.Combo.create("/options/combos/capture-destination/")
                        ]
                    }
                ]
            }
        });

        Inprint.cmp.memberSettingsForm.Form.superclass.initComponent.apply(this, arguments);

        this.getForm().url = this.url;

    },

    onRender: function() {

        Inprint.cmp.memberSettingsForm.Form.superclass.onRender.apply(this, arguments);

        if (Inprint.session.options && Inprint.session.options["transfer.capture.destination"]) {
            this.getForm().findField("capture.destination").loadValue(Inprint.session.options["transfer.capture.destination"]);
        }
    }

});
