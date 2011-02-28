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
                                value: _("Type")
                            },

                            {
                                xtype: "combo",
                                hiddenName: "type",
                                allowBlank:false,
                                fieldLabel: _("Type"),
                                store: new Ext.data.ArrayStore({
                                    fields: ['id', 'shortcut'],
                                    data : [
                                        ['issue', _("Issue")],
                                        ['attachment', _("Attachment")],
                                        ['template', _("Template")],
                                    ]
                                }),
                                valueField: "id",
                                displayField: "shortcut",
                                editable: false,
                                typeAhead: true,
                                mode: 'local',
                                forceSelection: true,
                                triggerAction: 'all',
                                emptyText: _("Select a type") + "...",
                                selectOnFocus:true,
                                listeners: {
                                    scope:this,
                                    select: function (combo, record, indx) {

                                        var parent = this.getForm().findField("parent");
                                        parent.reset();
                                        parent.disable();

                                        if (record.get("id") == "issue") {

                                            this.getForm().findField("shortcut").allowBlank = true;

                                            this.getForm().findField("pnum").enable();
                                            this.getForm().findField("anum").enable();

                                            this.getForm().findField("circulation").enable();
                                            this.getForm().findField("template").enable();

                                            this.getForm().findField("dateprint").enable();
                                            this.getForm().findField("dateout").enable();

                                            this.getForm().findField("dateadv").enable();
                                            this.getForm().findField("datedoc").enable();

                                            this.getForm().findField("flagdocgroup").enable();
                                            this.getForm().findField("flagadvgroup").enable();

                                        }

                                        if (record.get("id") == "attachment") {

                                            this.getForm().findField("parent").enable();

                                            this.getForm().findField("shortcut").disable();
                                            this.getForm().findField("description").disable();

                                            this.getForm().findField("pnum").disable();
                                            this.getForm().findField("anum").disable();

                                            this.getForm().findField("circulation").enable();
                                            this.getForm().findField("template").enable();

                                            this.getForm().findField("dateprint").disable();
                                            this.getForm().findField("dateout").disable();

                                            this.getForm().findField("dateadv").disable();
                                            this.getForm().findField("datedoc").disable();

                                            this.getForm().findField("flagdocgroup").disable();
                                            this.getForm().findField("flagadvgroup").disable();
                                        }

                                        if (record.get("id") == "template") {

                                            this.getForm().findField("shortcut").allowBlank = false;

                                            this.getForm().findField("pnum").disable();
                                            this.getForm().findField("anum").disable();

                                            this.getForm().findField("circulation").disable();
                                            this.getForm().findField("template").disable();

                                            this.getForm().findField("dateprint").disable();
                                            this.getForm().findField("dateout").disable();

                                            this.getForm().findField("dateadv").disable();
                                            this.getForm().findField("datedoc").disable();

                                            this.getForm().findField("flagdocgroup").disable();
                                            this.getForm().findField("flagadvgroup").disable();

                                        }

                                    }
                                }
                            },

                            Inprint.factory.Combo.create(
                                "/calendar/combos/parents/",
                                {
                                    name: "parent",
                                    allowBlank:false,
                                    disabled: true,
                                    listeners: {
                                        scope: this,
                                        beforequery: function(qe) {
                                            delete qe.combo.lastQuery;
                                        }
                                    }
                                }
                            ),

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
                                    name: "source",
                                    listeners: {
                                        //render: function(combo) {
                                        //    combo.setValue("00000000-0000-0000-0000-000000000000", _("Defaults"));
                                        //},
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
                                name: "flagdocgroup",
                                fieldLabel: _("Documents"),
                                items: [
                                    { boxLabel: _("By date"),  name: "flagdoc", inputValue: "bydate", checked: true },
                                    { boxLabel: _("Enabled"),  name: "flagdoc", inputValue: "enabled" },
                                    { boxLabel: _("Disabled"), name: "flagdoc", inputValue: "disabled" },
                                ]
                            },

                            {
                                xtype: "radiogroup",
                                name: "flagadvgroup",
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

    onActivate: function() {

        Inprint.calendar.forms.Create.superclass.onActivate.apply(this, arguments);
        alert(1);
    },

    onRender: function() {

        Inprint.calendar.forms.Create.superclass.onRender.apply(this, arguments);
    }

});
