Inprint.cmp.memberProfileForm.Window = Ext.extend(Ext.Window, {

    initComponent: function() {
        this.addEvents('actioncomplete');
        this.form = new Inprint.cmp.memberProfileForm.Form();
        Ext.apply(this, {
            title: _("Edit profile"),
            modal: true,
            layout: "fit",
            closeAction: "hide",
            width:600, height:320,
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
                    text: _("Close"),
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
                this.fireEvent("actioncomplete");
            }
        }, this);
        Inprint.cmp.memberProfileForm.Window.superclass.initComponent.apply(this, arguments);
        Inprint.cmp.memberProfileForm.Interaction(this.panels);
    },

    onRender: function() {
        Inprint.cmp.memberProfileForm.Window.superclass.onRender.apply(this, arguments);
    },

    cmpFill: function(id) {
        this.body.mask(_("Loading"));
        var form = this.form.getForm();
        form.reset();
        form.load({
            scope:this,
            params: { id: id },
            url: "/profile/read/",
            success: function(form, action) {
                this.body.unmask();
                this.form.getForm().findField("imagefield").setValue("/profile/image/"+ id);
            },
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });
    }

});

Inprint.registry.register("employee-card", {
    icon: "card",
    text: _("Card"),
    handler: function () {
        new Inprint.cmp.memberProfileForm.Window().show().cmpFill("self");
    }
});
