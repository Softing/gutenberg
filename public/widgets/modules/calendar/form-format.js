Inprint.calendar.Format = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.items = [

            _FLD_HDN_ID,

            {
                border:false,
                defaults:{
                    bodyStyle:'padding:10px'
                },
                items:[
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
                        value: _("Deadline")
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

                ]
            }
        ];

        Ext.apply(this,  {
            xtype: "form",
            border:false
        });

        Inprint.calendar.Format.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.Format.superclass.onRender.apply(this, arguments);
        this.getForm().url = _source("fascicle.update");
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
