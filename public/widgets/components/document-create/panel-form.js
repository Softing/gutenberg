Inprint.cmp.CreateDocument.Form = Ext.extend(Ext.FormPanel, {
    initComponent: function() {

        this.access = {};
        var xc = Inprint.factory.Combo;

        Ext.apply(this, {
            url: _url("/documents/create/"),
            border:false,
            layout:'column',
            autoScroll:true,
            bodyStyle: "padding: 20px 10px 20px 10px",
            defaults: {
                anchor: "100%",
                allowBlank:false
            },
            items: [
                {
                    columnWidth:.55,
                    layout: 'form',
                    border:false,
                    labelWidth: 90,
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
                    columnWidth:.45,
                    layout: 'form',
                    border:false,
                    labelWidth: 80,
                    items: [
                        {
                            xtype:'fieldset',
                            border:false,
                            title: _("Appointment"),
                            defaults: {
                                anchor: "100%"
                            },
                            defaultType: 'textfield',
                            items :[
                                {
                                    allowBlank:false,
                                    xtype: "treecombo",
                                    name: "edition-shortcut",
                                    hiddenName: "edition",
                                    fieldLabel: _("Edition"),
                                    emptyText: _("Edition") + "...",
                                    minListWidth: 250,
                                    url: _url('/documents/trees/editions/'),
                                    baseParams: {
                                        term: 'editions.documents.work'
                                    },
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
                                        },
                                        select: function(field) {
                                            this.getForm().findField("fascicle").getTree().getRootNode().reload();
                                        }
                                    }
                                },

                                {
                                    disabled: true,
                                    xtype: "treecombo",
                                    name: "workgroup-shortcut",
                                    hiddenName: "workgroup",
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
                                            var id = Inprint.session.options["default.workgroup"];
                                            var title = Inprint.session.options["default.workgroup.name"] || _("Unknown department");
                                            if (id && title) {
                                                field.setValue(id, title);
                                            }
                                        }
                                    }
                                },

                                xc.getConfig("/documents/combos/managers/", {
                                    disabled: true,
                                    listeners: {
                                        scope: this,
                                        render: function(field) {
                                            var id = Inprint.session.member.id;
                                            var title = Inprint.session.member.title || _("Unknown employee");
                                            if (id && title) {
                                                field.setValue(id, title);
                                            }
                                        },
                                        beforequery: function(qe) {
                                            delete qe.combo.lastQuery;
                                            qe.combo.getStore().baseParams.term = "catalog.documents.create:*";
                                            qe.combo.getStore().baseParams.edition = this.getForm().findField("edition").getValue();
                                            qe.combo.getStore().baseParams.workgroup = this.getForm().findField("workgroup").getValue();
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

                                {
                                    columnWidth:.125,
                                    xtype: "treecombo",
                                    name: "fascicle-shortcut",
                                    hiddenName: "fascicle",
                                    fieldLabel: _("Fascicle"),
                                    emptyText: _("Fascicle") + "...",
                                    minListWidth: 250,
                                    url: _url('/documents/trees/fascicles/'),
                                    baseParams: {
                                        term: 'editions.documents.work'
                                    },
                                    root: {
                                        id: '00000000-0000-0000-0000-000000000000',
                                        nodeType: 'async',
                                        expanded: true,
                                        draggable: false,
                                        icon: _ico("blue-folder-open-document-text"),
                                        text: _("All fascicles")
                                    },
                                    listeners: {
                                        scope: this,
                                        render: function(field) {
                                            var id = '00000000-0000-0000-0000-000000000000';
                                            var title = _("Briefcase");
                                            if (id && title) {
                                                field.setValue(id, title);
                                            }
                                        }
                                    }
                                },

                                xc.getConfig("/documents/combos/headlines/", {
                                    disabled: false,
                                    listeners: {
                                        scope: this,
                                        render: function(field) {
                                            this.getForm().findField("edition").on("select", function() {
                                                this.getForm().findField("fascicle").setValue("00000000-0000-0000-0000-000000000000", _("Briefcase"));
                                                field.reset();
                                            }, this);
                                            this.getForm().findField("fascicle").on("select", function() {
                                                field.enable();
                                                field.reset();
                                            }, this);
                                        },
                                        beforequery: function(qe) {
                                            delete qe.combo.lastQuery;
                                            qe.combo.getStore().baseParams.flt_edition  = this.getForm().findField("edition").getValue();
                                            qe.combo.getStore().baseParams.flt_fascicle = this.getForm().findField("fascicle").getValue();
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
                                                combo.getStore().baseParams.flt_fascicle = this.getForm().findField("fascicle").getValue();
                                                combo.getStore().baseParams.flt_headline = this.getForm().findField("headline").getValue();
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
