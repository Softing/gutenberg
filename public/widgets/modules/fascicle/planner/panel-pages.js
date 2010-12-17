Inprint.fascicle.planner.Pages = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
        this.components = {};
        
        this.urls = {
            "read":   _url("/fascicle/pages/read/"),
            "create": _url("/fascicle/pages/create/"),
            "update": _url("/fascicle/pages/update/"),
            "delete": _url("/fascicle/pages/delete/"),
            "move":   _url("/fascicle/pages/move/"),
            "left":   _url("/fascicle/pages/left/"),
            "right":  _url("/fascicle/pages/right/"),
            "clean":  _url("/fascicle/pages/clean/"),
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
    
    getIdByNum: function(num) {
        var id = null;
        var nodes = this.view.getNodes();
        Ext.each(nodes, function(c){
            if (c.getAttribute("seqnum") == num) {
                id = c.id;
            }
        });
        return id;
    },
    
    getStore: function() {
        return this.view.getStore();
    },
    
    cmpGetSelected: function () {
        var result = [];
        var records = this.view.getSelectedNodes();
        Ext.each(records, function(c) {
            result.push(c.id +"::"+ c.getAttribute("seqnum"));
        }, this);
        return result;
    },

    cmpPageCreate: function() {
        
        var wndw = this.components["create"];
        
        if (!wndw) {
            
            wndw = new Ext.Window({
                title: 'Добавление полос',
                width: 300,
                height: 160,
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
                    defaults: { anchor: '100%', hideLabel: true },
                    bodyStyle: 'padding:10px;',
                    listeners: {
                        scope:this,
                        actioncomplete: function() {
                            wndw.hide();
                            this.parent.cmpReload();
                        }
                    },
                    items: [
                        {
                            xtype: 'textfield',
                            name: 'page',
                            emptyText: 'Полосы',
                            allowBlank:false
                        },
                        Inprint.factory.Combo.getConfig("/fascicle/combos/headlines/", {
                            allowBlank:true,
                            baseParams:{
                                fascicle: this.oid
                            },
                            listeners: {
                                beforequery: function(qe) {
                                    delete qe.combo.lastQuery;
                                }
                            }
                        }),
                        Inprint.factory.Combo.getConfig("/fascicle/combos/templates/", {
                            allowBlank:false,
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
            
            this.components["create"] = wndw;
        }
        
        var form = wndw.findByType("form")[0].getForm();
        form.reset();
        wndw.show();
        
    },

    // Редактировать
    cmpPageUpdate: function() {
        
        var wndw = this.components["update"];
        
        if (!wndw) {
            
            wndw = new Ext.Window({
                title: 'Редактировать полосы',
                width: 300,
                height: 160,
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
                    defaults: { anchor: '100%', hideLabel: true },
                    bodyStyle: 'padding:10px;',
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
            
            this.components["update"] = wndw;
        }
        
        wndw.show();
        
        var form = wndw.findByType("form")[0].getForm();
        form.reset();
        form.baseParams.page = this.cmpGetSelected();
        wndw.show();
    },
    
    cmpPageCompose: function() {
        
        var selection = this.cmpGetSelected();
        
        if (selection.length > 2) {
            return;
        }
        
        var grid = new Inprint.fascicle.planner.Modules();
        
        var pages = [];
        for (var c = 1; c < selection.length+1; c++) {
            var array = selection[c-1].split("::");
            pages.push(array[0]);
        }
        
        var selLength = selection.length;
        var flashItems = [];
        var flashWidth = 300;
        var flashLeft;
        var flashRight;

        flashLeft =  {
            id: 'flash-'+ pages[0],
            xtype: "flash",
            width:300,
            hideMode : 'offsets',
            url      : '/flash/Dispose.swf',
            expressInstall: true,
            flashVars: {
                src: '/flash/Dispose.swf',
                scale :'noscale',
                autostart: 'yes',
                loop: 'yes'
            },
            listeners: {
                scope:this,
                initialize: function(panel, flash) {
                    alert(2);
                },
                afterrender: function(panel) {
                     
                    var init = function () {
                        if (panel.swf.init) {
                            panel.swf.init(panel.getSwfId(), "letter", 0, 0);
                        } else {
                            init.defer(10, this);
                        }
                    };
                     
                    init.defer(10, this);
                    
                }
            }
        };
        
        flashItems.push( flashLeft );
        
        if ( selLength == 2 ) {
            
            flashWidth = 600;
            
            flashRight =  {
                id: 'flash-'+ pages[1],
                xtype: "flash",
                width:300,
                hideMode : 'offsets',
                url      : '/flash/Dispose.swf',
                expressInstall: true,
                flashVars: {
                    src: '/flash/Dispose.swf',
                    scale :'noscale',
                    autostart: 'yes',
                    loop: 'yes'
                },
                listeners: {
                    scope:this,
                    initialize: function(panel, flash) {
                        alert(2);
                    },
                    afterrender: function(panel) {
                         
                        var init = function () {
                            if (panel.swf.init) {
                                panel.swf.init(panel.getSwfId(), "letter", 0, 0);
                            } else {
                                init.defer(10, this);
                            }
                        };
                         
                        init.defer(10, this);
                        
                    }
                }
            };
            
            flashItems.push( flashRight );
        }
        
        win = new Ext.Window({
            width: flashWidth + 400,
            height:450,
            modal:true,
            layout: "border",
            closeAction: "hide",
            title: _("Adding a new category"),
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                {   region: "center",
                    margins: "3 0 3 3",
                    layout:"fit",
                    items: grid
                },
                {   region:"east",
                    margins: "3 3 3 0",
                    width: flashWidth,
                    minSize: 200,
                    maxSize: 600,
                    layout:"hbox",
                    layoutConfig: {
                        align : 'stretch',
                        pack  : 'start'
                    },
                    items: flashItems
                }
            ],
            listeners: {
                scope:this,
                afterrender: function(panel) {
                    panel.flashLeft = panel.findByType("flash")[0].swf;
                    panel.flashRight = panel.findByType("flash")[0].swf;
                    panel.grid  = panel.findByType("grid")[0];
                }
            },
            buttons: [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
        });
        
        win.show(this);
        this.components["compose-window"] = win;
    
        Ext.Ajax.request({
            url: this.urls["read"],
            params: {
                page: selection
            },
            scope: this,
            success: function(result, request) {
                
                var responce = Ext.util.JSON.decode(result.responseText);
                
                for (var c = 0; c < responce.data.length; c++) {
                    
                    var id = responce.data[c].id;
                    var swf = win.findById('flash-'+ id).swf;
                    var record = responce.data[c];
                    
                    swf.setGrid( record.w, record.h );
                }
            }
        });
        
    },
    
    //Переместить
    cmpPageMove: function(inc, text) {
        
        if ( inc == 'cancel') {
            return;
        }
        
        if ( inc == 'ok') {
            Ext.Ajax.request({
                url: this.urls["move"],
                params: {
                    fascicle: this.oid,
                    after: text,
                    page: this.cmpGetSelected()
                },
                scope: this,
                success: function() {
                    this.parent.cmpReload()
                }
            });
            return;
        }
        
        Ext.MessageBox.prompt(
            'Перемещение полос',
            'Укажите номер полосы, после которой будут размещены выбранные полосы',
            this.cmpPageMove, this
        );
        
    },
    
    cmpPageMoveLeft: function(inc, text) {
        
        if ( inc == 'cancel') {
            return;
        }
        
        if ( inc == 'ok') {
            Ext.Ajax.request({
                url: this.urls["left"],
                params: {
                    fascicle: this.oid,
                    amount: text,
                    page: this.cmpGetSelected()
                },
                scope: this,
                success: function() {
                    this.parent.cmpReload()
                }
            });
            return;
        }
        
        Ext.MessageBox.prompt(
            'Cмещение влево',
            'На сколько полос сместить?',
            this.cmpPageMoveLeft, this
        );
        
    },
    
    cmpPageMoveRight: function(inc, text) {
        
        if ( inc == 'cancel') {
            return;
        }
        
        if ( inc == 'ok') {
            Ext.Ajax.request({
                url: this.urls["right"],
                params: {
                    fascicle: this.oid,
                    amount: text,
                    page: this.cmpGetSelected()
                },
                scope: this,
                success: function() {
                    this.parent.cmpReload()
                }
            });
            return;
        }
        
        Ext.MessageBox.prompt(
            'Cмещение вправо',
            'На сколько полос сместить?',
            this.cmpPageMoveRight, this
        );
        
    },
    
    // Стереть
    cmpPageClean: function() {
    
        var wndw = this.components["clean"];
    
        if (!wndw) {
            
            var wndw = new Ext.Window({
                title: 'Удаление содержимого полосы',
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
                    defaults: { anchor: '100%', hideLabel:true },
                    bodyStyle: 'padding:10px;',
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
                            fieldLabel: '',
                            labelSeparator: ':',
                            boxLabel: 'Удалить материалы'
                        },
                        {
                            xtype: 'checkbox',
                            name: 'adverts',
                            checked:false,
                            inputValue: 'true',
                            fieldLabel: '',
                            labelSeparator: '',
                            boxLabel: 'Удалить рекламу'
                        }
                    ]
                },
                buttons: [
                    _BTN_WNDW_OK, 
                    _BTN_WNDW_CANCEL
                ]
            });
            
            this.components["clean"] = wndw;
        }
        
        var form = wndw.findByType("form")[0].getForm();
        form.reset();
        form.baseParams.page = this.cmpGetSelected();
        wndw.show();
    },

    // разверстать
    cmpPageResize: function() {
        
        var wndw = this.components["resize"];
        
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

            this.components["resize"] = wndw;
        }
        
        var form = wndw.findByType("form")[0].getForm();
        form.reset();
        form.baseParams.page = this.cmpGetSelected();
        wndw.show();
        
    },
    
    //Удалить
    cmpPageDelete: function(inc) {
        if ( inc == 'no') return;
        if ( inc == 'yes') {
            Ext.Ajax.request({
                url: this.urls["delete"],
                params: {
                    fascicle: this.oid,
                    page: this.cmpGetSelected()
                },
                scope: this,
                success: function() {
                    this.parent.cmpReload()
                }
            });
        } else {
            Ext.MessageBox.confirm(
                'Подтверждение',
                'Вы действительно хотите безвозвратно удалить полосы?',
                this.cmpPageDelete, this
            );
        }
    }
    
});
