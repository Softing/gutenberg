Inprint.cmp.MoveDocument.Form = Ext.extend(Ext.FormPanel, {
    initComponent: function() {

        var xc = Inprint.factory.Combo;

        Ext.apply(this, {
            url: _url("/documents/move/"),
            border:false,
            autoScroll:true,
            labelWidth: 80,
            bodyStyle: "padding: 10px 10px",
            items: [
                {
                    xtype: 'fieldset',
                    title: _("Fascicles"),
                    autoHeight: true,
                    defaults: {
                        anchor: "100%",
                        allowBlank:false
                    },
                    items: [

                        {
                            columnWidth: .125,
                            xtype: "treecombo",
                            hiddenName: "edition",
                            fieldLabel: _("Edition"),
                            emptyText: _("Edition") + "...",
                            minListWidth: 250,
                            url: _url('/documents/trees/editions/'),
                            baseParams: {
                                term: 'editions.documents.work'
                            },
                            rootVisible:true,
                            root: {
                                id:'00000000-0000-0000-0000-000000000000',
                                nodeType: 'async',
                                expanded: true,
                                draggable: false,
                                icon: _ico("book"),
                                text: _("All editions")
                            },
                            listeners: {
                                scope: this,
                                render: function(field) {
                                    var id = Inprint.session.options["default.edition"];
                                    var title = Inprint.session.options["default.edition.name"] || _("Unknown edition");
                                    if (id && title) {
                                        field.setValue(id, title);
                                    }
                                    this.getForm().findField("fascicle").enable();
                                },
                                select: function(field) {
                                    this.getForm().findField("fascicle").enable();
                                    this.getForm().findField("fascicle").reset();
                                }
                            }
                        },

                        xc.getConfig("/documents/combos/fascicles/", {
                            disabled: true,
                            baseParams: { term: 'editions.documents.assign' },
                            listeners: {
                                scope: this,
                                render: function(combo) {

                                    this.getForm().findField("edition").on("select", function() {
                                        combo.enable();
                                        combo.reset();
                                    }, this);

                                },
                                beforequery: function(qe) {
                                    delete qe.combo.lastQuery;
                                    qe.combo.getStore().baseParams.flt_edition  = this.getForm().findField("edition").getValue();
                                }
                            }
                        })

                    ]
                },

                {
                    xtype: 'fieldset',
                    title: _("Rubrication"),
                    autoHeight: true,
                    defaults: {
                        anchor: "100%",
                        allowBlank:false
                    },
                    items: [
                        {
                            xtype: 'radiogroup',
                            fieldLabel: 'Рубрикация',
                            columns: 1,
                            items: [
                                {boxLabel: 'Оставить рубрику', name: 'ch-rub', inputValue: "no", checked: true},
                                {boxLabel: 'Заменить на рубрику', name: 'ch-rub', inputValue: "yes"}
                            ],
                            listeners: {
                                scope: this,
                                change: function(group, radio) {
                                    var value = radio.getGroupValue();

                                    var edition  = this.getForm().findField("edition").getValue();
                                    var fascicle = this.getForm().findField("fascicle").getValue();

                                    if (value == "yes") {

                                        if (edition && fascicle) {
                                            this.getForm().findField("headline").enable();
                                        }

                                        this.getForm().findField("headline").reset();
                                        this.getForm().findField("rubric").reset();
                                    }

                                    if (value == "no") {
                                        this.getForm().findField("headline").reset();
                                        this.getForm().findField("rubric").reset();
                                        this.getForm().findField("headline").disable();
                                        this.getForm().findField("rubric").disable();
                                    }
                                }
                            }
                        },

                        xc.getConfig("/documents/combos/headlines/", {
                            disabled: true,
                            listeners: {
                                scope: this,
                                render: function(combo) {
                                    this.getForm().findField("fascicle").on("select", function() {
                                        combo.reset();
                                        combo.getStore().baseParams.flt_edition = this.getForm().findField("edition").getValue();
                                        combo.getStore().baseParams.flt_fascicle = this.getForm().findField("fascicle").getValue();
                                    }, this);
                                },
                                beforequery: function(qe) {
                                    delete qe.combo.lastQuery;
                                    qe.combo.getStore().baseParams.flt_edition = this.getForm().findField("edition").getValue();
                                    qe.combo.getStore().baseParams.flt_fascicle = this.getForm().findField("fascicle").getValue();
                                }
                            }
                        }),

                        xc.getConfig("/documents/combos/rubrics/", {
                            disabled: true,
                            listeners: {
                                scope: this,
                                render: function(combo) {
                                    this.getForm().findField("headline").on("select", function() {
                                        combo.enable();
                                        combo.reset();
                                    }, this);
                                },
                                beforequery: function(qe) {
                                    delete qe.combo.lastQuery;
                                    qe.combo.getStore().baseParams.flt_edition = this.getForm().findField("edition").getValue();
                                    qe.combo.getStore().baseParams.flt_fascicle = this.getForm().findField("fascicle").getValue();
                                    qe.combo.getStore().baseParams.flt_headline = this.getForm().findField("headline").getValue();

                                }
                            }
                        })

                    ]
                }

            ]
        });

        Inprint.cmp.MoveDocument.Form.superclass.initComponent.apply(this, arguments);
        this.getForm().url = this.url;
    },

    onRender: function() {
        Inprint.cmp.MoveDocument.Form.superclass.onRender.apply(this, arguments);
    }

});
