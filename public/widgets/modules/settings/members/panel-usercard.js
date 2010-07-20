Inprint.settings.members.UsercardPanel = Ext.extend(Ext.FormPanel, {
    initComponent: function() {

        Ext.apply(this, {

            title: _("Card"),
            disabled:true,
            url: _url("/settings/accounts/update/"),
            bodyStyle:"padding:15px 15px",

            labelWidth: 75,
            defaults: { anchor: "100%" },
            defaultType: "textfield",

            items: [
                {   xtype:"hidden",
                    name:"id"
                },
                {   fieldLabel: _("Position"),
                    name: "position"
                }
            ],

            tbar: [
                {   icon: _ico("disk-black.png"),
                    cls: "x-btn-text-icon",
                    text: _("Save"),
                    ref: "../btnASave",
                    scope:this,
                    handler: function() {
                        this.getForm().submit();
                    }
                }
            ]
        });

        Inprint.settings.members.UsercardPanel.superclass.initComponent.apply(this, arguments);

        this.getForm().url = this.url;

    },

    onRender: function() {
        Inprint.settings.members.UsercardPanel.superclass.onRender.apply(this, arguments);
    },

    cmpFill: function(id, metadata) {
        var form = this.getForm();
        form.findField("id").setValue(id);
        form.findField("position").setValue(metadata.position);
    }

});
