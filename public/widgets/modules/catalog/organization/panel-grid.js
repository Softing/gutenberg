Inprint.catalog.organization.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            create:  _url("/members/create/"),
            remove:  _url("/members/delete/")
        };

        this.store = Inprint.factory.Store.json("/members/list/");
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        Ext.apply(this, {
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "name",

            enableDragDrop: true,
            ddGroup:'member2catalog',

            columns: [
                this.selectionModel,
                {
                    id:"login",
                    header: _("Login"),
                    width: 80,
                    sortable: true,
                    dataIndex: "login"
                },
                {
                    id:"position",
                    header: _("Position"),
                    width: 160,
                    sortable: true,
                    dataIndex: "position"
                },
                {
                    id:"shortcut",
                    header: _("Shortcut"),
                    width: 120,
                    sortable: true,
                    dataIndex: "shortcut"
                },
                {
                    id:"name",
                    header: _("Title"),
                    width: 120,
                    sortable: true,
                    dataIndex: "title"
                }
            ],

            tbar: [
                {
                    xtype: 'buttongroup',
                    title: _("Organization"),
                    defaults: { scale: 'small' },
                    items: [
                        {
                            icon: _ico("user--plus"),
                            cls: "x-btn-text-icon",
                            text: _("Add"),
                            disabled:true,
                            ref: "../../btnAdd",
                            scope:this,
                            handler: this.cmpAdd
                        },
                        {
                            icon: _ico("user--minus"),
                            cls: "x-btn-text-icon",
                            text: _("Remove"),
                            disabled:true,
                            ref: "../../btnDelete",
                            scope:this,
                            handler: this.cmpDelete
                        }
                    ]
                },
                {
                    xtype: 'buttongroup',
                    title: _("Membership in group"),
                    defaults: { scale: 'small' },
                    items: [
                        {
                            icon: _ico("plug"),
                            cls: "x-btn-text-icon",
                            text: _("Add"),
                            disabled:true,
                            ref: "../../btnAddToGroup",
                            scope:this,
                            handler: this.cmpAddToGroup
                        },
                        {
                            icon: _ico("plug-disconnect"),
                            cls: "x-btn-text-icon",
                            text: _("Remove"),
                            disabled:true,
                            ref: "../../btnDeleteFromGroup",
                            scope:this,
                            handler: this.cmpDeleteFromGroup
                        }
                    ]
                },
                {
                    xtype: 'buttongroup',
                    title: _("Profile of the employee"),
                    defaults: { scale: 'small' },
                    items: [
                        {
                            icon: _ico("card"),
                            cls: "x-btn-text-icon",
                            text: _("Profile viewing"),
                            disabled:true,
                            ref: "../../btnViewProfile",
                            scope:this,
                            handler: this.cmpViewProfile
                        },
                        {
                            icon: _ico("card--pencil"),
                            cls: "x-bt  n-text-icon",
                            text: _("Profile editing"),
                            disabled:true,
                            ref: "../../btnUpdateProfile",
                            scope:this,
                            handler: this.cmpUpdateProfile
                        },
                        {
                            icon: _ico("key-solid"),
                            cls: "x-bt  n-text-icon",
                            text: _("The rights"),
                            disabled:true,
                            ref: "../../btnManageRules",
                            scope:this,
                            handler: this.cmpManageRules
                        }
                    ]
                }
            ]
        });

        Inprint.catalog.organization.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.catalog.organization.Grid.superclass.onRender.apply(this, arguments);
    },

    cmpAdd: function() {

        var win = this.components["add-window"];
        if (!win) {

            win = new Ext.Window({
                title: _("Edition addition"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:350,
                items: new Ext.FormPanel({

                    url: this.urls.create,

                    frame:false,
                    border:false,

                    labelWidth: 75,
                    defaults: {
                        anchor: "100%"
                    },
                    bodyStyle: "padding:10px",

                    items: [
                        {
                            xtype:'fieldset',
                            title: _("System Information"),
                            defaults: { anchor: "100%" },
                            defaultType: "textfield",
                            items :[
                                {
                                    fieldLabel: _("Login"),
                                    name: "login"
                                },
                                {
                                    fieldLabel: _("Password"),
                                    name: "password"
                                }
                            ]
                        },
                        {
                            xtype:'fieldset',
                            title: _("User Information"),
                            defaults: { anchor: "100%" },
                            defaultType: "textfield",
                            items :[
                                {
                                    fieldLabel: _("Name"),
                                    name: "name"
                                },
                                {
                                    fieldLabel: _("Shortcut"),
                                    name: "shortcut"
                                },
                                {
                                    fieldLabel: _("Position"),
                                    name: "position"
                                }
                            ]
                        }
                    ],

                    buttons: [
                        {
                            text: _("Add"),
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
        }, this).setIcon(Ext.MessageBox.WARNING);
    }

});
