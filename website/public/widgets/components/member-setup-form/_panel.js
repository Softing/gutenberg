Inprint.cmp.memberSetupWindow = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.addEvents('actioncomplete');
        this.form = new Inprint.cmp.memberSetupWindow.Form();

        Ext.apply(this, {
            title: _("Employee setup"),
            layout: "fit",
            modal: true,
            closable: false,
            width:600, height:320,
            items: this.form,
            buttons:[
                {
                    text: _("Save"),
                    scope:this,
                    handler: function() {
                        this.form.getForm().submit();
                    }
                }
            ]
        });

        this.form.on("actioncomplete", function (form, action) {
            if (action.type == "submit") {
                this.hide();
                this.fireEvent("actioncomplete");
                Inprint.updateSession(false);
            }
        }, this);

        Inprint.cmp.memberSetupWindow.superclass.initComponent.apply(this, arguments);
        Inprint.cmp.memberSetupWindow.Interaction(this.panels);

    },

    onRender: function() {
        Inprint.cmp.memberSetupWindow.superclass.onRender.apply(this, arguments);
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
