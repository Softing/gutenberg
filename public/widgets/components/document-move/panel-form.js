Inprint.cmp.MoveDocument.Form = Ext.extend(Ext.FormPanel, {
    initComponent: function() {

        var xc = Inprint.factory.Combo;

        Ext.apply(this, {
            url: _url("/documents/create/"),
            border:false,
            autoScroll:true,
            labelWidth: 80,
            bodyStyle: "padding: 10px 10px",
            defaults: {
                anchor: "100%",
                allowBlank:false
            },
            items: [

                {
                    xtype: 'fieldset',
                    title: _("Fascicles"),
                    autoHeight: true,
                    items: [

                        xc.getConfig("/documents/combos/editions/", {
                            allowBlank:false,
                            listeners: {
                                scope: this,
                                render: function(combo) {
                                    if (this.initialValues.edition) {
                                        combo.loadValue(this.initialValues.edition);
                                    }
                                },
                                beforequery: function(qe) {
                                    delete qe.combo.lastQuery;
                                }
                            }
                        }),

                        xc.getConfig("/documents/combos/fascicles/", {
                            disabled: true,
                            listeners: {
                                scope: this,
                                render: function(combo) {

                                    if (this.initialValues.edition, this.initialValues.fascicle) {
                                        combo.loadValue(this.initialValues.fascicle, {
                                            flt_edition: this.initialValues.edition
                                        });
                                        combo.enable();
                                    }

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

                    ]
                },

                {
                    xtype: 'fieldset',
                    title: _("Rubrication"),
                    autoHeight: true,
                    items: [
                        {
                            xtype: 'radiogroup',
                            fieldLabel: 'Рубрикация',
                            columns: 1,
                            items: [
                                {boxLabel: 'Оставить рубрику', name: 'ch-rub', inputValue: "no", checked: true},
                                {boxLabel: 'Заменить рубрику', name: 'ch-rub', inputValue: "yes"}
                            ],
                            listeners: {
                                scope: this,
                                change: function(group, radio) {
                                    var value = radio.getGroupValue();
                                    if (value == "yes") {
                                        this.getForm().findField("headline").enable();
                                        this.getForm().findField("headline").reset();
                                        this.getForm().findField("rubric").reset();
                                    }
                                    if (value == "no") {
                                        this.getForm().findField("headline").disable();
                                        this.getForm().findField("headline").reset();
                                        this.getForm().findField("rubric").disable();
                                        this.getForm().findField("rubric").reset();

                                        if (this.initialValues.fascicle, this.initialValues.headline) {
                                            this.getForm().findField("headline").loadValue(this.initialValues.headline, {
                                                flt_fascicle: this.initialValues.fascicle
                                            });
                                        }

                                        if (this.initialValues.headline, this.initialValues.rubric) {
                                            this.getForm().findField("rubric").loadValue(this.initialValues.rubric, {
                                                flt_headline: this.initialValues.headline
                                            });
                                        }

                                    }
                                }
                            }
                        },

                        xc.getConfig("/documents/combos/headlines/", {
                            disabled: true,
                            listeners: {
                                scope: this,
                                render: function(combo) {

                                    if (this.initialValues.fascicle, this.initialValues.headline) {
                                        combo.loadValue(this.initialValues.headline, {
                                            flt_fascicle: this.initialValues.fascicle
                                        });
                                    }

                                    //this.getForm().findField("edition").on("select", function() {
                                    //    combo.disable();
                                    //    combo.reset();
                                    //}, this);

                                    //this.getForm().findField("fascicle").on("select", function() {
                                    //    combo.enable();
                                    //    combo.reset();
                                    //    combo.getStore().baseParams["flt_fascicle"] = this.getForm().findField("fascicle").getValue();
                                    //}, this);
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

                                    if (this.initialValues.headline, this.initialValues.rubric) {
                                        combo.loadValue(this.initialValues.rubric, {
                                            flt_headline: this.initialValues.headline
                                        });
                                    }

                                    //this.getForm().findField("edition").on("select", function() {
                                    //    combo.disable();
                                    //    combo.reset();
                                    //}, this);
                                    //this.getForm().findField("fascicle").on("select", function() {
                                    //    combo.disable();
                                    //    combo.reset();
                                    //}, this);
                                    //this.getForm().findField("headline").on("select", function() {
                                    //    combo.enable();
                                    //    combo.reset();
                                    //    combo.getStore().baseParams["flt_headline"] = this.getForm().findField("headline").getValue();
                                    //}, this);
                                },
                                beforequery: function(qe) {
                                    delete qe.combo.lastQuery;
                                }
                            }
                        })

                    ]
                },

            ]
        });

        Inprint.cmp.MoveDocument.Form.superclass.initComponent.apply(this, arguments);

        this.getForm().url = this.url;

    },

    onRender: function() {
        Inprint.cmp.MoveDocument.Form.superclass.onRender.apply(this, arguments);
    }

});
