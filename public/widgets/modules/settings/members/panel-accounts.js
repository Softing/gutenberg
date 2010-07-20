Inprint.settings.members.AccountsGrid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};
        this.urls = {
            list:    "/settings/accounts/list/",
            add:     _url("/settings/accounts/create/"),
            edit:    _url("/settings/accounts/update/"),
            enable:  _url("/settings/accounts/enable/"),
            disable: _url("/settings/accounts/disable/"),
            remove:  _url("/settings/accounts/delete/")
        }

        this.store = Inprint.factory.Store.json("/settings/accounts/list/");
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        // Buttons

        this.btnAdd = new Ext.menu.Item({
            xtype: "menuitem",
            icon: _ico("overlay/user--plus.png"),
            cls: "x-btn-text-icon",
            text: _("Add"),
            disabled:true,
            ref: "../btnAdd",
            scope:this,
            handler: this.cmpAdd
        });

        this.btnEnable = new Ext.menu.Item({
            xtype: "menuitem",
            icon: _ico("user-green.png"),
            cls: "x-btn-text-icon",
            text: _("Enable"),
            disabled:true,
            ref: "../btnEnable",
            scope:this,
            handler: this.cmpEnable
        });

        this.btnDisable = new Ext.menu.Item({
            xtype: "menuitem",
            icon: _ico("user-silhouette.png"),
            cls: "x-btn-text-icon",
            text: _("Disable"),
            disabled:true,
            ref: "../btnDisable",
            scope:this,
            handler: this.cmpDisable
        });

        this.btnRemove = new Ext.menu.Item({
            xtype: "menuitem",
            icon: _ico("overlay/user--minus.png"),
            cls: "x-btn-text-icon",
            text: _("Remove"),
            disabled:true,
            ref: "../btnRemove",
            scope:this,
            handler: this.cmpRemove
        });

        Ext.apply(this, {

//            title:_("Accounts"),
            disabled:true,

            border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            store: this.store,
            autoExpandColumn: "post",

            columns: [
                this.selectionModel,
                {
                    id:"edition",
                    header: _("Edition"),
                    width: 140,
                    sortable: true,
                    dataIndex: "estitle",
                    renderer: function(val, p, record) {
                        return "<span style=\"color:#" + record.data.color + ";width:30px;height:16px;-webkit-border-radius:2px;-moz-border-radius:3px;\">" + val + "</span>"
                    }
                },
                {
                    id:"post",
                    header: _("Working post"),
                    sortable: true,
                    dataIndex: "metadata",
                    renderer: function(val, p, record) {
                        return val.position;
                    }
                }
            ],
            tbar: [
                {   icon: _ico("card-address.png"),
                    cls: "x-btn-text-icon",
                    text: _("Accounts"),
                    menu : {
                        items: [ this.btnAdd, this.btnEnable, this.btnDisable, this.btnRemove ]
                    }
                },
                '->',
                {   icon: _ico("arrow-circle-double.png"),
                    cls: "x-btn-icon",
                    scope:this,
                    handler: this.cmpReload
                }
            ]
        });

        Inprint.settings.members.AccountsGrid.superclass.initComponent.apply(this, arguments);

        this.on("enable", function() {

            this.btnAdd.enable();

            this.getSelectionModel().on("selectionchange", function(sm) {

                if (sm.getCount()) {
                    _enable(this.btnEnable, this.btnDisable, this.btnRemove);
                } else {
                    _disable(this.btnEnable, this.btnDisable, this.btnRemove);
                }

                //                if (sm.getCount() == 1)
                //                    _enable(this.btnEdit);
                //                else
                //                    _disable(this.btnEdit);

            }, this);

        });

    },

    cmpAdd: function() {

        var win = this.components["add-window"];
        if (!win) {

            win = new Ext.Window({
                title: _("Addition of the new employee"),
                layout: "fit",
                modal:true,
                closeAction: "hide",
                width:280, height:160,
                items: new Ext.FormPanel({

                    url: this.urls.add,

                    frame:false,
                    border:false,

                    labelWidth: 75,
                    defaults: { anchor: "100%" },
                    bodyStyle: "padding:5px 5px",
                    items: [
                        {
                            xtype: "hidden",
                            name: "member"
                        },
                        Inprint.factory.Combo.create("editions", {
                            fieldLabel: _("Edition")
                        }),
                        {
                            xtype:"textfield",
                            name: "position",
                            fieldLabel: _("Position")
                        }
                    ],
                    buttons: [
                        {
                            text: _("Save"),
                            handler: function() {
                                win.items.first().getForm().submit();
                            }
                        },
                        {
                            text: _("Cancel"),
                            handler: function() {
                                win.hide();
                            }
                        }
                    ],
                    listeners: {
                        scope:this,
                        "actioncomplete": function() {
                            win.hide();
                            this.cmpReload();
                        }
                    }
                })
            });
        }

        var form = win.items.first().getForm();
        form.reset();
        form.findField("member").setValue(this.params.member);

        win.show(this);
        this.components["add-window"] = win;
    },

    cmpRemove: function() {

        Ext.MessageBox.confirm(_("Edition removal"), _("You really wish to do this?"), function(btn) {
            if (btn == "yes") {
                Ext.Ajax.request({
                    url: this.urls.remove,
                    scope:this,
                    success: this.cmpReload,
                    params: { id: this.getValues("id") }
                });
            }
        }, this);
    }

});
