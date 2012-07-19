Inprint.calendar.forms.AttachmentRestrictions = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.items = [

            _FLD_HDN_ID,

            {
                labelWidth: 20,
                xtype: "xdatetime",
                name: "doc_date",
                format: "F j, Y",
                fieldLabel: _("Documents")
            },
            {
                xtype: 'xdatetime',
                name: 'adv_date',
                format:'F j, Y',
                fieldLabel: _("Advertisement")
            },
            {
                xtype: "numberfield",
                name: "adv_modules",
                fieldLabel: _("Modules")
            }

        ];

        Ext.apply(this,  {
            baseCls: 'x-plain',
            defaults:{ anchor:'98%' }
        });

        Inprint.calendar.forms.AttachmentRestrictions.superclass.initComponent.apply(this, arguments);
        this.getForm().url = _source("attachment.restrictions");
    },


    onRender: function() {
        Inprint.calendar.forms.AttachmentRestrictions.superclass.onRender.apply(this, arguments);
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
