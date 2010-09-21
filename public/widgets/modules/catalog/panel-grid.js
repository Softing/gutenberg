Inprint.catalog.Grid = Ext.extend(Ext.grid.GridPanel, {

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
                    header: _("Name"),
                    width: 120,
                    sortable: true,
                    dataIndex: "name"
                }
            ],

            tbar: [
                {
                    icon: _ico("plus-button"),
                    cls: "x-btn-text-icon",
                    text: _("Add"),
                    disabled:true,
                    ref: "../btnAdd",
                    scope:this,
                    handler: this.cmpAdd
                },
                '-',
                {
                    icon: _ico("minus-button"),
                    cls: "x-btn-text-icon",
                    text: _("Remove"),
                    disabled:true,
                    ref: "../btnRemove",
                    scope:this,
                    handler: this.cmpRemove
                },
                '->',
                {
                    icon: _ico("arrow-circle-double"),
                    cls: "x-btn-icon",
                    scope:this,
                    handler: this.cmpReload
                }
            ]
        });

        Inprint.catalog.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.catalog.Grid.superclass.onRender.apply(this, arguments);
        //this.store.load();
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
