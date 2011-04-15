Inprint.cmp.adverta.Request = Ext.extend(Ext.FormPanel, {

    initComponent: function() {

        var xc = Inprint.factory.Combo;

        this.items = [

            _FLD_HDN_ID,
            _FLD_HDN_FASCICLE,

            {
                xtype: "titlefield",
                value: "Заявка"
            },

            xc.getConfig("/advertising/combo/advertisers/", {
                hideLabel:true,
                editable:true,
                typeAhead: true,
                minChars: 2,
                minListWidth: 570,
                allowBlank:false,
                baseParams: {
                    fascicle: this.fascicle
                },
                listeners: {
                    scope: this,
                    beforequery: function(qe) {
                        delete qe.combo.lastQuery;
                    }
                }
            }),

            {
                xtype: "textfield",
                allowBlank:false,
                hideLabel:true,
                name: "shortcut",
                fieldLabel: _("Shortcut"),
                emptyText: _("Shortcut")
            },
            {
                xtype: "textarea",
                allowBlank:true,
                name: "description",
                hideLabel:true,
                fieldLabel: _("Description"),
                emptyText: _("Description")
            },

            {
                xtype: "titlefield",
                value: _("Parameters")
            },

            {
                columns: 1,
                xtype: 'radiogroup',
                fieldLabel: _("Request"),
                style: "margin-bottom:10px",
                name: "status",
                items: [
                    { name: "status", inputValue: "possible",    boxLabel: _("Possible") },
                    { name: "status", inputValue: "active",      boxLabel: _("Active") },
                    { name: "status", inputValue: "reservation", boxLabel: _("Reservation"), checked: true }
                ]
            },

            {
                columns: 1,
                xtype: 'radiogroup',
                fieldLabel: _("Squib"),
                style: "margin-bottom:10px",
                name: "squib",
                items: [
                    { name: "squib", inputValue: "yes",    boxLabel: _("Yes") },
                    { name: "squib", inputValue: "no", boxLabel: _("No"), checked: true }
                ]
            },

            {
                xtype: 'checkbox',
                fieldLabel: _("Paid"),
                boxLabel: _("Yes"),
                name: 'payment',
                checked: false
            },

            {
                xtype: 'checkbox',
                fieldLabel: _("Approved"),
                boxLabel: _("Yes"),
                name: 'approved',
                checked: false
            }

        ];

        Ext.apply(this, {
            flex:1,
            width: 280,
            labelWidth: 90,
            defaults: {
                anchor: "100%",
                allowBlank:false
            },
            bodyStyle: "padding:5px 5px"
        });

        Inprint.cmp.adverta.Request.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.adverta.Request.superclass.onRender.apply(this, arguments);
    }


});
