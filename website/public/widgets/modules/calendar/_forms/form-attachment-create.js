Inprint.calendar.forms.AttachmentCreate = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.items = [

            {
                xtype: "hidden",
                name: "parent",
                value: this.issue,
                allowBlank:false
            },

            {
                xtype: "treecombo",
                hiddenName: "edition",
                fieldLabel: _("Edition"),
                emptyText: _("Edition") + "...",
                url: _url('/common/tree/editions/'),
                baseParams: { term: 'editions.attachment.manage:*' },
                minListWidth: 300,
                root: {
                    id: this.edition,
                    nodeType: 'async',
                    expanded: true
                }
            },

            Inprint.factory.Combo.create(
                "/calendar/combos/templates/", {
                    fieldLabel: _("Template"),
                    name: "source"
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
    }

});
