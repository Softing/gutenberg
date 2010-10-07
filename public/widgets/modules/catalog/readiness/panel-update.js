Inprint.catalog.readiness.UpdateForm = Ext.extend(Ext.FormPanel, {
    initComponent: function() {

        this.urls = {
            read:    _url("/catalog/readiness/read/"),
            update:  _url("/catalog/readiness/update/")
        };

        Ext.apply(this, {
            title: _("Edit"),
            frame:false,
            border:false,
            labelWidth: 75,
            defaults: {
                anchor: "100%",
                allowBlank:false
            },
            bodyStyle: "padding:5px 5px",
            items: [
                _FLD_HDN_ID,
                _FLD_TITLE,
                _FLD_SHORTCUT,
                _FLD_DESCRIPTION,
                _FLD_COLOR,
                _FLD_PERCENT,
            ],
            tbar: [
                {
                    icon: _ico("disk-black"),
                    cls: "x-btn-text-icon",
                    text: _("Save"),
                    ref: "../btnASave",
                    scope:this,
                    handler: function() {
                        this.getForm().submit();
                    }
                }
            ]
        });

        Inprint.catalog.readiness.UpdateForm.superclass.initComponent.apply(this, arguments);

        this.getForm().url = this.urls.update;

    },

    onRender: function() {
        Inprint.catalog.readiness.UpdateForm.superclass.onRender.apply(this, arguments);
    },

    cmpFill: function(id) {

        var form = this.getForm();
        form.reset();

        if (id) {
            form.load({
                url: this.urls.read,
                scope:this,
                params: {
                    id: id
                },
                success: function(form, action) {
                    //form.findField("id").setValue(action.result.data.id);
                },
                failure: function(form, action) {
                    Ext.Msg.alert("Load failed", action.result.errorMessage);
                }
            });
        }
    }

});
