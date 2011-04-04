Inprint.calendar.attachments.Create = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.items = [

            _FLD_HDN_PARENT,


            {
                xtype: "titlefield",
                value: _("Basic parameters")
            },

            Inprint.factory.Combo.create(
                "/calendar/combos/childrens/",
                {
                    name: "edition",
                    allowBlank:false,
                    listeners: {
                        scope: this,
                        beforequery: function(qe) {
                            delete qe.combo.lastQuery;
                            qe.combo.getStore().baseParams = {
                                parent: this.getForm().findField("parent").getValue()
                            }
                        }
                    }
                }
            ),

            {
                xtype: "titlefield",
                value: _("Additional parameters"),
                margin:10
            },

            {
                xtype: "numberfield",
                name: "circulation",
                fieldLabel: _("Circulation"),
                value: 0
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
                fieldLabel: "",
                boxLabel: _("Enabled")
            }

        ];

        Ext.apply(this,  {
            xtype: "form",
            border:false,
            layout: 'form',
            bodyStyle:'padding:10px',
            defaults:{
                anchor:'100%'
            }
        });

        Inprint.calendar.attachments.Create.superclass.initComponent.apply(this, arguments);
        this.getForm().url = _source("attachment.create");
    },


    onRender: function() {
        Inprint.calendar.attachments.Create.superclass.onRender.apply(this, arguments);
    }

});
