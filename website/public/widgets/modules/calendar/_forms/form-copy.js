Inprint.calendar.forms.CopyIssueForm = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

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

        Inprint.calendar.forms.CopyIssueForm.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.forms.CopyIssueForm.superclass.onRender.apply(this, arguments);
        this.getForm().url = _source("issue.copy");
    },

    setId: function(id) {
        this.cmpSetValue("id", id);
    }

});

Inprint.calendar.forms.CopyAttachmentForm = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

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

    setId: function(id) {
        this.cmpSetValue("id", id);
    }

});
