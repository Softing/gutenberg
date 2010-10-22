Inprint.cmp.MoveDocument = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.addEvents('actioncomplete');
        this.form = new Inprint.cmp.MoveDocument.Form({
            initialValues: this.initialValues
        });

        Ext.apply(this, {
            title: _("Сhange fascicle"),
            modal:true,
            layout: "fit",
            width:380, height:350,
            items: this.form,
            buttons:[
                {
                    text: _("Create"),
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

        Inprint.cmp.MoveDocument.superclass.initComponent.apply(this, arguments);

        Inprint.cmp.MoveDocument.Interaction(this.panels);
    },

    onRender: function() {
        Inprint.cmp.MoveDocument.superclass.onRender.apply(this, arguments);
    }

});
