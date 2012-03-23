//Inprint.calendar.templates.CreateForm = Ext.extend( Ext.form.FormPanel,
//{
//
//    initComponent: function()
//    {
//
//        this.items = [
//
//            _FLD_HDN_EDITION,
//
//            {
//                xtype: "textfield",
//                name: "shortcut",
//                allowBlank:false,
//                fieldLabel: _("Shortcut")
//            },
//
//            {
//                xtype: "textfield",
//                name: "description",
//                fieldLabel: _("Description")
//            }
//
//        ];
//
//        Ext.apply(this,  {
//            baseCls: 'x-plain',
//            defaults:{ anchor:'100%' }
//        });
//
//        Inprint.calendar.templates.CreateForm.superclass.initComponent.apply(this, arguments);
//    },
//
//    onRender: function() {
//        Inprint.calendar.templates.CreateForm.superclass.onRender.apply(this, arguments);
//        this.getForm().url = _source("template.create");
//    },
//
//    setEdition: function(id) {
//        this.cmpSetValue("edition", id);
//    }
//
//});
