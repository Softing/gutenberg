Inprint.calendar.fascicles.Format = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.items = [

            _FLD_HDN_ID,

            Inprint.factory.Combo.create(
                "/calendar/combos/parents/",
                {
                    name: "parent",
                    title: _("Issue"),
                    allowBlank:false,
                    listeners: {
                        scope: this,
                        beforequery: function(qe) {
                            delete qe.combo.lastQuery;
                        }
                    }
                }
            )

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
        this.getForm().url = _source("fascicle.update");
    },

    cmpFill: function (id) {
        this.load({
            scope:this,
            params: { id: id },
            url: _source("fascicle.read"),
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });
    }

});
