Inprint.advert.advertisers.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.params = {};
        this.components = {};
        this.urls = {
            "create": _url("/advertising/advertisers/create/"),
            "read":   _url("/advertising/advertisers/read/"),
            "update": _url("/advertising/advertisers/update/"),
            "delete": _url("/advertising/advertisers/delete/")
        }

        this.store = Inprint.factory.Store.json("/advertising/advertisers/list/", {
            totalProperty: 'total'
        });
        
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            this.selectionModel,
            {
                id:"searial",
                header: _("#"),
                width: 40,
                sortable: true,
                dataIndex: "serialnum"
            },
            {
                id:"title",
                header: _("Title"),
                width: 350,
                sortable: true,
                dataIndex: "title"
            },
            {
                id:"shortcut",
                header: _("Shortcut"),
                sortable: true,
                dataIndex: "shortcut"
            },
            {
                id:"description",
                header: _("Description"),
                sortable: true,
                dataIndex: "description"
            },
            {
                id:"address",
                header: _("Address"),
                sortable: true,
                dataIndex: "address"
            },
            {
                id:"contact",
                header: _("Contact"),
                sortable: true,
                dataIndex: "contact"
            },
            {
                id:"phones",
                header: _("Phones"),
                sortable: true,
                dataIndex: "phones"
            },
            {
                id:"inn",
                header: _("INN"),
                sortable: true,
                dataIndex: "inn"
            },
            {
                id:"kpp",
                header: _("KPP"),
                sortable: true,
                dataIndex: "kpp"
            },
            {
                id:"bank",
                header: _("Bank"),
                sortable: true,
                dataIndex: "bank"
            },
            {
                id:"rs",
                header: _("RS"),
                sortable: true,
                dataIndex: "rs"
            },
            {
                id:"ks",
                header: _("KS"),
                sortable: true,
                dataIndex: "ks"
            },
            {
                id:"bik",
                header: _("BIK"),
                sortable: true,
                dataIndex: "bik"
            }
        ];

        this.tbar = [
            {
                icon: _ico("plus-button"),
                cls: "x-btn-text-icon",
                text: _("Add"),
                ref: "../btnCreate",
                scope:this,
                handler: this.cmpCreate
            },
            {
                icon: _ico("pencil"),
                cls: "x-btn-text-icon",
                text: _("Update"),
                disabled:true,
                ref: "../btnUpdate",
                scope:this,
                handler: this.cmpUpdate
            },
            '-',
            {
                icon: _ico("minus-button"),
                cls: "x-btn-text-icon",
                text: _("Remove"),
                disabled:true,
                ref: "../btnDelete",
                scope:this,
                handler: this.cmpDelete
            }
        ];

        this.bbar = new Ext.PagingToolbar({
            pageSize: 100,
            store: this.store,
            displayInfo: true,
            plugins: new Ext.ux.SlidingPager()
        });

        Ext.apply(this, {
            border: false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "title"
        });

        Inprint.advert.advertisers.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.advert.advertisers.Grid.superclass.onRender.apply(this, arguments);
    },
    
    cmpCreate: function() {

        var win = this.components["create-window"];
        if (!win) {

            var form = new Ext.FormPanel({
                url: this.urls["create"],
                frame:false,
                border:false,
                labelWidth: 75,
                defaults: {
                    anchor: "100%",
                    allowBlank:false
                },
                bodyStyle: "padding:5px 5px",
                items: [
                    {
                        border:false,
                        layout:'column',
                        items:[
                            _FLD_HDN_EDITION,
                            {
                                border:false,
                                columnWidth:.5,
                                layout: 'form',
                                items: [
                                    {
                                        xtype:'fieldset',
                                        title: _("General information"),
                                        defaults: {
                                            anchor: "100%"
                                        },
                                        items :[
                                            _FLD_SHORTCUT,
                                            _FLD_TITLE,
                                            _FLD_DESCRIPTION,
                                            {
                                                xtype: "textarea",
                                                name: "address",
                                                fieldLabel: _("Address")
                                            },
                                            {
                                                xtype: "textarea",
                                                name: "contact",
                                                fieldLabel: _("Contact")
                                            },
                                            {
                                                xtype: "textarea",
                                                name: "phones",
                                                fieldLabel: _("Phones")
                                            }
                                        ]
                                    }
                                ]
                            },
                            {
                                border:false,
                                columnWidth:.5,
                                layout: 'form',
                                items: [
                                    {
                                        xtype:'fieldset',
                                        title: _("Banking details"),
                                        defaults: {
                                            anchor: "100%"
                                        },
                                        items :[
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
                        ]
                    }
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_SAVE,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Adding an advertiser"),
                layout: "fit",
                closeAction: "hide",
                width:800, height:500,
                items: form
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit")
                    win.hide();
                this.cmpReload();
            }, this);

            this.components["create-window"] = win;
        }

        var form = win.items.first().getForm();
        form.reset();
        
        form.findField("edition").setValue(this.parent.currentEdition);
        
        win.show();

    },

    cmpUpdate: function() {

        var win = this.components["update-window"];
        if (!win) {

            var form = new Ext.FormPanel({
                border:false,
                labelWidth: 75,
                url: this.urls["update"],
                bodyStyle: "padding:5px 5px",
                defaults: {
                    anchor: "100%",
                    allowBlank:false
                },
                items: [
                    {
                        border:false,
                        layout:'column',
                        items:[
                            _FLD_HDN_ID,
                            {
                                border:false,
                                columnWidth:.5,
                                layout: 'form',
                                items: [
                                    {
                                        xtype:'fieldset',
                                        title: 'User Information',
                                        defaults: {
                                            anchor: "100%"
                                        },
                                        items :[
                                            _FLD_SHORTCUT,
                                            _FLD_TITLE,
                                            _FLD_DESCRIPTION,
                                            {
                                                xtype: "textarea",
                                                name: "address",
                                                fieldLabel: _("Address")
                                            },
                                            {
                                                xtype: "textarea",
                                                name: "contact",
                                                fieldLabel: _("Contact")
                                            },
                                            {
                                                xtype: "textarea",
                                                name: "phones",
                                                fieldLabel: _("Phones")
                                            }
                                        ]
                                    }
                                ]
                            },
                            {
                                border:false,
                                columnWidth:.5,
                                layout: 'form',
                                items: [
                                    {
                                        xtype:'fieldset',
                                        title: 'User Information',
                                        defaults: {
                                            anchor: "100%"
                                        },
                                        items :[
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
                        ]
                    }
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_SAVE,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Update role"),
                layout: "fit",
                closeAction: "hide",
                width:800, height:500,
                items: form
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit") {
                    win.hide();
                    this.cmpReload();
                }
            }, this);

            this.components["update-window"] = win;
        }

        var form = win.items.first().getForm();
        form.reset();

        form.load({
            url: this.urls.read,
            scope:this,
            params: {
                id: this.getValue("id")
            },
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });

        win.show(this);
    },
    
    cmpDelete: function() {
        Ext.MessageBox.confirm(
            _("Warning"),
            _("You really wish to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls["delete"],
                        scope:this,
                        success: this.cmpReload,
                        params: { id: this.getValues("id") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }

});
