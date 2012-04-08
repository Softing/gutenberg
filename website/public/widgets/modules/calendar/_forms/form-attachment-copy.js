Inprint.calendar.forms.CopyAttachmentForm = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.items = [

            {
                xtype: "hidden",
                name: "source",
                allowBlank:false
            },

            {
                xtype: "treecombo",
                hiddenName: "issue",
                rootVisible:false,
                minListWidth: 300,
                fieldLabel: _("Fascicle"),
                emptyText: _("Fascicle"),
                url: _url('/common/tree/fascicles/'),
                root: { id:'all', nodeType: 'async' },
                baseParams: { attachments: 0, term: 'editions.fascicle.view:*' },
                listeners: {
                    scope: this,
                    select: function(combo, record) {
                        var attachment = this.getForm().findField("edition");
                        attachment.enable();
                        attachment.root.id = record.attributes.edition;
                        var root = attachment.getTree().getRootNode();
                        root.id = record.attributes.edition;
                        root.reload();

                    }
                }
            },

            {
                xtype: "treecombo",
                disabled:true,
                hiddenName: "edition",
                rootVisible: false,
                minListWidth: 300,
                autoLoad:false,
                fieldLabel: _("Attachment"),
                emptyText: _("Attachment..."),
                url: _url('/common/tree/editions/'),
                root: { id:'none', nodeType: 'async' },
                baseParams: { term: 'editions.attachment.manage:*' }
            },

            {
                xtype: "checkbox",
                fieldLabel: _("Confirmation"),
                boxLabel: _("I understand the risk"),
                name: "confirmation"
            }

        ];

        Ext.apply(this,  {
            border:false,
            baseCls: 'x-plain',
            bodyStyle:'padding:10px',
            defaults: { anchor: '100%' }
        });

        Inprint.calendar.forms.CopyAttachmentForm.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.forms.CopyAttachmentForm.superclass.onRender.apply(this, arguments);
        this.getForm().url = _source("attachment.copy");
    },

    setSource: function(id) {
        this.cmpSetValue("source", id);
    }

});
