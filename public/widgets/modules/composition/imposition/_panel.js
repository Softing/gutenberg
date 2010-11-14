/*
 * Inprint Content 4.0
 * Copyright(c) 2001-2009, Softing, LLC.
 * licensing@softing.ru
 *
 * http://softing.ru/license
 */

Inprint.composition.Main = Ext.extend(Ext.Panel, {
    
    initComponent: function() {

        this.url = {
            session: '/composite2/check/',
            capture: '/composite2/capture/',
            begin:   '/composite2/begin/',
            save:    '/composite2/save/',
            end:     '/composite2/end/'
        };
        
        var access = {
            canEdit: false
        };
        
        this.fascicle = this.oid;
        
        /* Buttons */
        
        this.btnAdd = new Ext.Button({
            id: "add",
            disabled:true,
            text: "Добавить полосу",
            tooltip: 'Добавить новые полосы в этот выпуск',
            icon: _icon("plus-button"),
            cls: 'x-btn-text-icon',
            scope: this,
            handler: this.cmpAdd
        });
        
        this.btnEdit = new Ext.Button({
            id: "edit",
            disabled:true,
            text:'Редактировать',
            icon: _icon("pencil"),
            cls: 'x-btn-text-icon',
            scope: this,
            handler: this.cmpEdit
        });
        
        this.btnRemove = new Ext.Button({
            id: "remove",
            disabled:true,
            text: 'Удалить',
            tooltip: 'Удалить полосы',
            icon: _icon("minus-button"),
            cls: 'x-btn-text-icon',
            scope:this,
            handler: this.cmpRemove
        });
        
        this.btnMove = new Ext.Button({
            id: "move",
            disabled:true,
            text:'Перенести',
            tooltip: 'Перенести отмеченные полосы',
            icon: _icon("navigation-000-button"),
            cls: 'x-btn-text-icon',
            scope:this,
            handler: this.cmpMove
        });
        
        this.btnClean = new Ext.Button({
            id: "clean",
            disabled:true,
            text: 'Очистить',
            tooltip: 'Очистить содержимое полос',
            icon: _icon("eraser"),
            cls: 'x-btn-text-icon',
            scope:this,
            handler: this.cmpErase
        });
        
        this.btnResize = new Ext.Button({
            id: "resize",
            disabled:true,
            text: 'Разверстать',
            tooltip: 'Добавить новые полосы скопировав содержимое',
            icon: _icon("arrow-resize-045"),
            cls: 'x-btn-text-icon',
            scope:this,
            handler: this.cmpResize
        });
        
        /* Save button */
        
        this.btnSave = new Ext.Button({
            id: "save",
            disabled:true,
            text: 'Сохранить',
            tooltip: 'Сохранить изменения в компоновке выпуска',
            icon: _icon("disk-black"),
            cls: 'x-btn-text-icon',
            scope:this,
            handler: this.cmpSave
        });
        
        /* Session buttons */
        
        this.btnBeginSession = new Ext.Button({
            icon: _icon("control"),
            cls: 'x-btn-text-icon',
            hidden:false,
            text: 'Открыть сеанс',
            tooltip: 'Открыть сеанс редактирования',
            scope: this,
            handler: this.beginEdit
        });
        
        this.btnCaptureSession = new Ext.Button({
            icon: _icon("hand"),
            cls: 'x-btn-text-icon',
            hidden:true,
            text: 'Захватить сеанс',
            tooltip: 'Захватить сеанс редактирования',
            scope: this,
            handler: this.captureSession
        });
        
        this.btnEndSession = new Ext.Button({
            icon: _icon("control-stop-square"),
            cls: 'x-btn-text-icon',
            hidden:true,
            text: 'Закрыть сеанс',
            tooltip: 'Закрыть сеанс редактирования',
            scope: this,
            handler: this.endEdit
        });
        
        this.btnLoadSession = new Ext.Button({
            hidden:true,
            text: 'Загрузить версию',
            tooltip: 'Загрузить другую версию компоновки',
            scope: this,
            handler: this.loadVersion
        });
        
        Ext.apply(this, {
            layout: 'border',
            stateful : true,
            stateId : 'planner-layout1-'+ this.fascicle,
            items: [
                {
                    region: 'center',
                    layout: 'border',
                    stateful : true,
                    stateId : 'planner-layout2-'+ this.fascicle,
                    items: [
                        {
                            region: 'center',
                            xtype: "PlanningPage",
                            style: "border-bottom:1px solid #D0D0D0;border-right:1px solid #D0D0D0;",
                            parent: this,
                            fascicle: this.fascicle
                        },
                        {
                            region: 'south',
                            split: true,
                            collapseMode:'mini',
                            collapsible: true,
                            height:300,
                            xtype: "PlanningDocument",
                            style: "border-top:1px solid #D0D0D0;border-right:1px solid #D0D0D0;",
                            parent: this,
                            fascicle: this.fascicle
                        }
                    ]
                },
                {
                    region: 'east',
                    split: true,
                    collapseMode:'mini',
                    collapsible: true,
                    width:400,
                    xtype: "PlanningAdvertising",
                    style: "border-left:1px solid #D0D0D0",
                    parent: this,
                    fascicle: this.fascicle
                }
            ],
            
            tbar: [
                
                this.btnAdd,
                this.btnEdit,
                this.btnRemove,
                "-",
                this.btnMove,
                //"-",
                this.btnClean,
                //this.btnResize,
                "-",
                {
                    text: 'Печать А3',
                    icon: _icon("printer"),
                    cls: 'x-btn-text-icon',
                    scope:this, 
                    handler: function() {
                        this.cmpPrintPage({ mode:'landscape', size:'a3' });
                    }
                },
                {
                    text: 'Печать А4',
                    icon: _icon("printer"),
                    cls: 'x-btn-text-icon',
                    scope:this, 
                    handler: function() {
                        this.cmpPrintPage({ mode:'landscape', size:'a4' });
                    }
                },
                "->",
                this.btnSave,
                "-",
                this.btnBeginSession,
                this.btnCaptureSession,
                this.btnEndSession
            ]
            
        });
        
        Inprint.composition.Main.superclass.initComponent.apply(this, arguments);
        
        this.addEvents('enableButtons', 'disableButtons');
    },

    onRender: function() {
        
        Inprint.composition.Main.superclass.onRender.apply(this, arguments);
        
        this.on("enableButtons", function() {
            this.getTopToolbar().items.get('add').enable();
            this.getTopToolbar().items.get('save').enable();
        }, this);
        
        this.on("disableButtons", function() {
            this.getTopToolbar().items.get('add').disable();
            this.getTopToolbar().items.get('save').disable();
        }, this);
        
        this.body.mask("Проверка прав на редактирование...");
        this.cmpInitSession();
        
    },
    
    /* Load session */
    
    cmpInitSession: function () {
        
        Ext.Ajax.request({
            url: this.url.session,
            scope: this,
            params: {
                fascicle: this.fascicle
            },
            callback: function() {
                this.body.unmask();
            },
            success: function(response) {
                var rsp = Ext.util.JSON.decode(response.responseText)
                
                this.cmpUpdateTitle(rsp);
                this.cmpUpdateAccess(rsp);
                
                var panel1 = this.layout.east.panel; // Advert
                var panel2 = this.layout.center.panel.layout.center.panel; //Pages
                var panel3 = this.layout.center.panel.layout.south.panel; //Documents
                
                panel1.getStore().loadData(rsp.advertisement);
                panel2.getStore().loadData(rsp.pages);
                
            },
            failure: Inprint.ajax.failure
        });
        
    },
    
    cmpCheckSession: function () {
        
        Ext.Ajax.request({
            url: this.url.session,
            scope: this,
            params: {
                fascicle: this.fascicle
            },
            callback: function() {
                this.body.unmask();
            },
            success: function(response) {
                var rsp = Ext.util.JSON.decode(response.responseText)
                
                this.cmpUpdateTitle(rsp);
                this.cmpUpdateAccess(rsp);
                
            },
            failure: Inprint.ajax.failure
        });
        
    },
    
    captureSession: function() {
        this.body.mask("Попытка захвата редактирования...");
        Ext.Ajax.request({
            url: this.url.capture,
            scope: this,
            params: {
                fascicle: this.fascicle
            },
            success: function(response) {
                var rsp = Ext.util.JSON.decode(response.responseText)
                
                if (!rsp.success && rsp.error[0]) {
                    alert("Ошибка захвата сессии, код ошибки <"+rsp.error[0].id+">");
                }
                
                this.cmpCheckSession();
            },
            failure: Inprint.ajax.failure
        });
    },
    
    /* Begin editing */
    
    beginEdit: function() {
        
        this.body.mask("Проверка прав на редактирование...");
        
        Ext.Ajax.request({
            url: this.url.begin,
            scope: this,
            params: {
                fascicle: this.fascicle
            },
            success: function(response) {
                var rsp = Ext.util.JSON.decode(response.responseText)
                
                if (!rsp.success && rsp.error[0]) {
                    alert("Ошибка захвата сессии, код ошибки <"+rsp.error[0].id+">");
                }
                
                this.cmpCheckSession();
                
            },
            failure: Inprint.ajax.failure
        });
    },
    
    /* End editing */
    
    endEdit: function() {
        
        this.body.mask("Проверка прав на редактирование...");
        
        Ext.Ajax.request({
            url: this.url.end,
            scope: this,
            params: {
                fascicle: this.fascicle
            },
            success: function(response) {
                var rsp = Ext.util.JSON.decode(response.responseText)
                
                if (!rsp.success && rsp.error[0]) {
                    alert(rsp.error[0].id);
                }
                
                this.cmpCheckSession();
            },
            failure: Inprint.ajax.failure
        });
    },
    
    /* Print imposition plan */
    
    cmpPrintPage: function(opt) {
        window.location = '/composite2/pdf/?fascicle='+ this.fascicle +'&mode='+opt.mode+'&size='+opt.size;
    },
    
    /* save composition */
    
    cmpSave: function() {
        
        var panel1 = this.layout.east.panel; // advert
        var panel2 = this.layout.center.panel.layout.center.panel; // pages
        var panel3 = this.layout.center.panel.layout.south.panel; // documents
        
        var data1 = [];
        var data2 = [];
        
        // get documents changes
        
        var records1 = panel3.getStore().getModifiedRecords();
        if(records1.length) {
            Ext.each(records1, function(r, i) {
                var o = r.getChanges();
                if(r.data.newRecord) {
                    o.newRecord = true;
                }
                o.uuid = r.get('uuid');
                data1.push(o.uuid +'::'+ o.page_str);
            }, this);
        }
        
        // get advert changes
        
        var records2 = panel1.getStore().getModifiedRecords();
        if(records2.length) { 
            Ext.each(records2, function(r, i) {
                var o = r.getChanges();
                if(r.data.newRecord) {
                    o.newRecord = true;
                }
                o.uuid = r.get('uuid');
                data2.push(o.page+'::'+o.uuid);
            }, this);
        }
        
        // save state
        
        this.body.mask("Сохранение данных");
        
        var o = {
            url:this.url.save,
            params:{
                fascicle: this.fascicle,
                documents: data1,
                advertising: data2
            },
            scope:this,
            success: function () {
                
                panel1.getStore().rejectChanges();
                panel3.getStore().rejectChanges();
                
                this.cmpReload();
            },
            failure: Inprint.ajax.failure
        };
        
        Ext.Ajax.request(o);
        
    },
    
    cmpUpdateTitle: function(rsp) {
        
        //Планирование выпуска "Март, 2009" / Полос ХХХ, в том числе рекламных УУ,ZZ (38,6%). Заявок на рекламу AA,BB полос (31,3%)
        
        var titlestr = '<div style="padding-left:21px;background:url(' + this.icon + ') 0px -2px no-repeat;"><a href="/?part=' + this.sitepart + '&page=' + this.sitepage;
        if (this.oid) titlestr += '&oid=' + this.oid;
        titlestr += '&text=' + this.rawTitle + '" onClick="return false;">' + this.rawTitle + '</a>';
        
        if (rsp.owner) {
            titlestr += '&nbsp;[<b>Работает '+ rsp.name +'</b>]';
        }
        
        titlestr += '&nbsp;[Полос&nbsp;'+ rsp.pc +'='+ rsp.dc +'+'+ rsp.ac;
        titlestr += '&nbsp;|&nbsp;'+ rsp.dav +'%/'+ rsp.aav +'%]';
        
        //titlestr += "&nbsp;[Полос&nbsp;"+ rsp.pc +',&nbsp;в&nbsp;том&nbsp;числе&nbsp;рекламных '+ rsp.ac +"&nbsp;("+ rsp.aav +").&nbsp;";
        //titlestr += "Заявок&nbsp;на&nbsp;рекламу&nbsp;"+ rsp.ac +",&nbsp;полос&nbsp;("+ rsp.aav +"%)]";
        
        titlestr += '</div>';
        
        this.setTitle(titlestr);
    },
    
    cmpUpdateAccess: function(rsp) {
        if (rsp.owner && rsp.owned == 'no') {
            this.btnCaptureSession.show();
            this.btnBeginSession.show();
            this.btnEndSession.hide();
            this.btnLoadSession.hide();
            this.sessionIsActive = false;
            this.fireEvent('disableButtons', this);
        } else if (rsp.owner && rsp.owned == 'yes') {
            this.btnCaptureSession.hide();
            this.btnBeginSession.hide();
            this.btnEndSession.show();
            this.btnLoadSession.hide();
            this.sessionIsActive = true;
            this.fireEvent('enableButtons', this);
        } else {
            this.btnCaptureSession.hide();
            this.btnBeginSession.show();
            this.btnEndSession.hide();
            this.btnLoadSession.show();
            this.sessionIsActive = false;
            this.fireEvent('disableButtons', this);
        }
    },
    
    cmpOnClose: function(inc) {

        if (inc == 'no') {
            return false;
        } else if ( inc == 'yes') {
            this.endEdit();
            Inprint.layout.remove(this);
            return true;
        }
        
        if (this.sessionIsActive) {
            var mbx = Ext.MessageBox.confirm(
                'Подтверждение',
                'Закрыть сессию перед закрытием вкладки?',
                this.cmpOnClose, this
            );
            return false;
        }
        
        return true;
    },
    
    /* Reload active panels */
    
    cmpReload: function() {
        
        this.loaded = 3;
        
        var panel1 = this.layout.east.panel; // Advert
        var panel2 = this.layout.center.panel.layout.center.panel; //Pages
        var panel3 = this.layout.center.panel.layout.south.panel; //Documents
        
        panel3.cmpReload();
        
        this.body.mask("Загрузка данных");
        
        Ext.Ajax.request({
            url: this.url.session,
            scope: this,
            params: {
                fascicle: this.fascicle
            },
            callback: function() {
                this.body.unmask();
            },
            success: function(response) {
                var rsp = Ext.util.JSON.decode(response.responseText)
                
                this.cmpUpdateTitle(rsp);
                this.cmpUpdateAccess(rsp);
                
                var panel1 = this.layout.east.panel; // Advert
                var panel2 = this.layout.center.panel.layout.center.panel; //Pages
                var panel3 = this.layout.center.panel.layout.south.panel; //Documents
                
                panel1.cmpLoadData(rsp.advertisement);
                panel2.cmpLoadData(rsp.pages);
                
            },
            failure: Inprint.ajax.failure
        });
        
    }
    
});