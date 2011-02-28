Inprint.calendar.forms.Create = Ext.extend( Ext.form.FormPanel,
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
                                value: _("Numbering")
                            },

                            {
                                xtype: "textfield",
                                name: "pnum",
                                fieldLabel: _("Prevailing")
                            },
                            {
                                xtype: "textfield",
                                name: "anum",
                                fieldLabel: _("Annual")
                            },

                            {
                                xtype: "titlefield",
                                value: _("Basic parameters")
                            },

                            {
                                xtype: "textfield",
                                name: "shortcut",
                                fieldLabel: _("Shortcut")
                            },
                            {
                                xtype: "textfield",
                                name: "description",
                                fieldLabel: _("Description")
                            },

                            {
                                xtype: "titlefield",
                                value: _("Additional parameters")
                            },

                            {
                                xtype: "numberfield",
                                name: "circulation",
                                fieldLabel: _("Circulation"),
                                value: 0
                            },

                            Inprint.factory.Combo.create(
                                "/calendar/combos/sources/", {
                                    fieldLabel: _("Template"),
                                    name: "layoutsource",
                                    listeners: {
                                        render: function(combo) {
                                            combo.setValue("00000000-0000-0000-0000-000000000000", _("Defaults"));
                                        },
                                        beforequery: function(qe) {
                                            delete qe.combo.lastQuery;
                                        }
                                    }
                            })

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
                                value: _("Dates")
                            },

                            {
                                xtype: 'xdatefield',
                                name: 'dateout',
                                format:'F j, Y',
                                submitFormat:'Y-m-d',
                                fieldLabel: _("Publication")
                            },
                            {
                                xtype: 'xdatefield',
                                name: 'dateprint',
                                format:'F j, Y',
                                submitFormat:'Y-m-d',
                                fieldLabel: _("Printing")
                            },

                            {
                                xtype: "titlefield",
                                value: _("Deadline")
                            },

                            {
                                labelWidth: 20,
                                xtype: "xdatefield",
                                name: "datedoc",
                                format: "F j, Y",
                                submitFormat: "Y-m-d",
                                allowBlank:false,
                                fieldLabel: _("Documents")
                            },
                            {
                                xtype: 'xdatefield',
                                name: 'dateadv',
                                format:'F j, Y',
                                submitFormat:'Y-m-d',
                                allowBlank:false,
                                fieldLabel: _("Advertisement")
                            },

                            {
                                xtype: "radiogroup",
                                fieldLabel: _("Documents"),
                                items: [
                                    { boxLabel: _("By date"),  name: "flagdoc", inputValue: "bydate", checked: true },
                                    { boxLabel: _("Enabled"),  name: "flagdoc", inputValue: "enabled" },
                                    { boxLabel: _("Disabled"), name: "flagdoc", inputValue: "disabled" },
                                ]
                            },

                            {
                                xtype: "radiogroup",
                                fieldLabel: _("Advertisement"),
                                items: [
                                    { boxLabel: _("By date"),  name: "flagadv", inputValue: "bydate", checked: true },
                                    { boxLabel: _("Enabled"),  name: "flagadv", inputValue: "enabled" },
                                    { boxLabel: _("Disabled"), name: "flagadv", inputValue: "disabled" },
                                ]
                            }

                        ]
                    }

                ]
            }
        ];

        Ext.apply(this,  {
            xtype: "form",
            border:false,
            labelWidth: 90
        });

        Inprint.calendar.forms.Create.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {

        Inprint.calendar.forms.Create.superclass.onRender.apply(this, arguments);

    }

});
