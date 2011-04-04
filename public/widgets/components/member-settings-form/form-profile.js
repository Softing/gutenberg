Inprint.cmp.memberSettingsForm.Form = Ext.extend(Ext.FormPanel, {
    initComponent: function() {

        this.url = _url("/options/update/");

        Ext.apply(this,
        {
            border:false,
            autoScroll:true,
            layout: "fit",
            items: {
                xtype:'tabpanel',
                activeTab: 0,
                defaults:{
                    bodyStyle:'padding:10px'
                },
                items:[
                    {
                        title: _("Exchange"),
                        layout:'form',
                        labelWidth: 120,
                        defaults: {
                            width: 230
                        },
                        defaultType: 'textfield',
                        items: [
                            {
                                xtype: "treecombo",
                                name: "edition-shortcut",
                                hiddenName: "edition",
                                fieldLabel: _("Edition"),
                                emptyText: _("Edition") + "...",
                                minListWidth: 250,
                                url: _url('/documents/trees/editions/'),
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
                                minListWidth: 250,
                                url: _url('/documents/trees/workgroups/'),
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
        });

        Inprint.cmp.memberSettingsForm.Form.superclass.initComponent.apply(this, arguments);

        this.getForm().url = this.url;

    },

    onRender: function() {

        Inprint.cmp.memberSettingsForm.Form.superclass.onRender.apply(this, arguments);

        var form = this.getForm();
        var options = Inprint.session.options;

        //if (options && options["default.edition"])
            //form.findField("edition-shortcut").on("render", function(field) { field.setValue(options["default.edition"], options["default.edition.name"]); });
        //if (options && options["default.workgroup"])
            //form.findField("workgroup-shortcut").on("render", function(field) { field.setValue(options["default.workgroup"], options["default.workgroup.name"]); });
    }

});
