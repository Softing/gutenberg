Inprint.calendar.forms.AttachmentUpdate = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.items = [

            _FLD_HDN_ID,

            {
                xtype: "textfield",
                name: "shortcut",
                allowBlank:false,
                fieldLabel: _("Shortcut")
            },
            {
                xtype: "numberfield",
                name: "circulation",
                fieldLabel: _("Circulation"),
                value: 0
            }

        ];

        Ext.apply(this,  {
            baseCls: 'x-plain',
            defaults:{ anchor:'98%' }
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
