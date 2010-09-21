Inprint.roles.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.params = {};
        this.components = {};

        this.urls = {
            list:    "/roles/list/",
            create:  _url("/roles/create/"),
            remove:  _url("/roles/delete/")
        }

        this.store = Inprint.factory.Store.json(this.urls.list);
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        Ext.apply(this, {
            disabled:true,
            border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "description",
            columns: [
                this.selectionModel,
                {
                    id:"group",
                    header: _("Group"),
                    width: 100,
                    sortable: true,
                    dataIndex: "catalog_shortcut"
                },
                {
                    id:"title",
                    header: _("Name"),
                    width: 200,
                    sortable: true,
                    dataIndex: "name"
                },
                {
                    id:"shortcut",
                    header: _("Shortcut"),
                    width: 200,
                    sortable: true,
                    dataIndex: "shortcut"
                },
                {
                    id:"description",
                    header: _("Description"),
                    sortable: true,
                    dataIndex: "description"
                }
            ],

            tbar: [
                {
                    icon: _ico("plus-button"),
                    cls: "x-btn-text-icon",
                    text: _("Add"),
                    disabled:true,
                    ref: "../btnCreate",
                    scope:this,
                    handler: this.cmpCreate
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

        Inprint.roles.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.roles.Grid.superclass.onRender.apply(this, arguments);

        this.store.load();
    },

    cmpCreate: function() {

        var win = this.components["create-window"];
        if (!win) {

            win = new Ext.Window({
                title: _("Addition of a role"),
                layout: "fit",
                modal:true,
                closeAction: "hide",
                width:400, height:300,
                items: {
                    xtype: 'form',

                    url: this.urls.create,

                    frame:false,
                    border:false,

                    labelWidth: 75,
                    defaults: {
                        anchor: "95%",
                        allowBlank:false
                    },
                    bodyStyle: "padding:5px 5px",
                    items: [
                        Inprint.factory.Combo.create("catalog"),
                        {
                            xtype: "textfield",
                            name: "name",
                            fieldLabel: _("Name")
                        },
                        {
                            xtype: "textfield",
                            name: "shortcut",
                            fieldLabel: _("Shortcut")
                        },
                        {
                            xtype: "textarea",
                            name: "description",
                            fieldLabel: _("Description"),
                            allowBlank:true
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
                }
            });
        }

        var form = win.items.first().getForm();
        form.reset();

        win.show(this);
        this.components["create-window"] = win;
    },

    cmpDelete: function() {

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
