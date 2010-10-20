Inprint.cmp.CreateDocument.Form = Ext.extend(Ext.FormPanel, {
    initComponent: function() {

        var xc = Inprint.factory.Combo;

        Ext.apply(this, {
            url: _url("/documents/add/"),
            border:false,
            layout:'column',
            autoScroll:true,
            labelWidth: 80,
            bodyStyle: "padding: 20px 10px 20px 10px",
            defaults: {
                anchor: "100%",
                allowBlank:false
            },
            items: [
                {
                    columnWidth:.6,
                    layout: 'form',
                    border:false,
                    items: [
                        {
                            xtype:'fieldset',
                            border:false,
                            title: _("Document description"),
                            autoHeight:true,
                            defaults: {
                                anchor: "95%"
                            },
                            defaultType: 'textfield',
                            items :[
                                {
                                    fieldLabel: _("Title"),
                                    name: 'title'
                                },
                                {
                                    fieldLabel: _("Author"),
                                    name: 'author'
                                },
                                {
                                    xtype: 'numberfield',
                                    fieldLabel: _("Size"),
                                    name: 'size',
                                    allowDecimals: false,
                                    allowNegative: false
                                },
                                {
                                    xtype: "textarea",
                                    fieldLabel: _("Comment"),
                                    name: 'comment'
                                }
                            ]
                        }
                    ]
                },
                {
                    columnWidth:.4,
                    layout: 'form',
                    border:false,
                    items: [
                        {
                            xtype:'fieldset',
                            border:false,
                            title: _("Tracking"),
                            //autoHeight:true,
                            defaults: {
                                anchor: "100%"
                            },
                            defaultType: 'textfield',
                            items :[
                                xc.getConfig("/documents/combos/editions/"),
                                xc.getConfig("/documents/combos/stages/", {
                                    disabled: true
                                }),
                                xc.getConfig("/documents/combos/assignments/", {
                                    disabled: true
                                })
                            ]
                        },
                        {
                            xtype:'fieldset',
                            border:false,
                            title: _("Publication"),
                            defaults: {
                                anchor: "100%"
                            },
                            //autoHeight:true,
                            items :[
                                {
                                    xtype: 'xdatefield',
                                    name: 'enddate',
                                    format:'F j, Y',
                                    submitFormat:'Y-m-d',
                                    allowBlank:false,
                                    fieldLabel: _("Date")
                                },
                                xc.getConfig("/documents/combos/fascicles/"),
                                xc.getConfig("/documents/combos/headlines/", {
                                    disabled: true
                                }),
                                xc.getConfig("/documents/combos/rubrics/", {
                                    disabled: true
                                })
                            ]
                        }
                    ]
                }
            ]
        });

        Inprint.cmp.CreateDocument.Form.superclass.initComponent.apply(this, arguments);

        this.getForm().url = this.url;

    },

    onRender: function() {
        Inprint.cmp.CreateDocument.Form.superclass.onRender.apply(this, arguments);
    }

});
