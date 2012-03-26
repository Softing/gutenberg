Inprint.calendar.forms.FormatForm = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.url = _source("calendar.format");

        this.items = [

            _FLD_HDN_ID,

            Inprint.factory.Combo.create(
                "/calendar/combos/templates/",
                {
                    allowBlank:false,
                    listeners: {
                        scope: this,
                        beforequery: function(qe) {
                            delete qe.combo.lastQuery;
                        }
                    }
                }
            ),

            {
                xtype: "checkbox",
                fieldLabel: _("Confirmation"),
                boxLabel: _("I understand the risk"),
                name: "confirmation"
            }

        ];

        Ext.apply(this,  {
            border:false,
            baseCls: "x-plain",
            bodyStyle: "padding:10px",
            defaults: { anchor: "100%" }
        });

        Inprint.calendar.forms.FormatForm.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.forms.FormatForm.superclass.onRender.apply(this, arguments);
        this.getForm().url = this.url;
    },

    setId: function(id) {
        this.cmpSetValue("id", id);
    }

});
