Inprint.calendar.forms.UpdateTemplateForm = Ext.extend( Ext.form.FormPanel, {

    initComponent: function() {

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
            
            {
                xtype: "numberfield",
                name: "adv_modules",
                fieldLabel: _("Modules")
            }

        ];

        Ext.apply(this,  {
            baseCls: 'x-plain',
            defaults:{ anchor:'100%' }
        });

        Inprint.calendar.forms.UpdateTemplateForm.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.forms.UpdateTemplateForm.superclass.onRender.apply(this, arguments);
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
