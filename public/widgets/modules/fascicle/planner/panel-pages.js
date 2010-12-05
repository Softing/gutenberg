Inprint.fascicle.planner.Pages = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
        this.dialogs = {};
        
        this.urls = {
            "create": _url("/fascicle/pages/create/"),
            "update": _url("/fascicle/pages/update/"),
            "delete": _url("/fascicle/pages/delete/"),
            "move": _url("/fascicle/pages/move/"),
            "clean": _url("/fascicle/pages/clean/"),
            "resize": _url("/fascicle/pages/resize/")
        };
        
        this.view = new Inprint.fascicle.plan.View({
            parent: this.parent,
            fascicle: this.oid
        });
        
        Ext.apply(this, {
            border:false,
            layout: "fit",
            autoScroll:true,
            items: this.view
        });
        
        Inprint.fascicle.planner.Pages.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.planner.Pages.superclass.onRender.apply(this, arguments);
    },
    
    getView: function() {
        return this.view;
    },
    
    getStore: function() {
        return this.view.getStore();
    },

    cmpPageCreate: function() {
        
        var wndw = this.dialogs["create"];
        
        if (!wndw) {
            
            wndw = new Ext.Window({
                title: 'Укажите полосы для добавления',
                width: 300,
                height: 200,
                modal:true,
                draggable:true,
                layout: "fit",
                closeAction: "hide",
                items: {
                    xtype: "form",
                    border: false,
                    url: this.urls["create"],
                    baseParams: {
                        fascicle: this.oid
                    },
                    labelWidth: 100,
                    defaultType: 'checkbox',
                    defaults: { anchor: '100%' },
                    bodyStyle: 'padding:5px 5px 0;',
                    listeners: {
                        scope:this,
                        actioncomplete: function() {
                            wndw.hide();
                            this.parent.cmpReload();
                        }
                    },
                    items: [
                        {
                            xtype: 'box',
                            autoEl: {tag:'div', html: 'Пример: 1, 2, 5-8, 9:10 (9:10 добавит 10 полос после полосы 9).' },
                            cls: 'inprint-form-helpbox'
                        },
                        {
                            xtype: 'textfield',
                            name: 'page',
                            fieldLabel: 'Полосы',
                            allowBlank:false,
                            itemCls: 'required'
                        },
                        Inprint.factory.Combo.getConfig("/fascicle/combos/headlines/", {
                            baseParams:{
                                fascicle: this.oid
                            },
                            listeners: {
                                beforequery: function(qe) {
                                    delete qe.combo.lastQuery;
                                }
                            }
                        })
                    ]
                },
                buttons: [
                    _BTN_WNDW_ADD, 
                    _BTN_WNDW_CANCEL
                ]
            });
            
            this.dialogs["create"] = wndw;
        }
        
        //var form = wndw.items.first().getForm();
        //
        //var field = form.findField('page');
        //field.setValue('');
        //field.focus('', 10);
        
        wndw.show();
    },

    // Редактировать
    cmpPageUpdate: function() {
        
        var wndw = this.dialogs["update"];
        
        if (!wndw) {
            
            wndw = new Ext.Window({
                title: 'Редактировать полосы',
                width: 300,
                height: 150,
                modal:true,
                draggable:true,
                layout: "fit",
                closeAction: "hide",
                items: {
                    xtype: "form",
                    border: false,
                    url: this.urls["update"],
                    baseParams: {
                        fascicle: this.oid
                    },
                    labelWidth: 100,
                    defaultType: 'checkbox',
                    defaults: { anchor: '100%' },
                    bodyStyle: 'padding:5px 5px 0;',
                    listeners: {
                        scope:this,
                        actioncomplete: function() {
                            wndw.hide();
                            this.parent.cmpReload();
                        }
                    },
                    items: [
                        Inprint.factory.Combo.getConfig("/fascicle/combos/headlines/", {
                            baseParams:{
                                fascicle: this.oid
                            },
                            listeners: {
                                beforequery: function(qe) {
                                    delete qe.combo.lastQuery;
                                }
                            }
                        })
                    ]
                },
                buttons: [
                    _BTN_WNDW_OK, 
                    _BTN_WNDW_CANCEL
                ]
            });
            
            this.dialogs["update"] = wndw;
        }
        
        wndw.show();
        
        //this.dlgEdit.setTitle('Редактировать полосу <'+ this.selected_as_string +'>');
        //this.dlgEdit.show();
        //
        //var form = this.dlgEdit.items.itemAt(0).getForm();
        //form.reset();
        //
        //form.baseParams.selection = this.selection;
    },
    
    //Переместить
    cmpPageMove: function() {
        
        var wndw = this.dialogs["move"];
        
        if (!wndw) {
            
            wndw = new Ext.Window({
                title: 'Перенос полос',
                width: 400,
                height: 300,
                modal:true,
                draggable:true,
                layout: "fit",
                closeAction: "hide",
                items: {
                    xtype: "form",
                    border: false,
                    url: this.urls["move"],
                    baseParams: {
                        fascicle: this.oid
                    },
                    labelWidth: 100,
                    defaultType: 'checkbox',
                    defaults: { anchor: '100%' },
                    bodyStyle: 'padding:5px 5px 0;',
                    listeners: {
                        scope:this,
                        actioncomplete: function() {
                            wndw.hide();
                            this.parent.cmpReload();
                        }
                    },
                    items: [
                        {
                            xtype: 'box',
                            autoEl: {tag:'div', html: 'Укажите после какой полосы нужно разместить выбранные полосы' },
                            cls: 'inprint-form-helpbox'
                        },
                        {
                            xtype: 'textfield',
                            name: 'page',
                            disabled:true,
                            fieldLabel: 'Переместить',
                            itemCls: 'required'
                        },
                        {
                            xtype: 'textfield',
                            fieldLabel: 'После полосы',
                            itemCls: 'required',
                            name: 'place'
                        },
                        {
                            fieldLabel: '',
                            labelSeparator: '',
                            width: 'auto',
                            checked:true,
                            boxLabel: 'Удалить освободившиеся полосы',
                            name: 'removeempty',
                            inputValue: 'true'
                        }
                    ]
                },
                buttons: [
                    _BTN_WNDW_OK, 
                    _BTN_WNDW_CANCEL
                ]
            });
            
            this.dialogs["move"] = wndw;
        }
        
        wndw.show();
        
        //this.dlgMove.setTitle('Перенести полосу <'+ this.selected_as_string +'>');
        //this.dlgMove.show();
        //
        //var form = this.dlgMove.items.itemAt(0).getForm();
        //
        //form.reset();
        //form.findField('page').setValue( this.selected_as_string );
        //form.baseParams.selection = this.selection;
    },
    
    // Стереть
    cmpPageClean: function() {
    
        var wndw = this.dialogs["clean"];
    
        if (!wndw) {
            
            var wndw = new Ext.Window({
                title: 'Очистка полос',
                width:250,
                height:140,
                modal:true,
                draggable:true,
                layout: "fit",
                closeAction: "hide",
                items: {
                    xtype: "form",
                    border: false,
                    url: this.urls["clean"],
                    baseParams: {
                        fascicle: this.oid
                    },
                    labelWidth: 60,
                    defaultType: 'checkbox',
                    defaults: { anchor: '100%' },
                    bodyStyle: 'padding:5px 5px 0;',
                    listeners: {
                        scope:this,
                        actioncomplete: function() {
                            wndw.hide();
                            this.parent.cmpReload();
                        }
                    },
                    items: [
                        {
                            xtype: 'checkbox',
                            name: 'documents',
                            checked:false,
                            inputValue: 'true',
                            fieldLabel: 'Стереть',
                            labelSeparator: ':',
                            boxLabel: 'Материалы'
                        },
                        {
                            xtype: 'checkbox',
                            name: 'advertisements',
                            checked:false,
                            inputValue: 'true',
                            fieldLabel: '',
                            labelSeparator: '',
                            boxLabel: 'Рекламу'
                        }
                    ]
                },
                buttons: [
                    _BTN_WNDW_OK, 
                    _BTN_WNDW_CANCEL
                ]
            });
            
            this.dialogs["clean"] = wndw;
        }
        
        wndw.show();
        
        //this.dlgClean.setTitle('Очистить полосы <'+ this.selected_as_string +'>');
        //this.dlgClean.show();
        //
        //var form = this.dlgClean.items.first().getForm();
        //form.reset();
        //form.baseParams.selection = this.selection;
    },

    // разверстать
    cmpPageResize: function() {
        
        var wndw = this.dialogs["resize"];
        
        if (!wndw) {
            
            wndw = new Ext.Window({
                title: 'Разверстка полос',
                width:320,
                height:240,
                modal:true,
                draggable:true,
                layout: "fit",
                closeAction: "hide",
                items: {
                    xtype: "form",
                    border: false,
                    url: this.urls["resize"],
                    baseParams: {
                        fascicle: this.oid
                    },
                    labelWidth: 100,
                    defaultType: 'checkbox',
                    defaults: { anchor: '100%' },
                    bodyStyle: 'padding:5px 5px 0;',
                    listeners: {
                        scope:this,
                        actioncomplete: function() {
                            wndw.hide();
                            this.parent.cmpReload();
                        }
                    },
                    items: [
                        {
                            xtype: 'box',
                            autoEl: {tag:'div', html: 'Пример: 1, 2, 5-8, 9:10 (9:10 добавит 10 полос после полосы 9).' },
                            cls: 'inprint-form-helpbox'
                        },
                        {
                            xtype: 'textfield',
                            name: 'page',
                            itemCls: 'required',
                            fieldLabel: 'На полосы'
                        },
                        {
                            xtype: 'checkbox',
                            name: 'documents',
                            checked:true,
                            inputValue: 'true',
                            fieldLabel: 'Скопировать',
                            labelSeparator: ':',
                            boxLabel: 'Материалы'
                        },
                        {
                            xtype: 'checkbox',
                            name: 'advertisements',
                            checked:false,
                            inputValue: 'true',
                            fieldLabel: '',
                            labelSeparator: '',
                            boxLabel: 'Рекламу'
                        }
                    ]
                },
                buttons: [
                    _BTN_WNDW_OK, 
                    _BTN_WNDW_CANCEL
                ]
            });

            this.dialogs["resize"] = wndw;
        }
        
        wndw.show();
        
        //this.dlgResize.setTitle('Разверстать полосу <'+ this.selected_as_string +'>');
        //this.dlgResize.show();
        //
        //var form = this.dlgResize.items.first().getForm();
        //
        //form.reset();
        //form.baseParams.selection = this.selection;
    },
    
    //Удалить
    cmpPageDelete: function(inc) {
        if ( inc == 'no') return;
        if ( inc == 'yes') {
            Ext.Ajax.request({
                url: this.urls["delete"],
                params: {
                    fascicle: this.oid,
                    selection: this.selection
                },
                scope: this,
                success: function() {
                    this.parent.cmpReload()
                }
            });
        } else {
            Ext.MessageBox.confirm(
                'Подтверждение',
                'Вы действительно хотите безвозвратно удалить полосы <'+ this.selected_as_string +'>?',
                this.cmpDelete, this
            );
        }
    }
    
});
