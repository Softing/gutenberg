Inprint.calendar.fascicles.Create = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.items = [

            _FLD_HDN_EDITION,

            {
                border:false,
                layout:'column',
                defaults:{
                    bodyStyle:'padding:10px'
                },
                items:[
                    {
                        border:false,
                        columnWidth:.5,
                        layout: 'form',
                        defaults:{
                            anchor:'100%'
                        },
                        items: [

                            {
                                xtype: "titlefield",
                                value: _("Basic parameters")
                            },

                            {
                                xtype: "textfield",
                                name: "shortcut",
                                allowBlank:false,
                                fieldLabel: _("Shortcut")
                            },
                            {
                                xtype: "textfield",
                                name: "description",
                                fieldLabel: _("Description")
                            },

                            Inprint.factory.Combo.create(
                                "/calendar/combos/sources/", {
                                    fieldLabel: _("Template"),
                                    name: "source",
                                    listeners: {
                                        render: function(combo) {
                                            combo.setValue("00000000-0000-0000-0000-000000000000", _("Defaults"));
                                        },
                                        beforequery: function(qe) {
                                            delete qe.combo.lastQuery;
                                        }
                                    }
                            }),

                            {
                                xtype: "titlefield",
                                value: _("Additional parameters"),
                                margin:10
                            },

                            {
                                xtype: "textfield",
                                name: "num",
                                fieldLabel: _("Number")
                            },
                            {
                                xtype: "textfield",
                                name: "anum",
                                fieldLabel: _("Annual number")
                            },

                            {
                                xtype: "numberfield",
                                name: "circulation",
                                fieldLabel: _("Circulation"),
                                value: 0
                            }

                        ]
                    },
                    {
                        border:false,
                        columnWidth:.5,
                        layout: 'form',
                        defaults:{
                            anchor:'100%'
                        },
                        items: [

                            {
                                xtype: "titlefield",
                                value: _("Key dates")
                            },

                            {
                                format:'F j, Y',
                                name: 'print_date',
                                xtype: 'xdatefield',
                                submitFormat:'Y-m-d',
                                fieldLabel: _("Printing shop")
                            },
                            {
                                xtype: 'xdatefield',
                                name: 'release_date',
                                format:'F j, Y',
                                submitFormat:'Y-m-d',
                                fieldLabel: _("Publication")
                            },

                            {
                                xtype: "titlefield",
                                value: _("Deadline"),
                                margin:10
                            },

                            {
                                labelWidth: 20,
                                xtype: "xdatetime",
                                name: "doc_date",
                                format: "F j, Y",
                                //submitFormat: "Y-m-d",
                                fieldLabel: _("Documents")
                            },
                            {
                                xtype: "checkbox",
                                name: "doc_enabled",
                                checked: true,
                                fieldLabel: "",
                                boxLabel: _("Enabled")
                            },

                            {
                                xtype: "spacerfield"
                            },

                            {
                                xtype: 'xdatetime',
                                name: 'adv_date',
                                format:'F j, Y',
                                //submitFormat:'Y-m-d',
                                fieldLabel: _("Advertisement")
                            },
                            {
                                xtype: "checkbox",
                                name: "adv_enabled",
                                checked: true,
                                fieldLabel: "",
                                boxLabel: _("Enabled")
                            }

                        ]
                    }

                ]
            }

        ];

        Ext.apply(this,  {
            xtype: "form",
            border:false
        });

        Inprint.calendar.fascicles.Create.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.fascicles.Create.superclass.onRender.apply(this, arguments);

        this.getForm().url = _source("fascicle.create");

        this.getForm().findField("print_date").on("select", function(field, date){
                this.getForm().findField("shortcut").setValue(
                    date.format("d/m/y")
                );
            }, this)
    }

});
