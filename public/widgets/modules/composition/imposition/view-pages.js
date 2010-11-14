/*
 * Inprint Content 4.0
 * Copyright(c) 2001-2009, Softing, LLC.
 * licensing@softing.ru
 *
 * http://softing.ru/license
 */

Inprint.composition.Page = Ext.extend(Ext.Panel, {
    
    initComponent: function() {
        
        this.editable = false;
        
        /* URLS */
        
        this.url = {
            add:        '/composite2/page/add/',
            edit:       '/composite2/page/edit/',
            remove:     '/composite2/page/remove/',
            move:       '/composite2/page/move/',
            erase:      '/composite2/page/erase/',
            resize:     '/composite2/page/resize/'
        };
        
        /* Template */
        
        var tmpl = new Ext.XTemplate('<div class="inprint-planner-view">',
              '<table>',
              '<tpl for=".">',
                  '<tpl if="type == \'page\' ">',
                      '<td valign="top">',
                          '<div class="inprint-planner-catchword">  {catchword}  </div>',
                              '<div id="{uuid}" class="inprint-planner-box inprint-planner-box-status-{status} inprint-planner-box-age-{age}" style="border:1px solid {color};">',
                              '<div class="advert">',
                                  '<tpl for="advert">',
                                      '<span>{size}</span>',
                                  '</tpl>',
                              '</div>',
                              '<tpl for="documents">',
                                  '<div class="text">',
                                      '<div>',
                                          '<div style="width:5px;height:7px;float:left;margin:3px 1px 0px 0px;background:{color};"></div>',
                                          "<a style=\"text-decoration:none;\" href=\"/?part=documents&page=formular&oid={uuid}&text={title}\" onClick=\"Inprint.objResolver('documents', 'formular', { oid:'{uuid}', text:'{title}' });return false;\">{title}</a>",
                                          '<div style="padding:2px 2px 2px 2px;"><nobr>{page_str}</nobr></div>',
                                      '</div>',
                                  '</div>',
                              '</tpl>',
                              '<img src="/data/im/st.gif" width="80" height="1">',
                          '</div>',
                          '<div class="inprint-planner-number" align="center"><span>{seqnum}</span></div>',
                      '</td>',
                  '</tpl>',
                  '<tpl if="type == \'blank\' ">',
                      '<td valign="top">',
                          '<div class="inprint-planner-catchword">{catchword}</div>',
                          '<div id="{seqnum}" seqnum="{number}" class="inprint-planner-box inprint-planner-box-blank">',
                              '<img src="/data/im/st.gif" width="80" height="1">',
                          '</div>',
                          '<div class="inprint-planner-number" align="center"><span>{seqnum}</span></div>',
                      '</td>',
                  '</tpl>',
                  '<tpl if="type == \'clean\' ">',
                      '<td valign="top">',
                          '<div class="inprint-planner-box-free">',
                              '<img src="/data/im/st.gif" width="92" height="1">',
                          '</div>',
                      '</td>',
                  '</tpl>',
                  '<tpl if="type == \'newline\'">',
                      '<td>',
                      '<div class="inprint-planner-spacer">',
                      '</div>',
                      '</td>',
                      '</table>',
                      '<table class="thumb-wrap">',
                  '</tpl>',
              '</tpl>',
              '</table>',
              '<div class="x-clear"></div>',
          '</div>');
        
        
        /* Component initialization */
        
        this.dataView = new Ext.DataView({
                
            autoWidth:true,
            autoHeight:true,
            simpleSelect: true,
            multiSelect: true,
            loadingText:'Загрузка',
            emptyText: 'Полосы не найдены',
            overClass:'x-view-over',
            itemSelector:'div.inprint-planner-box',
            tpl: tmpl,
            
            store: new Ext.data.Store({
                autoLoad:false,
                baseParams: {
                    fascicle: this.fascicle
                },
                proxy: new Ext.data.HttpProxy({ url: this.url.load }),
                reader: new Ext.data.ArrayReader({
                    id: 4,
                    fields: [ 'type', 'status', 'seqnum', 'color', 'uuid', 'catchword', 'age',  'documents', 'advert' ]
                })
            }),
            
            listeners: {
                scope: this,
                
                // При изменении выбора в DataView
                selectionchange: function(panel,nodes) {
                    
                    this.selection = [];
                    var data = [];
                    
                    // проходим по текущей выборке
                    for (var i = 0; i < nodes.length; i++) {
                        // выбираем запись
                        var record = panel.store.getById( nodes[i].id );
                        if (record) {
                            // сохраняем выбранные id  в массиве
                            this.selection.push( record.data.uuid +'::'+ record.data.seqnum );
                            // сохраняем номера полос в массиве
                            data.push(record.data.seqnum);
                        }
                    }
                    
                    // сортируем номера полос по возрастанию
                    data.sort( function (a,b){ return a - b; });
                    
                    // приводим периоды полос в удобный вид
                    this.selected_as_string = '';
                    for ( i = 0; i < data.length; i++) {
                    
                        var current     = parseInt( data[i], 10 );
                        var prev    = parseInt( data[i - 1], 10 );
                        var next    = parseInt( data[i + 1], 10 );
                        
                        if (!prev) {
                            this.selected_as_string += current;
                        }
                        else if (current - 1 == prev && current + 1 == next) {
                            //selected_as_string += '.';
                        }
                        else if (current - 1 == prev && current + 1 != next) {
                            this.selected_as_string += '-' + current;
                        } else {
                            this.selected_as_string += ', ' + current;
                        }
                    }
                    
                    //отрабатываем тулбар
                    var tb = this.parent.getTopToolbar();
                    
                    if ( nodes.length == 0 ) {
                        tb.items.get('edit').disable();
                        tb.items.get('remove').disable();
                        tb.items.get('move').disable();
                        tb.items.get('clean').disable();
                        //tb.items.get('resize').disable();
                    }
                    
                    if ( nodes.length == 1 ) {
                        tb.items.get('edit').enable();
                        tb.items.get('remove').enable();
                        tb.items.get('move').enable();
                        tb.items.get('clean').enable();
                        //tb.items.get('resize').enable();
                    }

                    if ( nodes.length > 1 ) {
                        tb.items.get('edit').enable();
                        tb.items.get('remove').enable();
                        tb.items.get('move').enable();
                        tb.items.get('clean').enable();
                        //tb.items.get('resize').disable();
                    }
                }
            }
        });
        
        Ext.apply(this, {
            layout: 'fit',
            autoScroll:true,
            bodyStyle:'padding:8px 0px 0px 8px',
            items: this.dataView
        });
        
        Inprint.composition.Page.superclass.initComponent.apply(this, arguments);
        
    },
    
    onRender: function() {
        
        Inprint.composition.Page.superclass.onRender.apply(this, arguments);
        
        this.dataView.on("beforeselect", function() {
            return this.editable
        }, this);
        
        this.parent.on('enableButtons', function(parent) {
            this.editable = true;
        }, this);
        
        this.parent.on('disableButtons', function(parent) {
            this.editable = false;
        }, this);
        
        var tb = this.parent.getTopToolbar();
        
        tb.items.get('add').on("click", this.cmpAdd, this);
        tb.items.get('edit').on("click", this.cmpEdit, this);
        tb.items.get('remove').on("click", this.cmpRemove, this);
        tb.items.get('move').on("click", this.cmpMove, this);
        tb.items.get('clean').on("click", this.cmpClean, this);
        //tb.items.get('resize').on("click", this.cmpResize, this);
        
        this.getStore().on("load", function(){
            if (this.scrollTop && this.scrollHeight) {
                this.body.dom.scrollTop = this.scrollTop + (this.scrollTop == 0 ? 0 : this.body.dom.scrollHeight - this.scrollHeight);
            }
        }, this);
        
    },
    
    /* Добавление полос в выпуск */
    
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
                        //itemCls: 'required',
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
    },
    
    getStore: function() {
        return this.items.itemAt(0).getStore();
    },
    
    /* Reload imposition layout */
    
    cmpLoadData: function(data) {
        this.scrollTop = this.body.dom.scrollTop;
        this.scrollHeight = this.body.dom.scrollHeight;
        
        this.getStore().loadData(data);
    }
    
});
