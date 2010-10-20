Inprint.cmp.CreateDocument = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.addEvents('actioncomplete');
        this.form = new Inprint.cmp.CreateDocument.Form();

        Ext.apply(this, {
            title: _("Create a new document"),
            modal:true,
            layout: "fit",
            width:700, height:380,
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
            if (action.type == "submit")
                this.hide();
        });

        Inprint.cmp.CreateDocument.superclass.initComponent.apply(this, arguments);

        Inprint.cmp.CreateDocument.Interaction(this.panels);
    },

    onRender: function() {
        Inprint.cmp.CreateDocument.superclass.onRender.apply(this, arguments);
    }

});
