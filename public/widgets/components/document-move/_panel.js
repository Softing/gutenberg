Inprint.cmp.MoveDocument = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.addEvents('actioncomplete');
        this.form = new Inprint.cmp.MoveDocument.Form({
            oid: this.oid
        });

        Ext.apply(this, {
            title: _("Move document"),
            modal:true,
            layout: "fit",
            width:380, height:350,
            items: this.form,
            buttons:[
                {
                    text: _("Move"),
                    scope:this,
                    handler: function() {
                        this.form.getForm().submit();
                    }
                },
                {
                    text: _("Cancel"),
                    scope:this,
                    handler: function() {
                        this.hide();
                    }
                }
            ]
        });

        this.form.on("actioncomplete", function (form, action) {
            if (action.type == "submit") {
                this.hide();
                this.fireEvent("actioncomplete", this, this.form);
            }
        }, this);

        Inprint.cmp.MoveDocument.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.MoveDocument.superclass.onRender.apply(this, arguments);
        Inprint.cmp.MoveDocument.Interaction(this, this.panels);
    },

    setId: function(data) {
        this.form.getForm().baseParams = {
            id: data
        };
    }

});
