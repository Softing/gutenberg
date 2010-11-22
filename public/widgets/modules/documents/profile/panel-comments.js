Inprint.documents.Profile.Comments = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.tbar = [
            {
                icon: _ico("balloon--plus"),
                cls: "x-btn-text-icon",
                text: _("Add a comment"),
                disabled:true,
                ref: "../btnSay",
                scope:this,
                handler: this.cmpSay
            }
        ];

        Ext.apply(this, {
            border: false
        });
        // Call parent (required)
        Inprint.documents.Profile.Comments.superclass.initComponent.apply(this, arguments);
    },

    // Override other inherited methods
    onRender: function() {
        // Call parent (required)
        Inprint.documents.Profile.Comments.superclass.onRender.apply(this, arguments);
    },
    
    cmpFill: function(record) {
        if (record && record.access)
            this.cmpAccess(record.access);
    },
    
    cmpAccess: function(access) {
        _disable(this.btnSay);
        if (access["documents.discuss"] == true) this.btnSay.enable();
    },

    cmpSay: function() {

        var form = new Ext.FormPanel({
            border:false,
            url: _url("/documents/say/"),
            bodyStyle: "padding:5px 5px",
            defaults: {
                anchor: "100%",
                allowBlank:false
            },
            items: [
                {
                    xtype: "textarea",
                    name: "text",
                    height:160,
                    hideLabel: true
                }
            ],
            keys: [ _KEY_ENTER_SUBMIT ],
            buttons: [ _BTN_ADD, _BTN_CANCEL ]
        });

        var win = new Ext.Window({
            title: _("Add a comment"),
            layout: "fit",
            width:400, height:260,
            items: form
        });

        form.on("actioncomplete", function (form, action) {
            if (action.type == "submit")
                win.hide();
            this.getStore().load();
        }, this);

        win.show();
    }

});
