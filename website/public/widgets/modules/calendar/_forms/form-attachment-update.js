Inprint.calendar.forms.AttachmentUpdate = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.items = [

            _FLD_HDN_ID,

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

            {
                xtype: "titlefield",
                value: _("Deadline"),
                margin: 10
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

        Inprint.calendar.forms.AttachmentUpdate.superclass.initComponent.apply(this, arguments);
        this.getForm().url = _source("attachment.update");
    },


    onRender: function() {
        Inprint.calendar.forms.AttachmentUpdate.superclass.onRender.apply(this, arguments);
    },

    cmpFill: function (id) {
        this.load({
            scope:this,
            params: { id: id },
            url: _source("attachment.read"),
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });
    }

});
