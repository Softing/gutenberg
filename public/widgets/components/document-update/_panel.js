Inprint.cmp.UpdateDocument = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.addEvents('actioncomplete');
        this.form = new Inprint.cmp.UpdateDocument.Form();

        Ext.apply(this, {
            title: _("Document profile update"),
            modal:true,
            layout: "fit",
            width:700, height:380,
            items: this.form,
            buttons:[
                {
                    text: _("Save"),
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
        });

        Inprint.cmp.UpdateDocument.superclass.initComponent.apply(this, arguments);
        Inprint.cmp.UpdateDocument.Interaction(this.panels);
    },

    onRender: function() {
        Inprint.cmp.UpdateDocument.superclass.onRender.apply(this, arguments);
    }

});
