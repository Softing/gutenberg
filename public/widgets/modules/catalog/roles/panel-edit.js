//Inprint.catalog.roles.EditPanel = Ext.extend(Ext.FormPanel, {
//    initComponent: function() {
//
//        this.urls = {
//            load: _url("/catalog/roles/read/"),
//            save: _url("/catalog/roles/update/")
//        };
//
//        Ext.apply(this, {
//
//            disabled:true,
//
//            labelWidth: 75,
//            url: this.urls.save,
//
//            title: _("Adjustment"),
//            bodyStyle:"padding:15px 15px",
//
//            defaults: { anchor: "100%" },
//            defaultType: "textfield",
//
//            items: [
//                {
//                    xtype:"hidden",
//                    name:"id"
//                },
//                _FLD_TITLE,
//                _FLD_SHORTCUT,
//                _FLD_DESCRIPTION
//            ],
//
//            tbar: [
//                {
//                    icon: _ico("disk-black"),
//                    cls: "x-btn-text-icon",
//                    text: _("Save"),
//                    ref: "../btnSave",
//                    scope:this,
//                    handler: function() {
//                        this.getForm().submit();
//                    }
//                }
//            ]
//        });
//
//        Inprint.catalog.roles.EditPanel.superclass.initComponent.apply(this, arguments);
//
//        this.getForm().url = this.urls.save;
//
//    },
//
//    onRender: function() {
//        Inprint.catalog.roles.EditPanel.superclass.onRender.apply(this, arguments);
//    },
//
//    cmpFill: function(record) {
//
//        if (this.rendered == false)
//            return;
//
//        this.body.mask(_("Loading..."));
//
//        this.load({
//            url: this.urls.load,
//            scope:this,
//            params: {
//                id: this.cmpGetId()
//            },
//            success: function(form, action) {
//                this.body.unmask();
//                form.findField("catalog").setValue(action.result.data.catalog_shortcut);
//            },
//            failure: function(form, action) {
//                this.body.unmask();
//                Ext.Msg.alert("Load failed", action.result.errorMessage);
//            }
//        });
//
//    }
//
//});
