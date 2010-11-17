Inprint.cmp.CreateDocument = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.addEvents('complete');
        this.form = new Inprint.cmp.CreateDocument.Form();

        Ext.apply(this, {
            modal:true,
            layout: "fit",
            items: this.form,
            width:700, height:380,
            title: _("Create a new document"),
            buttons:[
                {
                    scope:this,
                    disabled:true,
                    text: _("Create"),
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
                this.fireEvent("complete", this, this.form);
                this.hide();
            }
        }, this);

        Inprint.cmp.CreateDocument.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.CreateDocument.superclass.onRender.apply(this, arguments);
        Inprint.cmp.CreateDocument.Access(this, this.form);
    }

});
