Inprint.cmp.UpdateDocument.Form = Ext.extend(Ext.FormPanel, {

    initComponent: function() {

        this.edition = null;
        this.fascicle = null;

        var xc = Inprint.factory.Combo;

        Ext.apply(this, {
            url: _url("/documents/update/"),
            border:false,
            autoScroll:true,
            labelWidth: 80,
            bodyStyle: "padding: 10px",
            defaults: {
                anchor: "100%"
            },
            items: [

                _FLD_HDN_ID,

                {
                    xtype: "titlefield",
                    value: _("Basic options")
                },
                {
                    xtype: 'textarea',
                    fieldLabel: _("Title"),
                    name: 'title',
                    allowBlank:false
                },
                {
                    xtype: 'textfield',
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
                    xtype: 'xdatefield',
                    name: 'enddate',
                    format:'F j, Y',
                    altFormats: 'c',
                    submitFormat:'Y-m-d',
                    //minValue: new Date(),
                    allowBlank:false,
                    fieldLabel: _("Delivery date")
                },

                {
                    xtype: "titlefield",
                    value: _("Appointment"),
                    style: "margin-top:10px;"
                },

                {
                    disabled: true,
                    xtype: "treecombo",
                    name: "maingroup-shortcut",
                    hiddenName: "maingroup",
                    fieldLabel: _("Department"),
                    emptyText: _("Department") + "...",
                    minListWidth: 250,
                    url: _url('/documents/trees/workgroups/'),
                    baseParams: {
                        term: 'catalog.documents.view:*'
                    },
                    root: {
                        id:'00000000-0000-0000-0000-000000000000',
                        nodeType: 'async',
                        expanded: true,
                        draggable: false,
                        icon: _ico("folder-open"),
                        text: _("All departments")
                    },
                    listeners: {
                        scope: this,
                        select: function(field) {
                            this.getForm().findField("manager").resetValue();
                        },
                        render: function(field) {
                            //var id = Inprint.session.options["default.workgroup"];
                            //var title = Inprint.session.options["default.workgroup.name"] || _("Unknown department");
                            //if (id && title) field.setValue(id, title);
                        }
                    }
                },


                // Assign
                xc.getConfig("/documents/combos/managers/", {
                    disabled: true,
                    listeners: {
                        scope: this,
                        render: function(field) {
                            //var id = Inprint.session.member["id"];
                            //var title = Inprint.session.member["title"] || _("Unknown employee");
                            //if (id && title) field.setValue(id, title);
                        },
                        beforequery: function(qe) {
                            delete qe.combo.lastQuery;
                            qe.combo.getStore().baseParams["term"] = "catalog.documents.create:*";
                            qe.combo.getStore().baseParams["workgroup"] = this.getForm().findField("workgroup").getValue();
                        }
                    }
                }),

                {
                    xtype: "titlefield",
                    value: _("Indexation"),
                    style: "margin-top:10px;"
                },

                // Rubrication
                xc.getConfig("/documents/combos/headlines/", {
                    disabled: false,
                    listeners: {
                        scope: this,
                        beforequery: function(qe) {
                            delete qe.combo.lastQuery;
                            qe.combo.getStore().baseParams["flt_edition"]  = this.edition;
                            qe.combo.getStore().baseParams["flt_fascicle"] = this.fascicle;
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
                                combo.resetValue();
                            }, this);
                        },
                        beforequery: function(qe) {
                            delete qe.combo.lastQuery;
                            qe.combo.getStore().baseParams["flt_edition"]  = this.edition;
                            qe.combo.getStore().baseParams["flt_fascicle"] = this.fascicle;
                            qe.combo.getStore().baseParams["flt_headline"] = this.getForm().findField("headline").getValue();
                        }
                    }
                })

            ]
        });

        Inprint.cmp.UpdateDocument.Form.superclass.initComponent.apply(this, arguments);
        this.getForm().url = this.url;
    },

    onRender: function() {
        Inprint.cmp.UpdateDocument.Form.superclass.onRender.apply(this, arguments);
    }

});
