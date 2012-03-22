Inprint.advertising.advertisers.actionUpdate = function() {

    var form = new Ext.FormPanel({
        frame:false,
        border:false,
        labelWidth: 75,
        bodyStyle: "padding:5px 5px",
        url: _source("advertisers.update"),
        items: [
            _FLD_HDN_ID,
            {
                border:false,
                layout:'column',
                items:[
                    {
                        border:false,
                        columnWidth: .5,
                        layout: 'form',
                        defaults: {
                            anchor: "98%",
                            allowBlank:true
                        },
                        items: [
                            {
                                xtype: "titlefield",
                                value: _("Basic options")
                            },

                            _FLD_SHORTCUT,

                            {
                                xtype: "titlefield",
                                value: _("Advanced options")
                            },
                            {
                                xtype: "textarea",
                                name: "address",
                                fieldLabel: _("Address")
                            },
                            {
                                xtype: "textarea",
                                name: "contact",
                                fieldLabel: _("Contact")
                            }
                        ]
                    },
                    {
                        border:false,
                        columnWidth:.5,
                        layout: 'form',
                        defaults: {
                            anchor: "98%",
                            allowBlank:true
                        },
                        items: [
                            {
                                xtype: "titlefield",
                                value: _("Banking options")
                            },
                            {
                                xtype: "textfield",
                                name: "inn",
                                fieldLabel: _("INN")
                            },
                            {
                                xtype: "textfield",
                                name: "kpp",
                                fieldLabel: _("KPP")
                            },
                            {
                                xtype: "textfield",
                                name: "bank",
                                fieldLabel: _("Bank")
                            },
                            {
                                xtype: "textfield",
                                name: "rs",
                                fieldLabel: _("RS")
                            },
                            {
                                xtype: "textfield",
                                name: "ks",
                                fieldLabel: _("KS")
                            },
                            {
                                xtype: "textfield",
                                name: "bik",
                                fieldLabel: _("BIK")
                            }
                        ]
                    }
                ]
            }
        ],
        keys: [ _KEY_ENTER_SUBMIT ],
        buttons: [ _BTN_SAVE,_BTN_CLOSE ]
    });

    form.on("actioncomplete", function (form, action) {
        if (action.type == "submit") {
            win.hide();
            this.cmpReload();
        }
    }, this);

    form.load({
        scope:this,
        url: _source("advertisers.read"),
        params: { id: this.getValue("id") },
        failure: function(form, action) {
            Ext.Msg.alert("Load failed", action.result.errorMessage);
        }
    });

    win = new Ext.Window({
        title: _("Update role"),
        layout: "fit",
        closeAction: "hide",
        width:600, height:350,
        items: form
    });

    win.show(this);
};
