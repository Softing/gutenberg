Inprint.cmp.memberSettingsForm.Form = Ext.extend(Ext.FormPanel, {
    initComponent: function() {

        this.imgid = Ext.id();

        Ext.apply(this,
        {
            fileUpload: true,
            border:false,
            url: _url("/settings/update/"),
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
                        defaults: {
                            width: 230
                        },
                        defaultType: 'textfield',
                        items: [
                            {
                                fieldLabel: _("Default department"),
                                name: 'first',
                                allowBlank:false,
                                value: 'Jack'
                            }
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
    }

});
