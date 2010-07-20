Inprint.settings.exchange.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            list:    "/settings/exchange/list/",
            create:  _url("/settings/exchange/create/"),
            enable:  _url("/settings/exchange/enable/"),
            disable: _url("/settings/exchange/disable/"),
            remove:  _url("/settings/exchange/delete/")
        }

        this.store = Inprint.factory.Store.json(this.urls.list);
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        Ext.apply(this, {
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "employee",
            columns: [
                this.selectionModel,
                {   id:"color",
                    width: 38,
                    dataIndex: "color",
                    header : '<img src="' + _ico("color.png") + '">',
                    renderer: function(val) {
                        return "<div style=\"background:#" + val + ";width:30px;height:16px;-webkit-border-radius:2px;-moz-border-radius:3px;\">&nbsp;</div>"
                    }
                },
                {   id:"order",
                    width: 38,
                    dataIndex: "order",
                    header : '<img src="' + _ico("edit-list-order.png") + '">',
                    renderer : function(v) {
                        return v + '%';
                    }

                },
                {   id:"title",
                    header: _("Title"),
                    width: 200,
                    dataIndex: "title",
                    renderer: function(value, metadata, record) {
                        if (record.data.enabled)
                            value = "<b>" + value + "</b>";
                        else
                            value = "<s>" + value + "</s>";
                        return value;
                    }
                },
                {   id:"employee",
                    header: _("Employee"),
                    dataIndex: "description"
                }
            ],

            tbar: [
                {   icon: _ico("plus-circle.png"),
                    cls: "x-btn-text-icon",
                    text: _("Add"),
                    disabled:true,
                    ref: "../btnAdd",
                    scope:this,
                    handler: this.cmpAdd
                },
                '-',
                {   icon: _ico("overlay/switch--plus.png"),
                    cls: "x-btn-text-icon",
                    text: _("Enable"),
                    disabled:true,
                    ref: "../btnEnable",
                    scope:this,
                    handler: this.cmpEnable
                },
                {   icon: _ico("overlay/switch--minus.png"),
                    cls: "x-btn-text-icon",
                    text: _("Disable"),
                    disabled:true,
                    ref: "../btnDisable",
                    scope:this,
                    handler: this.cmpDisable
                },
                '-',
                {   icon: _ico("overlay/bin--arrow.png"),
                    cls: "x-btn-text-icon",
                    text: _("Remove"),
                    disabled:true,
                    ref: "../btnRemove",
                    scope:this,
                    handler: this.cmpRemove
                },
                '->',
                {   icon: _ico("arrow-circle-double.png"),
                    cls: "x-btn-icon",
                    scope:this,
                    handler: this.cmpReload
                }
            ]
        });

        Inprint.settings.exchange.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.settings.exchange.Grid.superclass.onRender.apply(this, arguments);
    },


    cmpAdd: function() {

        var win = this.components["add-window"];
        if (!win) {

            win = new Ext.Window({
                title: _("Edition addition"),
                layout: "fit",
                closeAction: "hide",
                width:340, height:260,
                items: new Ext.FormPanel({

                    url: this.urls.create,

                    frame:false,
                    border:false,

                    labelWidth: 75,
                    defaults: {
                        anchor: "95%"
                    },
                    bodyStyle: "padding:5px 5px",
                    items: [
                        {   xtype:"hidden",
                            name:"edition"
                        },
                        {   xtype:"hidden",
                            name:"type"
                        },
                        {   xtype: "colorpickerfield",
                            fieldLabel: _("Color"),
                            editable:false,
                            name: "color",
                            value: "000000"
                        },
                        {   xtype: 'spinnerfield',
                            fieldLabel: _("Order"),
                            name: 'order',
                            minValue: 0,
                            maxValue: 100,
                            incrementValue: 5,
                            accelerate: true
                        },
                        {
                            xtype: "textfield",
                            name: "title",
                            fieldLabel: _("Title")
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
                })
            });
        }

        var form = win.items.first().getForm();
        form.reset();

        form.findField("edition").setValue(this.params.edition);
        form.findField("type").setValue(this.params.type);

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
