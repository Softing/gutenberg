Inprint.settings.members.MembersGrid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};
        this.urls = {
            list:     "/settings/members/list/",
            add:      _url("/settings/members/create/"),
            edit:     _url("/settings/members/update/"),
            password: _url("/settings/members/password/"),
            enable:   _url("/settings/members/enable/"),
            disable:  _url("/settings/members/disable/"),
            remove:   _url("/settings/members/delete/")
        };

        this.store = Inprint.factory.Store.json(this.urls.list);
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        // Buttons

        this.btnAdd = new Ext.menu.Item({
            icon: _ico("overlay/user--plus.png"),
            cls: "x-btn-text-icon",
            text: _("Add"),
            disabled:true,
            ref: "../btnAdd",
            scope:this,
            handler: this.cmpAdd
        });

        this.btnEdit = new Ext.menu.Item({
            icon: _ico("overlay/user--pencil.png"),
            cls: "x-btn-text-icon",
            text: _("Edit"),
            disabled:true,
            ref: "../btnEdit",
            scope:this,
            handler: this.cmpEdit
        });

        this.btnPasswd = new Ext.menu.Item({
            icon: _ico("overlay/user--pencil.png"),
            cls: "x-btn-text-icon",
            text: _("Change password"),
            disabled:true,
            ref: "../btnPasswd",
            scope:this,
            handler: this.cmpPassword
        });

        this.btnEnable = new Ext.menu.Item({
            icon: _ico("user-green.png"),
            cls: "x-btn-text-icon",
            text: _("Enable"),
            disabled:true,
            ref: "../btnEnable",
            scope:this,
            handler: this.cmpEnable
        });

        this.btnDisable = new Ext.menu.Item({
            icon: _ico("user-silhouette.png"),
            cls: "x-btn-text-icon",
            text: _("Disable"),
            disabled:true,
            ref: "../btnDisable",
            scope:this,
            handler: this.cmpDisable
        });

        this.btnRemove = new Ext.menu.Item({
            icon: _ico("overlay/user--minus.png"),
            cls: "x-btn-text-icon",
            text: _("Remove"),
            disabled:true,
            ref: "../btnRemove",
            scope:this,
            handler: this.cmpRemove
        });

        // Config
        Ext.apply(this, {
            //title:_("Members"),
            border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            store: this.store,
            autoExpandColumn: "title",

            columns: [
                this.selectionModel,
                {
                    id:"title",
                    header: _("Login"),
                    width: 100,
                    sortable: true,
                    dataIndex: "stitle",
                    style:"cursor:pointer",
                    renderer: function(value, metadata, record) {
                        
                        if (record.data.enabled)
                            value = "<h1>" + value + "</h1>";
                        else
                            value = "<h1><s>" + value + "</s></h1>";

                        value += '<div>' + record.get("login") + '</div>';
                        value += '<div>' + record.get("email") + '</div>';

                        return '<div style="height:40px;padding-left:50px;background:url(/images/blank.gif) no-repeat;cursor:pointer;">'+ value +'</div>';
                    }
                }
            ],
            tbar: [
                {
                    icon: _ico("user-business.png"),
                    cls: "x-btn-text-icon",
                    text: _("Members"),
                    menu : {
                        items: [ this.btnAdd, '-', this.btnEdit, this.btnPasswd, '-', this.btnEnable, this.btnDisable, '-', this.btnRemove ]
                    }
                },
                '->',
                Inprint.factory.Combo.create("editions", {
                    width:100,
                    disableCaching:true,
                    listeners: {
                        scope:this,
                        afterrender: function(combo) {
                            combo.getStore().on("load", function(){
                                combo.setValue("00000000-0000-0000-0000-000000000000");
                                combo.fireEvent('select', combo, combo.getStore().getById( combo.getValue() ) );
                            }, this, { single: true});
                            combo.getStore().load();
                        },
                        select: function(combo, record) {
                            this.cmpLoad({ edition: record.get("id") });
                        }
                    }
                })
            ]
        });

        Inprint.settings.members.MembersGrid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.settings.members.MembersGrid.superclass.onRender.apply(this, arguments);
        //this.store.load();
    },

    cmpAdd: function() {

        var win = this.components["add-window"];
        if (!win) {

            win = new Ext.Window({
                title: _("Addition of the new employee"),
                layout: "fit",
                modal:true,
                closeAction: "hide",
                width:280, height:340,
                items: new Ext.FormPanel({

                    url: this.urls.add,

                    frame:false,
                    border:false,

                    labelWidth: 75,
                    defaults: { anchor: "100%" },
                    bodyStyle: "padding:5px 5px",
                    items: [
                        {
                            xtype:'fieldset',
                            title: _("System parametres"),
                            autoHeight:true,
                            defaultType: 'textfield',
                            defaults: { anchor: "100%", allowBlank:false },
                            items :[
                                {
                                    name: "login",
                                    fieldLabel: _("Login")
                                },
                                {
                                    name: "email",
                                    fieldLabel: _("Email")
                                },
                                {
                                    name: "password",
                                    inputType:"password",
                                    fieldLabel: _("Password")
                                },
                                {
                                    xtype: "checkbox",
                                    boxLabel: 'Super admin',
                                    inputValue: "test",
                                    name: 'superman'
                                }
                            ]
                        },
                        {
                            xtype:'fieldset',
                            title: _("About the employee"),
                            autoHeight:true,
                            defaultType: 'textfield',
                            defaults: { anchor: "100%", allowBlank:false },
                            items :[
                                {
                                    xtype: "textarea",
                                    height:35,
                                    name: "title",
                                    fieldLabel: _("Name")
                                },
                                {
                                    name: "stitle",
                                    fieldLabel: _("Short name")
                                }
                            ]
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

        win.show(this);
        this.components["add-window"] = win;
    },

    cmpEdit: function() {

        var win = this.components["edit-window"];
        if (!win) {

            win = new Ext.Window({
                title: _("Addition of the new employee"),
                layout: "fit",
                modal:true,
                closeAction: "hide",
                width:280, height:340,
                items: new Ext.FormPanel({

                    url: this.urls.edit,

                    frame:false,
                    border:false,

                    labelWidth: 75,
                    defaults: { anchor: "100%" },
                    bodyStyle: "padding:5px 5px",
                    items: [
                        {
                            xtype:"hidden",
                            name: "id"
                        },
                        {
                            xtype:'fieldset',
                            title: _("System parametres"),
                            autoHeight:true,
                            defaultType: 'textfield',
                            defaults: { anchor: "100%", allowBlank:false },
                            items :[
                                {
                                    name: "login",
                                    fieldLabel: _("Login")
                                },
                                {
                                    name: "email",
                                    fieldLabel: _("Email")
                                },
                                {
                                    xtype: "checkbox",
                                    boxLabel: 'Super admin',
                                    inputValue: "test",
                                    name: 'superman'
                                }
                            ]
                        },
                        {
                            xtype:'fieldset',
                            title: _("About the employee"),
                            autoHeight:true,
                            defaultType: 'textfield',
                            defaults: { anchor: "100%", allowBlank:false },
                            items :[
                                {
                                    xtype: "textarea",
                                    height:35,
                                    name: "title",
                                    fieldLabel: _("Name")
                                },
                                {
                                    name: "stitle",
                                    fieldLabel: _("Short name")
                                }
                            ]
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

        win.items.first().getForm().loadRecord(this.getSelectionModel().getSelected());

        win.show(this);
        this.components["edit-window"] = win;
    },

    cmpPassword: function() {

        var win = this.components["password-window"];
        if (!win) {

            win = new Ext.Window({
                title: _("Addition of the new employee"),
                layout: "fit",
                modal:true,
                closeAction: "hide",
                width:300, height:140,
                items: new Ext.FormPanel({

                    url: this.urls.password,

                    frame:false,
                    border:false,

                    labelWidth: 90,
                    defaultType: 'textfield',
                    defaults: { anchor: "100%" },
                    bodyStyle: "padding:5px 5px",
                    items: [
                        {
                            xtype:"hidden",
                            name: "id"
                        },
                        {
                            name: "password",
                            fieldLabel: _("New password")
                        },
                        {
                            name: "retype",
                            fieldLabel: _("Retype password")
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

        win.items.first().getForm().loadRecord(this.getSelectionModel().getSelected());

        win.show(this);
        this.components["password-window"] = win;
    },

    cmpEnable: function() {
        Ext.MessageBox.confirm(_("Edition removal"), _("You really wish to do this?"), function(btn) {
            if (btn == "yes") {
                Ext.Ajax.request({
                    url: this.urls.enable,
                    scope:this,
                    success: this.cmpReload,
                    params: { id: this.getValues("id") }
                });
            }
        }, this);
    },

    cmpDisable: function() {
        Ext.MessageBox.confirm(_("Edition removal"), _("You really wish to do this?"), function(btn) {
            if (btn == "yes") {
                Ext.Ajax.request({
                    url: this.urls.disable,
                    scope:this,
                    success: this.cmpReload,
                    params: { id: this.getValues("id") }
                });
            }
        }, this);
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
