Inprint.settings.departments.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.params = {};
        this.components = {};

        this.urls = {
            create:  _url("/settings/departments/create/"),
            enable:  _url("/settings/departments/enable/"),
            disable: _url("/settings/departments/disable/"),
            remove:  _url("/settings/departments/delete/")
        }

        this.store = Inprint.factory.Store.json("/settings/departments/list/");
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
                    id:"color",
                    header: _("Color"),
                    dataIndex: "color",
                    width: 43,
                    sortable: true,
                    renderer: function(val) {
                        return "<div style=\"background:#" + val + ";width:30px;height:16px;-webkit-border-radius:2px;-moz-border-radius:3px;\">&nbsp;</div>"
                    }
                },
                {
                    id:"stitle",
                    header: _("Short"),
                    width: 60,
                    sortable: true,
                    dataIndex: "stitle"
                },
                {
                    id:"title",
                    header: _("Title"),
                    width: 200,
                    sortable: true,
                    dataIndex: "title"
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
                    icon: _ico("plus-circle.png"),
                    cls: "x-btn-text-icon",
                    text: _("Add"),
                    disabled:true,
                    ref: "../btnAdd",
                    scope:this,
                    handler: this.cmpAdd
                },
                '-',
                {
                    icon: _ico("overlay/switch--plus.png"),
                    cls: "x-btn-text-icon",
                    text: _("Enable"),
                    disabled:true,
                    ref: "../btnEnable",
                    scope:this,
                    handler: this.cmpEnable
                },
                {
                    icon: _ico("overlay/switch--minus.png"),
                    cls: "x-btn-text-icon",
                    text: _("Disable"),
                    disabled:true,
                    ref: "../btnDisable",
                    scope:this,
                    handler: this.cmpDisable
                },
                '-',
                {
                    icon: _ico("overlay/bin--arrow.png"),
                    cls: "x-btn-text-icon",
                    text: _("Remove"),
                    disabled:true,
                    ref: "../btnRemove",
                    scope:this,
                    handler: this.cmpRemove
                },
                '->',
                {
                    icon: _ico("arrow-circle-double.png"),
                    cls: "x-btn-icon",
                    scope:this,
                    handler: this.cmpReload
                }
            ]
        });

        Inprint.settings.departments.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.settings.departments.Grid.superclass.onRender.apply(this, arguments);
    },

    cmpAdd: function() {

        var win = this.components["add-window"];
        if (!win) {

            win = new Ext.Window({
                title: _("Edition addition"),
                layout: "fit",
                modal:true,
                closeAction: "hide",
                width:340, height:260,
                items: {
                    xtype: 'form',

                    url: this.urls.create,

                    frame:false,
                    border:false,

                    labelWidth: 75,
                    defaults: {
                        anchor: "95%"
                    },
                    bodyStyle: "padding:5px 5px",
                    items: [
                        {
                            xtype: "hidden",
                            name: "edition"
                        },
                        {
                            xtype: "colorpickerfield",
                            fieldLabel: _("Color"),
                            editable:false,
                            name: "color",
                            value: "000000"
                        },
                        {
                            xtype: "textfield",
                            name: "stitle",
                            fieldLabel: _("Short")
                        },
                        {
                            xtype: "textfield",
                            name: "title",
                            fieldLabel: _("Title"),
                            allowBlank:false
                        },
                        {
                            xtype: "textarea",
                            name: "description",
                            fieldLabel: _("Description")
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

        form.findField("edition").setValue(this.params.edition);

        win.show(this);
        this.components["add-window"] = win;
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
