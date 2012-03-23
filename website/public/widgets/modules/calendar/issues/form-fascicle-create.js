//Inprint.calendar.issues.CreateFascicleForm = Ext.extend( Ext.form.FormPanel,
//{
//
//    initComponent: function()
//    {
//
//        this.items = [
//
//            _FLD_HDN_EDITION,
//
//            {
//                layout:'column',
//                baseCls: 'x-plain',
//                items:[
//                    {
//                        border:false,
//                        columnWidth:.58,
//                        layout: 'form',
//                        baseCls: 'x-plain',
//                        defaults:{ anchor:'98%' },
//                        items: [
//
//                            {
//                                xtype: "titlefield",
//                                value: _("Basic parameters")
//                            },
//
//                            {
//                                xtype: "textfield",
//                                name: "shortcut",
//                                allowBlank:false,
//                                fieldLabel: _("Shortcut")
//                            },
//                            {
//                                xtype: "textfield",
//                                name: "description",
//                                fieldLabel: _("Description")
//                            },
//
//                            Inprint.factory.Combo.create(
//                                "/calendar/combos/copyfrom/", {
//                                    fieldLabel: _("Copy from"),
//                                    name: "source",
//                                    listeners: {
//                                        render: function(combo) {
//                                            combo.setValue("00000000-0000-0000-0000-000000000000", _("Defaults"));
//                                        },
//                                        beforequery: function(qe) {
//                                            delete qe.combo.lastQuery;
//                                        }
//                                    }
//                            }),
//
//                            {
//                                xtype: "textfield",
//                                name: "num",
//                                fieldLabel: _("Number")
//                            },
//                            {
//                                xtype: "textfield",
//                                name: "anum",
//                                fieldLabel: _("Annual number")
//                            },
//
//                            {
//                                xtype: "numberfield",
//                                name: "circulation",
//                                fieldLabel: _("Circulation"),
//                                value: 0
//                            }
//
//                        ]
//                    },
//
//                    {
//                        border:false,
//                        columnWidth:.42,
//                        layout: 'form',
//                        baseCls: 'x-plain',
//                        defaults:{ anchor:'100%' },
//                        items: [
//
//                            {
//                                xtype: "titlefield",
//                                value: _("Deadline")
//                            },
//
//                            {
//                                format:'F j, Y',
//                                name: 'print_date',
//                                xtype: 'xdatefield',
//                                submitFormat:'Y-m-d',
//                                fieldLabel: _("Printing shop")
//                            },
//                            {
//                                xtype: 'xdatefield',
//                                name: 'release_date',
//                                format:'F j, Y',
//                                submitFormat:'Y-m-d',
//                                fieldLabel: _("Publication")
//                            },
//
//                            {
//                                labelWidth: 20,
//                                xtype: "xdatetime",
//                                name: "doc_date",
//                                format: "F j, Y",
//                                //submitFormat: "Y-m-d",
//                                fieldLabel: _("Documents")
//                            },
//                            {
//                                xtype: "checkbox",
//                                name: "doc_enabled",
//                                checked: true,
//                                fieldLabel: "",
//                                boxLabel: _("Enabled")
//                            },
//
//                            {
//                                xtype: "spacerfield"
//                            },
//
//                            {
//                                xtype: 'xdatetime',
//                                name: 'adv_date',
//                                format:'F j, Y',
//                                //submitFormat:'Y-m-d',
//                                fieldLabel: _("Advertisement")
//                            },
//                            {
//                                xtype: "checkbox",
//                                name: "adv_enabled",
//                                checked: true,
//                                fieldLabel: "",
//                                boxLabel: _("Enabled")
//                            }
//
//                        ]
//                    }
//
//                ]
//            }
//
//        ];
//
//        Ext.apply(this,  {
//            baseCls: 'x-plain'
//        });
//
//        Inprint.calendar.issues.CreateFascicleForm.superclass.initComponent.apply(this, arguments);
//    },
//
//    onRender: function() {
//        Inprint.calendar.issues.CreateFascicleForm.superclass.onRender.apply(this, arguments);
//
//        this.getForm().url = _source("fascicle.create");
//
//        this.getForm().findField("print_date").on("select", function(field, date){
//                this.getForm().findField("shortcut").setValue(
//                    date.format("d/m/y")
//                );
//            }, this)
//    }
//
//});
