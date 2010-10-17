Inprint.cmp.memberSetupWindow.Form = Ext.extend(Ext.FormPanel, {
    initComponent: function() {

        this.imgid = Ext.id();
        this.url = _url("/catalog/members/setup/");

        Ext.apply(this,
        {
            fileUpload: true,
            border:false,
            bodyStyle: "padding: 10px 10px",
            autoScroll:true,
            layout:'column',
            items: [
                {
                    columnWidth:.3,
                    layout: 'form',
                    border:false,
                    bodyStyle:'padding:0px 10px 0px 0px',
                    items: [
                        {
                            xtype:"hidden",
                            name:"id"
                        },
                        {
                            xtype:'fieldset',
                            title: _("Photo"),
                            labelWidth: 40,
                            defaults: { anchor: "100%" },
                            defaultType: "textfield",
                            items :[
                                {
                                    name: 'imagefield',
                                    xtype: 'imagefield',
                                    value: '/profile/image/'+ NULLID,
                                    hideLabel:true
                                },
                                new Ext.ux.form.FileUploadField({
                                    emptyText: _('Path to image'),
                                    hideLabel:true,
                                    name: 'image',
                                    buttonText: _('Select')
                                })
                            ]
                        }
                    ]
                },
                {
                    columnWidth:.7,
                    layout: 'form',
                    border:false,
                    items: [
                        {
                            labelWidth: 120,
                            xtype:'fieldset',
                            defaultType: "textfield",
                            title: _("Employee information"),
                            defaults: { anchor: "100%", allowBlank:false },
                            items :[
                                {   fieldLabel: _("Title"),
                                    name: "title"
                                },
                                {   fieldLabel: _("Alias"),
                                    name: "shortcut"
                                },
                                {   fieldLabel: _("Position"),
                                    name: "position"
                                }
                            ]
                        },
                        {
                            labelWidth: 120,
                            xtype:'fieldset',
                            title: _("Transfer settings"),
                            defaults: { anchor: "100%", allowBlank:false },
                            items :[
                                Inprint.factory.Combo.create("/options/combos/capture-destination/")
                            ]
                        }
                    ]
                }
            ]
        });

        Inprint.cmp.memberSetupWindow.Form.superclass.initComponent.apply(this, arguments);

        this.getForm().url = this.url;

    },

    onRender: function() {

        Inprint.cmp.memberSetupWindow.Form.superclass.onRender.apply(this, arguments);

        if (Inprint.session.member) {
            this.getForm().findField("title").setValue(Inprint.session.member.title);
            this.getForm().findField("alias").setValue(Inprint.session.member.shortcut);
            this.getForm().findField("position").setValue(Inprint.session.member.position);
        }

        if (Inprint.session.options && Inprint.session.options["transfer.capture.destination"]) {
            this.getForm().findField("capture.destination").loadValue(Inprint.session.options["transfer.capture.destination"]);
        }

    }

});
