Inprint.calendar.forms.AttachmentCreate = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.items = [

            _FLD_HDN_PARENT,

            Inprint.factory.Combo.create(
                "/calendar/combos/templates/", {
                    fieldLabel: _("Template"),
                    name: "source",
                    listeners: {
                        beforequery: function(qe) {
                            delete qe.combo.lastQuery;
                        }
                    }
            }),

            {
                xtype: "numberfield",
                name: "circulation",
                fieldLabel: _("Circulation"),
                value: 0
            }

        ];

        Ext.apply(this,  {
            baseCls: 'x-plain',
            defaults:{ anchor:'100%' }
        });

        Inprint.calendar.forms.AttachmentCreate.superclass.initComponent.apply(this, arguments);
        this.getForm().url = _source("attachment.create");
    },

    onRender: function() {
        Inprint.calendar.forms.AttachmentCreate.superclass.onRender.apply(this, arguments);
    },

    setParent: function(id) {
        this.cmpSetValue("parent", id);
    }

});
