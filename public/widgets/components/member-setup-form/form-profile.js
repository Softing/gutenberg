Inprint.cmp.memberSetupWindow.Form = Ext.extend(Ext.FormPanel, {
    initComponent: function() {

        this.imgid = Ext.id();
        this.url = _url("/catalog/members/setup/");

        Ext.apply(this,
        {
            //fileUpload: true,
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
                            title: _("Defaults"),
                            defaults: { anchor: "100%", allowBlank:false },
                            items :[
                                {
                                    xtype: "treecombo",
                                    name: "edition-shortcut",
                                    hiddenName: "edition",
                                    fieldLabel: _("Edition"),
                                    emptyText: _("Edition") + "...",
                                    minListWidth: 300,
                                    url: _url('/common/tree/editions/'),
                                    baseParams: {
                                        term: 'editions.documents.work:*'
                                    },
                                    root: {
                                        id:'00000000-0000-0000-0000-000000000000',
                                        nodeType: 'async',
                                        expanded: true,
                                        draggable: false,
                                        icon: _ico("book"),
                                        text: _("All editions")
                                    }
                                },
                                {
                                    xtype: "treecombo",
                                    name: "workgroup-shortcut",
                                    hiddenName: "workgroup",
                                    fieldLabel: _("Group"),
                                    emptyText: _("Group") + "...",
                                    minListWidth: 300,
                                    url: _url('/common/tree/workgroups/'),
                                    baseParams: {
                                        term: 'catalog.documents.view:*'
                                    },
                                    root: {
                                        id:'00000000-0000-0000-0000-000000000000',
                                        nodeType: 'async',
                                        expanded: true,
                                        draggable: false,
                                        icon: _ico("folder-open"),
                                        text: _("All departments")
                                    }
                                }
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

        var form = this.getForm();

        if (Inprint.session.member) {
            form.findField("title").setValue(Inprint.session.member.title);
            form.findField("shortcut").setValue(Inprint.session.member.shortcut);
            form.findField("position").setValue(Inprint.session.member.position);
        }

    }

});
