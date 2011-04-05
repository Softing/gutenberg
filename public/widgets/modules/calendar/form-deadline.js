Inprint.calendar.Deadline = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.items = [

            _FLD_HDN_ID,

            {
                id: "title1",
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
            xtype: "form",
            border:false,
            layout: 'form',
            bodyStyle:'padding:10px',
            defaults:{
                anchor:'100%'
            }
        });

        Inprint.calendar.Deadline.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.Deadline.superclass.onRender.apply(this, arguments);
        this.getForm().url = _source("fascicle.deadline");
    },

    cmpInit: function(node) {

        var form = this.getForm();

        this.cmpFill(node.id);

        if (node.attributes.fastype == "issue") {
            this.findById("title1").hidden = false;
            form.findField("print_date").hidden = false;
            form.findField("release_date").hidden = false;
        }

        if (node.attributes.fastype == "attachment") {
            this.findById("title1").hidden = true;
            form.findField("print_date").hidden = true;
            form.findField("release_date").hidden = true;
        }

        return this;
    },

    cmpFill: function (id) {
        this.load({
            scope:this,
            params: { id: id },
            url: _source("fascicle.read"),
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });
    }

});
