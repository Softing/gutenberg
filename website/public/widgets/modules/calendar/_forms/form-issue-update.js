Inprint.calendar.forms.UpdateIssueForm = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.items = [

            _FLD_HDN_ID,

            {
                xtype: "titlefield",
                value: _("Basic parameters")
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
                xtype: "titlefield",
                value: _("Additional parameters"),
                margin:10
            },

            {
                xtype: "textfield",
                name: "num",
                fieldLabel: _("Number")
            },
            {
                xtype: "textfield",
                name: "anum",
                fieldLabel: _("Annual number")
            },

            {
                xtype: "numberfield",
                name: "circulation",
                fieldLabel: _("Circulation"),
                value: 0
            },
            
            {
                xtype: "titlefield",
                value: _("Restrictions")
            },
            {
                labelWidth: 20,
                xtype: "xdatetime",
                name: "doc_date",
                format: "F j, Y",
                fieldLabel: _("Documents")
            },
            {
                xtype: 'xdatetime',
                name: 'adv_date',
                format:'F j, Y',
                fieldLabel: _("Advertisement")
            },
            {
                xtype: "numberfield",
                name: "adv_modules",
                fieldLabel: _("Modules")
            },

            {
                xtype: "titlefield",
                value: _("Deadline")
            },
            {
                format:'F j, Y',
                name: 'print_date',
                xtype: 'xdatefield',
                submitFormat:'Y-m-d',
                fieldLabel: _("To print")
            },
            {
                xtype: 'xdatefield',
                name: 'release_date',
                format:'F j, Y',
                submitFormat:'Y-m-d',
                fieldLabel: _("To publication")
            }

        ];

        Ext.apply(this,  {
            baseCls: 'x-plain',
            defaults:{ anchor:'98%' }
        });

        Inprint.calendar.forms.UpdateIssueForm.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.forms.UpdateIssueForm.superclass.onRender.apply(this, arguments);
        this.getForm().url = _source("issue.update");
    },

    cmpFill: function (id) {
        this.load({
            scope:this,
            params: { id: id },
            url: _source("issue.read"),
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });
    }

});
