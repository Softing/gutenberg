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
                value: _("Key dates")
            },

            {
                name: 'print_date',
                xtype: 'xdatefield',
                format:'F j, Y',
                submitFormat:'Y-m-d',
                altFormats : "Y-m-d H:i:s",
                fieldLabel: _("Printing shop")
            },
            {
                xtype: 'xdatefield',
                name: 'release_date',
                format:'F j, Y',
                submitFormat:'Y-m-d',
                altFormats : "Y-m-d H:i:s",
                fieldLabel: _("Publication")
            },

            {
                xtype: "titlefield",
                value: _("Deadline"),
                margin:10
            },

            {
                labelWidth: 20,
                xtype: "xdatetime",
                name: "doc_date",
                format: "F j, Y",
                //submitFormat: "Y-m-d",
                fieldLabel: _("Documents")
            },
            {
                xtype: "checkbox",
                name: "doc_enabled",
                fieldLabel: "",
                boxLabel: _("Enabled")
            },

            {
                xtype: "spacerfield"
            },

            {
                xtype: 'xdatetime',
                name: 'adv_date',
                format:'F j, Y',
                //submitFormat:'Y-m-d',
                fieldLabel: _("Advertisement")
            },
            {
                xtype: "checkbox",
                name: "adv_enabled",
                fieldLabel: "",
                boxLabel: _("Enabled")
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
