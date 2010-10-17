Inprint.cmp.CreateDocumentWindow = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.formPanel = new Ext.FormPanel({
            url: "/documents/add/",
            border:false,
            labelWidth: 100,
            defaults: {
                anchor: "100%",
                allowBlank:false
            },
            bodyStyle: "padding: 20px 10px",
            items: [
                {
                    layout:'column',
                    border:false,
                    items:[
                        {
                            columnWidth:.5,
                            layout: 'form',
                            border:false,
                            items: [
                                {
                                    xtype:'fieldset',
                                    border:false,
                                    title: 'Описание материала',
                                    autoHeight:true,
                                    defaults: {
                                        anchor: "90%"
                                    },
                                    defaultType: 'textfield',
                                    items :[
                                        {
                                            fieldLabel: 'Название',
                                            name: 'home'
                                        },
                                        {
                                            fieldLabel: 'Автор',
                                            name: 'home'
                                        },
                                        {
                                            fieldLabel: 'Объем',
                                            name: 'home'
                                        },
                                        {
                                            fieldLabel: 'Комментарий',
                                            name: 'home'
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            columnWidth:.5,
                            layout: 'form',
                            border:false,
                            items: [
                                {
                                    xtype:'fieldset',
                                    border:false,
                                    title: 'Треккер',
                                    autoHeight:true,
                                    defaults: {
                                        anchor: "90%"
                                    },
                                    defaultType: 'textfield',
                                    items :[
                                        {   fieldLabel: 'Группа',
                                            name: 'home'
                                        },
                                        {   fieldLabel: 'Движение',
                                            name: 'home'
                                        },
                                        {   fieldLabel: 'Редактор',
                                            name: 'home'
                                        }
                                    ]
                                },
                                {
                                    xtype:'fieldset',
                                    border:false,
                                    title: 'Размещение',
                                    autoHeight:true,
                                    defaults: {width: 210},
                                    defaultType: 'textfield',
                                    items :[
                                        {   fieldLabel: 'Выпуск',
                                            name: 'home'
                                        },
                                        {   fieldLabel: 'Раздел',
                                            name: 'home'
                                        },
                                        {   fieldLabel: 'Рубрика',
                                            name: 'home'
                                        },
                                        {   fieldLabel: 'Дата сдачи',
                                            name: 'home'
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ],
            keys: [ _KEY_ENTER_SUBMIT ],
            buttons:[
                {
                    text: _("Create"),
                    scope:this,
                    handler: function() {
                        this.form.getForm().submit();
                    }
                },
                {
                    text: _("Close"),
                    scope:this,
                    handler: function() {
                        this.hide();
                    }
                }
            ]
        });

        Ext.apply(this, {
            title: _("Create"),
            layout: "fit",
            modal:true,
            width:800, height:400,
            items: this.formPanel
        });

        this.formPanel.on("actioncomplete", function (form, action) {
            if (action.type == "submit")
                this.hide();
        });

        Inprint.cmp.CreateDocumentWindow.superclass.initComponent.apply(this, arguments);

        Inprint.cmp.CreateDocumentWindow.Interaction(this.panels);
    },

    onRender: function() {
        Inprint.cmp.CreateDocumentWindow.superclass.onRender.apply(this, arguments);
    }

});
