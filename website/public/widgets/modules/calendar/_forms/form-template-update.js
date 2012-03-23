Inprint.calendar.forms.TemplateUpdate = Ext.extend( Ext.form.FormPanel,
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
                xtype: "textfield",
                name: "description",
                fieldLabel: _("Description")
            },

        ];

        Ext.apply(this,  {
            baseCls: 'x-plain',
            defaults:{ anchor:'100%' }
        });

        Inprint.calendar.forms.TemplateUpdate.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.forms.TemplateUpdate.superclass.onRender.apply(this, arguments);
        this.getForm().url = _source("template.update");
    },

    setId: function(id) {
        this.cmpSetValue("id", id);
    },

    cmpFill: function (id) {
        this.load({

            scope:this,
            params: { id: id },
            url: _source("template.read"),

            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }

        });
    }

});
