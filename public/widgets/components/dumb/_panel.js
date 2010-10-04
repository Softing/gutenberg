Inprint.cmp.DumbWindow = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.formPanel = new Ext.FormPanel({
            url: "/dumb/",
            frame:false,
            border:false,
            labelWidth: 100,
            defaults: {
                anchor: "100%",
                allowBlank:false
            },
            bodyStyle: "padding: 20px 10px",
            //items: [
            //
            //],
            keys: [ _KEY_ENTER_SUBMIT ],
            buttons: [
                _BTN_SAVE,
                {
                    text: _("Close"),
                    scope:this,
                    handler: function() {
                        this.hide();
                    }
                }

            ]
        });

        Ext.apply(this, {
            title: _("Dumb window"),
            layout: "fit",
            closeAction: "hide",
            width:800, height:400,
            items: this.formPanel
        });

        this.formPanel.on("actioncomplete", function (form, action) {
            if (action.type == "submit")
                this.hide();
        });

        Inprint.cmp.DumbWindow.superclass.initComponent.apply(this, arguments);

        Inprint.cmp.DumbWindow.Interaction(this.panels);
    },

    onRender: function() {
        Inprint.cmp.DumbWindow.superclass.onRender.apply(this, arguments);
    }

});
