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
                border:false,
                deferredRender: false,
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
                                hiddenName: "edition",
                                fieldLabel: _("Edition"),
                                emptyText: _("Select main edition..."),
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
                                hiddenName: "workgroup",
                                fieldLabel: _("Group"),
                                emptyText: _("Select main department..."),
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
                    },
                    {
                        title: _("Text editor"),
                        layout:'form',
                        labelWidth: 120,
                        defaults: {
                            width: 230
                        },
                        defaultType: 'textfield',
                        items: [
                            new Ext.form.ComboBox({
                                hiddenName: "font-style",
                                fieldLabel: _("Font style"),
                                store: new Ext.data.ArrayStore({
                                    fields: ['id', 'title'],
                                    data : [
                                        ["times new roman",  _("Times New Roman") ],
                                    ]
                                }),
                                mode: 'local',
                                editable: false,
                                typeAhead: true,
                                valueField:'id',
                                displayField:'title',
                                forceSelection: true,
                                triggerAction: 'all',
                                emptyText: _("Select a font style...")
                            }),
                             new Ext.form.ComboBox({
                                hiddenName: "font-size",
                                fieldLabel: _("Font size"),
                                store: new Ext.data.ArrayStore({
                                    fields: ['id', 'title'],
                                    data : [
                                        ["small",  _("Small size") ],
                                        ["medium", _("Medium size") ],
                                        ["large",  _("Large size") ]
                                    ]
                                }),
                                mode: 'local',
                                editable: false,
                                typeAhead: true,
                                valueField:'id',
                                displayField:'title',
                                forceSelection: true,
                                triggerAction: 'all',
                                emptyText: _("Select a font size...")
                            })
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

        var editionId    = options["default.edition"];
        var editionTitle = options["default.edition.name"];
        if (editionId && editionTitle) {
            form.findField("edition").on("render", function(field) {
                field.setValue( editionId, editionTitle );
            });
        }

        var workgroupId    = options["default.workgroup"];
        var workgroupTitle = options["default.workgroup.name"];
        if (workgroupId && workgroupTitle) {
            form.findField("workgroup").on("render", function(field) {
                field.setValue( workgroupId, workgroupTitle );
            });
        }

        var fontSizeTitles = {
                "small":  _("Small size"),
                "medium": _("Medium size"),
                "large":  _("Large size")
            };

        var fontSize      = options["default.font.size"] || "medium";
        var fontSizeTitle = fontSizeTitles[ fontSize ] || _("Medium size");

        if (fontSize && fontSizeTitle) {
            form.findField("font-size").on("render", function(field) {
                field.setValue( fontSize, fontSizeTitle );
            });
        }

        var fontStyleTitles = {
                "times new roman": "Times New Roman"
            };

        var fontStyle      = options["default.font.style"] || "times new roman";
        var fontStyleTitle = fontStyleTitles[ fontStyle ] || "Times New Roman";

        if (fontStyle && fontStyleTitle) {
            form.findField("font-style").on("render", function(field) {
                field.setValue( fontStyle, fontStyleTitle );
                field.setRawValue( fontStyle, fontStyleTitle );
            });
        }


    }

});
