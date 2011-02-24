Inprint.calendar.forms.Update = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.items = [

            _FLD_HDN_ID,
            _FLD_HDN_EDITION,
            _FLD_HDN_PARENT,

            {
                xtype: "titlefield",
                value: _("Basic parameters")
            },

            Inprint.factory.Combo.create(
            "/calendar/combos/editions/",
            {
                name: "copyfrom",
                listeners: {
                    beforequery: function(qe) {
                        delete qe.combo.lastQuery;
                    }
                }
            }),

            _FLD_SHORTCUT,
            _FLD_TITLE,
            _FLD_DESCRIPTION,

            {
                xtype: "titlefield",
                value: _("Deadline")
            },

            {
                xtype:"checkbox",
                fieldLabel: _("State"),
                boxLabel: _("Enabled"),
                checked: true,
                name: "enabled"
            },

            {
                xtype: "xdatefield",
                name: "deadline",
                format: "F j, Y",
                submitFormat: "Y-m-d",
                allowBlank:false,
                fieldLabel: _("Issue"),
                listeners: {
                    scope:this,
                    change: function(field, value, old)
                    {
                        var v = field.getValue();

                        var f1 = field.ownerCt.getForm().findField('title');
                        if (f1.getValue().length === 0) {
                            f1.setValue(v.dateFormat('j-M-y'));
                        }

                        var f2 = field.ownerCt.getForm().findField('shortcut');
                        if (f2.getValue().length === 0) {
                            f2.setValue(v.dateFormat('j-M-y'));
                        }
                    }
                }
            },
            {
                xtype: 'xdatefield',
                name: 'advertisement',
                format:'F j, Y',
                submitFormat:'Y-m-d',
                allowBlank:false,
                fieldLabel: _("Advertisement")
            },

            {
                xtype: "titlefield",
                value: _("Copy parameters")
            },

            Inprint.factory.Combo.create(
                "/calendar/combos/sources/",
                {
                    name: "copyfrom",
                    listeners: {
                        render: function(combo) {
                            combo.setValue("00000000-0000-0000-0000-000000000000", _("Defaults"));
                        },
                        beforequery: function(qe) {
                            delete qe.combo.lastQuery;
                        }
                    }
                })
        ];

        Ext.apply(this,  {
            xtype: "form",
            border:false,
            labelWidth: 100,
            bodyStyle: "padding:5px",
            defaults: {
                anchor: "100%"
            }
        });

        Inprint.calendar.forms.Update.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {

        Inprint.calendar.forms.Update.superclass.onRender.apply(this, arguments);

        this.on('actioncomplete', function(form, action) {
            if (action.type == "submit") {

            }
        }, this);

    }

});
