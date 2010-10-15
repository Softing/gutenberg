Inprint.cmp.memberSettingsForm.Window = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.addEvents('actioncomplete');
        this.form = new Inprint.cmp.memberSettingsForm.Form();

        Ext.apply(this, {
            title: _("Employee settings"),
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

        Inprint.cmp.memberSettingsForm.Window.superclass.initComponent.apply(this, arguments);
        Inprint.cmp.memberSettingsForm.Interaction(this.panels);

    },

    onRender: function() {
        Inprint.cmp.memberSettingsForm.Window.superclass.onRender.apply(this, arguments);
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
            },
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });
    }

});
