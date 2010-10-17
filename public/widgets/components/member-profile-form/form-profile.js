Inprint.cmp.memberProfileForm.Form = Ext.extend(Ext.FormPanel, {
    initComponent: function() {

        this.imgid = Ext.id();

        Ext.apply(this,
        {
            fileUpload: true,
            border:false,
            bodyStyle: "padding: 10px 10px",
            url: _url("/profile/update/"),
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
                            xtype:'fieldset',
                            title: _("System information"),
                            labelWidth: 80,
                            defaults: { anchor: "100%" },
                            defaultType: "textfield",
                            items :[
                                {   fieldLabel: _("Login"),
                                    name: "login"
                                },
                                {   fieldLabel: _("Password"),
                                    name: "password"
                                }
                            ]
                        },
                        {
                            xtype:'fieldset',
                            title: _("Employee information"),
                            labelWidth: 80,
                            defaults: { anchor: "100%" },
                            defaultType: "textfield",
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
                        }
                    ]
                }
            ]
        });

        Inprint.cmp.memberProfileForm.Form.superclass.initComponent.apply(this, arguments);

        this.getForm().url = this.url;

    },

    onRender: function() {
        Inprint.cmp.memberProfileForm.Form.superclass.onRender.apply(this, arguments);
    }

});
