Inprint.member.profile.Form = Ext.extend(Ext.FormPanel, {
    initComponent: function() {

        this.imgid = Ext.id();

        Ext.apply(this, {

            disabled:true,
            autoScroll:true,
            fileUpload: true,

            labelWidth: 75,

            url: _url("/profile/update/"),

            title: _("Edit profile"),
            bodyStyle:"padding:15px 15px",
            defaults: { anchor: "90%" },
            items: [
                {
                    xtype:"hidden",
                    name:"id"
                },

                {
                    xtype:'fieldset',
                    title: _("Photo"),
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
                            emptyText: 'Select an image',
                            fieldLabel: 'Photo',
                            name: 'image',
                            buttonText: 'upload'
                        })
                    ]
                },
                {
                    xtype:'fieldset',
                    title: _("System Information"),
                    defaults: { anchor: "100%" },
                    defaultType: "textfield",
                    items :[
                        {
                            fieldLabel: _("Login"),
                            name: "login"
                        },
                        {
                            fieldLabel: _("Password"),
                            name: "password"
                        }
                    ]
                },
                {
                    xtype:'fieldset',
                    title: _("User Information"),
                    defaults: { anchor: "100%" },
                    defaultType: "textfield",
                    items :[
                        {
                            fieldLabel: _("Name"),
                            name: "name"
                        },
                        {
                            fieldLabel: _("Shortcut"),
                            name: "shortcut"
                        },
                        {
                            fieldLabel: _("Position"),
                            name: "position"
                        }
                    ]
                }

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

        Inprint.member.profile.Form.superclass.initComponent.apply(this, arguments);

        this.getForm().url = this.url;

    },

    onRender: function() {
        Inprint.member.profile.Form.superclass.onRender.apply(this, arguments);
    },

    cmpFill: function(record) {
        var form = this.getForm();

        form.reset();
        form.findField("imagefield").setValue("/profile/image/"+ NULLID);

        if (record) {
            form.loadRecord(record);
            form.findField("imagefield").setValue("/profile/image/"+ record.data.id);
        }
    }

});
