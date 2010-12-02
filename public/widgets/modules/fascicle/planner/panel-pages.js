Inprint.fascicle.planner.Pages = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
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

    cmpAdd: function() {
        
        if (!this.dlgAdd) {
            
            var myform = new Ext.FormPanel({
                
                url: this.url.add,
                
                baseParams: {
                    fascicle: this.fascicle
                },
                
                labelWidth: 100,
                defaultType: 'checkbox',
                defaults: { anchor: '100%' },
                bodyStyle: 'padding:5px 5px 0;',
                
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
                    
                    new Ext.form.ComboBox({
                        allowBlank:true,
                        fieldLabel: 'Колонтитул',
                        store: new Ext.data.Store({
                            baseParams: {
                                fascicle: this.fascicle
                            },
                            proxy:  new Ext.data.HttpProxy ({ url: '/common/list/catchwords/' }),
                            reader: new Ext.data.JsonReader({ id: 'uuid' }, [ 'uuid', 'title'] )
                        }),
                        hiddenName: 'catchword',
                        displayField: 'title',
                        valueField:   'uuid',
                        triggerAction: 'all',
                        forceSelection: true,
                        editable:false
                    })
                ]
            });
            
            var mywindow = new Ext.Window({
                title: 'Укажите полосы для добавления',
                width: 300,
                height: 200,
                draggable:true,
                buttons: [{
                    text: "Добавить",
                    handler: function() {
                        myform.getForm().submit();
                    }
                }, 
                {   text: Inprint.str.cancel,
                    handler: function() {
                        mywindow.hide();
                    }
                }],
                items: myform
            });
            
            myform.on("actioncomplete", function() {
                mywindow.hide();
                this.parent.cmpReload();
            }, this)
            
            this.dlgAdd = mywindow;
        }
        
        this.dlgAdd.show();
        
        var form = this.dlgAdd.items.first().getForm();
        var field = form.findField('page');
        field.setValue('');
        field.focus('', 10);
    },

    // Редактировать
    cmpEdit: function() {
        
        if (!this.dlgEdit) {
            
            var myform = new Ext.FormPanel({
                
                url: this.url.edit,
                
                baseParams: {
                    fascicle: this.fascicle
                },
                
                labelWidth: 100,
                defaultType: 'checkbox',
                defaults: { anchor: '100%' },
                bodyStyle: 'padding:5px 5px 0;',
                
                items: [
                    new Ext.form.ComboBox({
                        fieldLabel: 'Колонтитул',
                        store: new Ext.data.Store({
                            baseParams: {
                                fascicle: this.fascicle
                            },
                            proxy:  new Ext.data.HttpProxy ({ url: '/common/list/catchwords/' }),
                            reader: new Ext.data.JsonReader({ id: 'uuid' }, [ 'uuid', 'title'] )
                        }),
                        hiddenName: 'catchword',
                        displayField: 'title',
                        valueField:   'uuid',
                        triggerAction: 'all',
                        forceSelection: true,
                        editable:false,
                        triggerAction: 'all'
                    })
                ]
            });
            
            var mywindow = new Ext.Window({
                
                title: 'Редактировать полосы',
                width: 300,
                height: 150,
                draggable:true,
                buttons: [{
                    text: "Ок",
                    handler: function() {
                        myform.getForm().submit();
                    }
                }, 
                {   text: Inprint.str.cancel,
                    handler: function() {
                        mywindow.hide();
                    }
                }],
                
                items: myform
            });
            
            myform.on("actioncomplete", function() {
                mywindow.hide();
                this.parent.cmpReload();
            }, this)
            
            this.dlgEdit = mywindow;
        }
        
        this.dlgEdit.setTitle('Редактировать полосу <'+ this.selected_as_string +'>');
        this.dlgEdit.show();
        
        var form = this.dlgEdit.items.itemAt(0).getForm();
        form.reset();
        
        form.baseParams.selection = this.selection;
    },
    
    //Удалить
    cmpRemove: function(inc) {
        if ( inc == 'no') return;
        if ( inc == 'yes') {
            Ext.Ajax.request({
                url: this.url.remove,
                params: {
                    fascicle: this.fascicle,
                    selection: this.selection
                },
                scope: this,
                success: function() { this.parent.cmpReload() },
                failure: Inprint.ajax.failure
            });
        } else {
            Ext.MessageBox.confirm(
                'Подтверждение',
                'Вы действительно хотите безвозвратно удалить полосы <'+ this.selected_as_string +'>?',
                this.cmpRemove, this
            );
        }
    },
    
    //Переместить
    cmpMove: function() {
        
        if (!this.dlgMove) {
            
            var myform = new Ext.FormPanel({
                
                url: this.url.move,
                
                baseParams: {
                    fascicle: this.fascicle
                },
                
                labelWidth: 100,
                defaultType: 'checkbox',
                defaults: { anchor: '100%' },
                bodyStyle: 'padding:5px 5px 0;',
                
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
            });
            
            var mywindow = new Ext.Window({
                
                title: 'Перенос полос',
                width: 400,
                height: 300,
                draggable:true,
                buttons: [{
                    text: "Перенести",
                    handler: function() {
                        myform.getForm().submit();
                    }
                }, 
                {   text: Inprint.str.cancel,
                    handler: function() {
                        mywindow.hide();
                    }
                }],
                
                items: myform
            });
            
            myform.on("actioncomplete", function() {
                mywindow.hide();
                this.parent.cmpReload();
            }, this)
            
            this.dlgMove = mywindow;
        }
        
        this.dlgMove.setTitle('Перенести полосу <'+ this.selected_as_string +'>');
        this.dlgMove.show();
        
        var form = this.dlgMove.items.itemAt(0).getForm();
        
        form.reset();
        form.findField('page').setValue( this.selected_as_string );
        form.baseParams.selection = this.selection;
        
    },
    
    // Стереть
    cmpClean: function() {
    
        if (!this.dlgClean) {
            
            var myform = new Ext.FormPanel({
                
                url: this.url.erase,
                
                baseParams: {
                    fascicle: this.fascicle
                },
                
                labelWidth: 60,
                defaultType: 'checkbox',
                defaults: { anchor: '100%' },
                bodyStyle: 'padding:5px 5px 0;',
                
                items: [{
                    xtype: 'checkbox',
                    name: 'documents',
                    checked:false,
                    inputValue: 'true',
                    fieldLabel: 'Стереть',
                    labelSeparator: ':',
                    boxLabel: 'Материалы'
                },{
                    xtype: 'checkbox',
                    name: 'advertisements',
                    checked:false,
                    inputValue: 'true',
                    fieldLabel: '',
                    labelSeparator: '',
                    boxLabel: 'Рекламу'
                }]
                
            });
            
            var mywindow = new Ext.Window({
                title: 'Очистка полос',
                width:250,
                height:140,
                draggable:true,
                buttons: [{
                    text: "Очистить",
                    handler: function() {
                        myform.getForm().submit();
                    }
                }, 
                {   text: Inprint.str.cancel,
                    handler: function() {
                        mywindow.hide();
                    }
                }],
                
                items: myform
            });
            
            myform.on("actioncomplete", function() {
                mywindow.hide();
                this.parent.cmpReload();
            }, this)
            
            this.dlgClean = mywindow;
        }
        
        this.dlgClean.setTitle('Очистить полосы <'+ this.selected_as_string +'>');
        this.dlgClean.show();
        
        var form = this.dlgClean.items.first().getForm();
        form.reset();
        form.baseParams.selection = this.selection;
    },

    // разверстать
    cmpResize: function() {
        if (!this.dlgResize) {
            
            var myform = new Ext.FormPanel({
                
                url: this.url.resize,
                
                baseParams: {
                    fascicle: this.fascicle
                },
                
                labelWidth: 100,
                defaultType: 'checkbox',
                defaults: { anchor: '100%' },
                bodyStyle: 'padding:5px 5px 0;',
                
                items: [{
                    xtype: 'box',
                    autoEl: {tag:'div', html: 'Пример: 1, 2, 5-8, 9:10 (9:10 добавит 10 полос после полосы 9).' },
                    cls: 'inprint-form-helpbox'
                },
                {
                    xtype: 'textfield',
                    name: 'page',
                    itemCls: 'required',
                    fieldLabel: 'На полосы'
                },{
                    xtype: 'checkbox',
                    name: 'documents',
                    checked:true,
                    inputValue: 'true',
                    fieldLabel: 'Скопировать',
                    labelSeparator: ':',
                    boxLabel: 'Материалы'
                },{
                    xtype: 'checkbox',
                    name: 'advertisements',
                    checked:false,
                    inputValue: 'true',
                    fieldLabel: '',
                    labelSeparator: '',
                    boxLabel: 'Рекламу'
                }]
            });
            
            var mywindow = new Ext.Window({
                
                title: 'Разверстка полос',
                width:320,
                height:240,
                draggable:true,
                buttons: [{
                    text: "Разверстать",
                    handler: function() {
                        myform.getForm().submit();
                    }
                }, 
                {   text: Inprint.str.cancel,
                    handler: function() {
                        mywindow.hide();
                    }
                }],
                
                items: myform
            });
            
            myform.on("actioncomplete", function() {
                mywindow.hide();
                this.parent.cmpReload();
            }, this)
            
            this.dlgResize = mywindow;
        }
        
        this.dlgResize.setTitle('Разверстать полосу <'+ this.selected_as_string +'>');
        this.dlgResize.show();
        
        var form = this.dlgResize.items.first().getForm();
        
        form.reset();
        form.baseParams.selection = this.selection;
    }
    
});
