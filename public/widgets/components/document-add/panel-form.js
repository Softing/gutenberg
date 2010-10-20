Inprint.cmp.CreateDocument.Form = Ext.extend(Ext.FormPanel, {
    initComponent: function() {

        var xc = Inprint.factory.Combo;

        Ext.apply(this, {
            url: _url("/documents/create/"),
            border:false,
            layout:'column',
            autoScroll:true,
            labelWidth: 80,
            bodyStyle: "padding: 20px 10px 20px 10px",
            defaults: {
                anchor: "100%",
                allowBlank:false
            },
            items: [
                {
                    columnWidth:.6,
                    layout: 'form',
                    border:false,
                    items: [
                        {
                            xtype:'fieldset',
                            border:false,
                            title: _("Document description"),
                            autoHeight:true,
                            defaults: {
                                anchor: "95%"
                            },
                            defaultType: 'textfield',
                            items :[
                                {
                                    fieldLabel: _("Title"),
                                    name: 'title',
                                    allowBlank:false
                                },
                                {
                                    fieldLabel: _("Author"),
                                    name: 'author'
                                },
                                {
                                    xtype: 'numberfield',
                                    fieldLabel: _("Size"),
                                    name: 'size',
                                    allowDecimals: false,
                                    allowNegative: false
                                },
                                {
                                    xtype: "textarea",
                                    fieldLabel: _("Comment"),
                                    name: 'comment'
                                }
                            ]
                        }
                    ]
                },
                {
                    columnWidth:.4,
                    layout: 'form',
                    border:false,
                    items: [
                        {
                            xtype:'fieldset',
                            border:false,
                            title: _("Tracking"),
                            defaults: {
                                anchor: "100%"
                            },
                            defaultType: 'textfield',
                            items :[

                                xc.getConfig("/documents/combos/editions/", {
                                    allowBlank:false,
                                    listeners: {
                                        scope: this,
                                        beforequery: function(qe) {
                                            delete qe.combo.lastQuery;
                                        }
                                    }
                                }),

                                xc.getConfig("/documents/combos/stages/", {
                                    disabled: true,
                                    allowBlank:false,
                                    listeners: {
                                        scope: this,
                                        render: function(combo) {
                                            this.getForm().findField("edition").on("select", function() {
                                                combo.enable();
                                                combo.reset();
                                                combo.getStore().baseParams["flt_edition"] = this.getForm().findField("edition").getValue();
                                            }, this);
                                        },
                                        beforequery: function(qe) {
                                            delete qe.combo.lastQuery;
                                        }
                                    }
                                }),

                                xc.getConfig("/documents/combos/assignments/", {
                                    disabled: true,
                                    allowBlank:false,
                                    listeners: {
                                        scope: this,
                                        render: function(combo) {
                                            this.getForm().findField("edition").on("select", function() {
                                                combo.disable();
                                                combo.reset();
                                            }, this);
                                            this.getForm().findField("stage").on("select", function() {
                                                combo.enable();
                                                combo.reset();
                                                combo.getStore().baseParams["flt_stage"] = this.getForm().findField("stage").getValue();
                                            }, this);
                                        },
                                        beforequery: function(qe) {
                                            delete qe.combo.lastQuery;
                                        }
                                    }
                                })

                            ]
                        },
                        {
                            xtype:'fieldset',
                            border:false,
                            title: _("Publication"),
                            defaults: {
                                anchor: "100%"
                            },
                            //autoHeight:true,
                            items :[

                                {
                                    xtype: 'xdatefield',
                                    name: 'enddate',
                                    format:'F j, Y',
                                    submitFormat:'Y-m-d',
                                    minValue: new Date(),
                                    allowBlank:false,
                                    fieldLabel: _("Date")
                                },

                                xc.getConfig("/documents/combos/fascicles/", {
                                    disabled: true,
                                    listeners: {
                                        scope: this,
                                        render: function(combo) {
                                            this.getForm().findField("edition").on("select", function() {
                                                combo.enable();
                                                combo.reset();
                                                combo.getStore().baseParams["flt_edition"] = this.getForm().findField("edition").getValue();
                                            }, this);
                                        },
                                        beforequery: function(qe) {
                                            delete qe.combo.lastQuery;
                                        }
                                    }
                                }),

                                xc.getConfig("/documents/combos/headlines/", {
                                    disabled: true,
                                    listeners: {
                                        scope: this,
                                        render: function(combo) {
                                            this.getForm().findField("edition").on("select", function() {
                                                combo.disable();
                                                combo.reset();
                                            }, this);
                                            this.getForm().findField("fascicle").on("select", function() {
                                                combo.enable();
                                                combo.reset();
                                                combo.getStore().baseParams["flt_fascicle"] = this.getForm().findField("fascicle").getValue();
                                            }, this);
                                        },
                                        beforequery: function(qe) {
                                            delete qe.combo.lastQuery;
                                        }
                                    }
                                }),

                                xc.getConfig("/documents/combos/rubrics/", {
                                    disabled: true,
                                    listeners: {
                                        scope: this,
                                        render: function(combo) {
                                            this.getForm().findField("edition").on("select", function() {
                                                combo.disable();
                                                combo.reset();
                                            }, this);
                                            this.getForm().findField("fascicle").on("select", function() {
                                                combo.disable();
                                                combo.reset();
                                            }, this);
                                            this.getForm().findField("headline").on("select", function() {
                                                combo.enable();
                                                combo.reset();
                                                combo.getStore().baseParams["flt_headline"] = this.getForm().findField("headline").getValue();
                                            }, this);
                                        },
                                        beforequery: function(qe) {
                                            delete qe.combo.lastQuery;
                                        }
                                    }
                                })

                            ]
                        }
                    ]
                }
            ]
        });

        Inprint.cmp.CreateDocument.Form.superclass.initComponent.apply(this, arguments);

        this.getForm().url = this.url;

    },

    onRender: function() {
        Inprint.cmp.CreateDocument.Form.superclass.onRender.apply(this, arguments);
    }

});
