Inprint.advertising.advertisers.actionCreate = function() {

    var form = new Ext.FormPanel({
        frame:false,
        border:false,
        labelWidth: 75,
        bodyStyle: "padding:5px 5px",
        url: _source("advertisers.create"),
        items: [
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

                            {
                                xtype: "treecombo",
                                allowBlank:false,
                                hiddenName: "edition",
                                fieldLabel: _("Edition"),
                                emptyText: _("Select..."),
                                url: _url('/common/tree/editions/'),
                                baseParams: {
                                    term: 'editions.advert.manage:*'
                                },
                                root: {
                                    id:'root',
                                    nodeType: 'async',
                                    expanded: true
                                }
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
        buttons: [ _BTN_ADD, _BTN_CLOSE ]
    });

    form.on("actioncomplete", function (form, action) {
        if (action.type == "submit") {
            win.hide();
        }
        this.cmpReload();
    }, this);

    win = new Ext.Window({
        items: form,
        layout: "fit",
        modal: true,
        width:600, height:350,
        title: _("Adding an advertiser")
    });

    win.show();

};
