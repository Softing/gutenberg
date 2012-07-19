Inprint.calendar.forms.CreateTemplateForm = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.items = [

            {
                allowBlank:false,
                xtype: "treecombo",
                name: "edition-shortcut",
                hiddenName: "edition",
                fieldLabel: _("Edition"),
                emptyText: _("Edition") + "...",
                minListWidth: 300,
                url: _url('/common/tree/editions/'),
                baseParams: {
                    term: 'editions.fascicle.manage:*'
                },
                root: {
                    id:'00000000-0000-0000-0000-000000000000',
                    nodeType: 'async',
                    expanded: true,
                    draggable: false,
                    icon: _ico("book"),
                    text: _("All editions")
                },
                listeners: {
                    scope: this,
                    render: function(field) {
                        var id = Inprint.session.options["default.edition"];
                        var title = Inprint.session.options["default.edition.name"] || _("Unknown edition");
                        if (id && title) {
                            field.setValue(id, title);
                        }
                    }
                }
            },

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

        Inprint.calendar.forms.CreateTemplateForm.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.forms.CreateTemplateForm.superclass.onRender.apply(this, arguments);
        this.getForm().url = _source("template.create");
    },

    setEdition: function(id) {
        this.cmpSetValue("edition", id);
    }

});
