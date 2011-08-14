Inprint.calendar.fascicles.Format = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.url = _source("calendar.layout.format");

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
                xtype: 'checkbox',
                fieldLabel: _('Confirmation'),
                boxLabel: _('I understand the importance'),
                name: 'confirmation'
            }

        ];

        Ext.apply(this,  {
            xtype: "form",
            border:false,
            bodyStyle:'padding:10px',
            defaults: {
                anchor: '100%'
            }
        });

        Inprint.calendar.fascicles.Format.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.fascicles.Format.superclass.onRender.apply(this, arguments);
        this.getForm().url = this.url;
    }

});
