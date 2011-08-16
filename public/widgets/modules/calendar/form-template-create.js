Inprint.calendar.templates.Create = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.items = [

            _FLD_HDN_EDITION,

            {
                xtype: "textfield",
                name: "shortcut",
                allowBlank:false,
                fieldLabel: _("Shortcut")
            },

            {
                xtype: "textfield",
                name: "description",
                fieldLabel: _("Description")
            },

            Inprint.factory.Combo.create(
                "/calendar/combos/sources/", {
                    fieldLabel: _("Template"),
                    name: "source",
                    listeners: {
                        render: function(combo) {
                            combo.setValue("00000000-0000-0000-0000-000000000000", _("Defaults"));
                        },
                        beforequery: function(qe) {
                            delete qe.combo.lastQuery;
                        }
                    }
            }),

        ];

        Ext.apply(this,  {
            baseCls: 'x-plain'
        });

        Inprint.calendar.fascicles.Create.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.fascicles.Create.superclass.onRender.apply(this, arguments);
        this.getForm().url = _source("template.create");
    }

});
