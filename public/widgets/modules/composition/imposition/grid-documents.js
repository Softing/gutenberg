/*
 * Inprint Content 4.0
 * Copyright(c) 2001-2009, Softing, LLC.
 * licensing@softing.ru
 *
 * http://softing.ru/license
 */

Inprint.composition.Document = Ext.extend(Ext.grid.EditorGridPanel, {
    
    initComponent: function() {
        
        this.editable = false;
        
        this.url = {
            add: '/document/action/add/',
            edit: '/document/action/edit/',
            frombriefcase: '/composite2/document/move-from-briefcase/',
            tobriefcase: '/composite2/document/move-to-briefcase/',
            tofascicle: '/composite2/document/move-to-fascicle/',
            totrash: '/composite2/document/move-to-trash/'
        }
        
        var sm = new Ext.grid.CheckboxSelectionModel();
        
        var cm = new Ext.grid.ColumnModel([
            sm,
            {
                id : 'group',
                dataIndex : 'groupname',
                header : "Группа",
                width : 50,
                sortable : true,
                hidden : true
            },
        
            {
                id : 'btn_view',
                fixed : true,
                menuDisabled : true,
                header : '&nbsp;',
                width : 26,
                sortable : true,
                renderer : Inprint.article.renderers.icon2
            },
         
            {
                id : 'title',
                dataIndex : 'title',
                header : "Название",
                width : 300,
                sortable : true,
                renderer : Inprint.article.renderers.title,
		editor: new Ext.form.TextField({
                    allowBlank: true
                })
            }, 
            {
                id : 'fascicle',
                dataIndex : 'fascicle',
                header : "Выпуск",
                width : 90,
                sortable : true,
                renderer : Inprint.article.renderers.fascicle
            }, 
            {
                id : 'page',
                dataIndex : 'page_str',
                header : "Полоса",
                width : 90,
                sortable : true,
//		renderer : function(v, p, r) {
//                    return r.data.page_str;
//                },
                editor: new Ext.form.TextField({
                    allowBlank: true
                })
            }, 
            {
                id : 'section',
                dataIndex : 'section_name',
                header : "Раздел",
                width : 100,
                sortable : true
            }, 
            {
                id : 'rubric',
                dataIndex : 'rubric_name',
                header : "Рубрика",
                width : 100,
                sortable : true
            }, 
            {
                id : 'department',
                dataIndex : 'department_name',
                header : "Отдел",
                width : 100,
                sortable : true
            }, 
            {
                id : 'manager',
                dataIndex : 'manager_nick',
                header : "Редактор",
                width : 100,
                sortable : true
            }, 
            {
                id : 'status',
                dataIndex : 'complete',
                header : "Готовность",
                width : 100,
                sortable : true,
                renderer : Inprint.article.renderers.date
            }, 
            {
                id : 'owner',
                dataIndex : 'owner_nick',
                header : "В&nbsp;работе",
                width : 100,
                sortable : true
            }, 
            {
                id : 'image',
                dataIndex : 'image_count',
                header : '<img src="'+ _icon("camera") +'">',
                width : 30,
                sortable : true
            }, 
            {
                id : 'size',
                dataIndex : 'planned_size',
                header : '<img src="'+ _icon("edit") +'">',
                width : 50,
                sortable : true,
                renderer : function(v, p, r) {
                    return r.data.calibr_real || r.data.planned_size || 0;
                }
            },
	    {
		id: 'firstpage',
		sortable:true,
		dataIndex: 'firstpage',
		header:'Первая полоса',
		width:30,
		hidden:true
	    }
        ]);
        
        // Create Grid store
        var store = new Ext.data.GroupingStore({
            autoLoad : false,
            loadMask: false,
            groupField : 'section_name',
            //groupOnSort: true,
	    
	    remoteGroup:false,
	    remoteSort:false,
	    
            sortInfo : {
                field : 'firstpage',
                direction : "ASC"
            },
            baseParams : {
                edition : Inprint.session.edition,
                fascicle: this.fascicle
            },
            proxy : new Ext.data.HttpProxy({
                url : '/document/list/'
            }),
            reader : new Ext.data.JsonReader({
                root : 'data',
                totalProperty : 'count',
                idProperty : 'uuid',
                fields : [
                    'access', 'author', 'bildeditor',
                    'bildeditor_name', 'block',
                    'calibr_real', 'chain', 'chain_title',
                    'department', 'department_name',
                    'planned_date', 'edition',
                    'edition_name', 'edition_sname',
                    'fascicle', 'fascicle_name', 
		    {name:'firstpage',mapping:'firstpage',type:'int'},
		    'green',
                    'groupname', 'id', 'image_count',
                    'look', 'manager', 'manager_nick',
                    'owner_nick', 'page', 
		    {name:'page_str',type:'string'},
                    'planned_size', 'real_date', 'rubric',
                    'rubric_name', 'section',
                    {name:'section_name',type:'string'}, 'complete', 'color',
                    'stage', 'title', 'theowner', 'uuid'
                ]
            })
        });
        
        store.load({
            params : {
                type : this.cmpType
            }
        });
        
        /* Grid view */
        
        var view = new Ext.grid.GroupingView({
            forceFit : false,
            deferEmptyText : false,
            emptyText : 'Подходящие материалы не найдены'
        });
        
        /* Buttons */
        
        this.btnAdd = new Ext.Button({
            id:'add',
            text: "Добавить материал",
            disabled:true,
            icon: _icon("plus-button"),
            cls: 'x-btn-text-icon',
            scope:this,
            handler : this.cmpAdd
        });
        
        this.btnEdit = new Ext.Button({
            id:'edit',
            text: Inprint.str.edit,
            disabled:true,
            icon: _icon("pencil"),
            cls: 'x-btn-text-icon',
            scope:this,
            handler : this.cmpEdit
        });
        
        this.btnToBriefcase = new Ext.Button({
            id:'toBriefcase',
            text: 'В портфель',
            disabled:true,
            icon: _icon("briefcase--arrow"),
            cls: 'x-btn-text-icon',
            scope:this,
            handler : this.cmpMoveToBriefcase
        });
        
        this.btnToFascicle = new Ext.Button({
            id:'toFascicle',
            text: 'В выпуск',
            disabled:true,
            icon: _icon("newspaper--arrow"),
            cls: 'x-btn-text-icon',
            scope:this,
            handler : this.cmpMoveToFascicle
        });
        
        this.btnToTrash = new Ext.Button({
            id:'toTrash',
            text: 'В корзину',
            disabled:true,
            icon: _icon("bin--arrow"),
            cls: 'x-btn-text-icon',
            scope:this,
            handler : this.cmpMoveToTrash
        });
        
        this.btnBriefcase = new Ext.Button({
            id:'showBriefcase',
            text: 'Портфель',
            disabled:true,
            icon: _icon("briefcase"),
            cls: 'x-btn-text-icon',
            scope:this,
            handler : this.cmpShowBriefcase
        });
        
        Ext.apply(this, {
            
            loadMask: false,
            layout : 'fit',
            sm : sm,
            cm : cm,
            store : store,
            stateful : true,
            stateId : 'planner-document-grid-'+ Inprint.session.uuid,
            stripeRows : true,
            trackMouseOver : false,
            enableHdMenu : true,
            enableDragDrop : false,
            enableColumnResize : true,
            enableColumnMove : true,
            enableColumnHide : true,
            view : view,
            
            tbar: [
                this.btnAdd,
                this.btnEdit,
                "-",
                this.btnToFascicle,
                this.btnToBriefcase,
                this.btnToTrash,
                "-",
                {
                    id: "departments",
                    width:120,
                    disabled:true,
                    xtype : 'inprint.combos.departments',
                    hideLabel : true,
                    clearable : true
                },
                {
                    id: "sections",
                    width:120,
                    disabled:true,
                    xtype : 'inprint.combos.sections',
                    hideLabel : true,
                    clearable : true
                },
                {
                    id: "rubrics",
                    width:120,
                    disabled:true,
                    xtype : 'inprint.combos.rubrics',
                    hideLabel : true,
                    clearable : true
                },
                new Ext.Button({
                    id: "search",
                    disabled:true,
                    icon: _icon("magnifier-left"),
                    cls: 'x-btn-icon',
                    tooltip : 'Применить фильтр',
                    scope : this,
                    handler : this.cmpReload
                }),
		'-',
		{
                    id: "sortup",
		    icon: _icon("sort-number"),
                    cls: 'x-btn-icon',
                    disabled:true,
		    tooltip:'Сортировать по полосам',
		    scope:this,
		    handler: function() {
			this.getStore().sort('firstpage', 'ASC');
		    }
                },
                '->',
                this.btnBriefcase		
            ]
        });
        
        Inprint.composition.Document.superclass.initComponent.apply(this, arguments);
        
    },
    
    onRender: function() {
        
        Inprint.composition.Document.superclass.onRender.apply(this, arguments);
        
        this.getSelectionModel().lock();
        
        this.on("beforeedit", function() {
            return this.editable
        }, this);
        
        /* Grid selections */
        
        this.on("rowclick", function(grid, rowIndex, e) {
            if (this.getSelectionModel().getCount() == 0) {
                this.topToolbar.items.get('edit').disable();
                this.topToolbar.items.get('toFascicle').disable();
                this.topToolbar.items.get('toBriefcase').disable();
                this.topToolbar.items.get('toTrash').disable();
            } else {
                this.topToolbar.items.get('edit').enable();
                this.topToolbar.items.get('toFascicle').enable();
                this.topToolbar.items.get('toBriefcase').enable();
                this.topToolbar.items.get('toTrash').enable();
            }
            
        }, this);
        
        /* Filter */
        
        var section = this.getTopToolbar().items.get("sections");
        var rubric = this.getTopToolbar().items.get("rubrics");
        
        section.resetStore({
           fascicle : this.fascicle
        });
        
        section.on("select", function(field, record, index) {
            rubric.enable();
            rubric.resetStore({
               section : record.data.uuid
            });
        });
        
        section.on("clear", function(field, record, index) {
            rubric.disable();
            rubric.CmpClear();
        });
        
        this.on('show', function(){
            this.parent.cmpReload();
        }, this);
        
        /* Parent */
        
        this.parent.on('enableButtons', function(parent) {
            
            this.editable = true;
            
            this.getSelectionModel().clearSelections();
            this.getSelectionModel().unlock();
            
            this.getTopToolbar().items.get('add').enable();
            this.getTopToolbar().items.get('departments').enable();
            this.getTopToolbar().items.get('sections').enable();
            this.getTopToolbar().items.get('search').enable();
            this.getTopToolbar().items.get('sortup').enable();	    
            this.getTopToolbar().items.get('showBriefcase').enable();
            
        }, this);
        
        this.parent.on('disableButtons', function(parent) {
            
            this.editable = false;
            
            this.getSelectionModel().clearSelections();
            this.getSelectionModel().lock();
            
            this.getTopToolbar().items.get('add').disable();
            this.getTopToolbar().items.get('edit').disable();
            this.getTopToolbar().items.get('departments').disable();
            this.getTopToolbar().items.get('sections').disable();
            this.getTopToolbar().items.get('search').disable();
            this.getTopToolbar().items.get('showBriefcase').disable();
            
        }, this);
        
    },
    
    cmpAdd:function() {
        
        if (!this.dlgAdd) {
            
            var myform = new Ext.FormPanel({
                
                url: this.url.add,
                
                baseParams: {
                    session: null,
                    edition : Inprint.session.edition,
                    fascicle: this.fascicle
                },
                
                labelWidth: 100,
                defaults: { anchor: '100%' },
                bodyStyle: 'padding:0px 10px;',
                
                items: [
                
                    {   xtype: 'box',
                        autoEl: {tag:'div', html: "Обязательные параметры" },
                        cls: 'inprint-form-message'
                    },
                    
                    {   xtype : 'textarea',
                        name : 'title',
                        fieldLabel : 'Название',
                        allowBlank : false,
                        maxLength : 200,
                        height : 40
                    }, {
                        xtype : 'textarea',
                        allowBlank : true,
                        name : 'author',
                        fieldLabel : 'Автор',
                        maxLength : 250,
                        height : 50
                    },
                    
                    {   xtype: 'box',
                        autoEl: {tag:'div', html: "Назначение редактора" },
                        cls: 'inprint-form-message'
                    },
                    
                    {   xtype : 'inprint.combos.departments',
                        allowBlank : true,
                        clearable : true,
                        listeners : {
                            scope : this,
                            clear : function(field) {
                                myform.getForm().findField('manager').resetStore({
                                    edition : Inprint.session.edition
                                });
                            },
                            select : function(field) {
                                myform.getForm().findField('manager').resetStore({
                                    edition : Inprint.session.edition,
                                    department : field.getValue()
                                });
                            }
                        }
                    },
                    {       xtype : 'inprint.combos.managers',
                            allowBlank : true
                    },
                    
                    {   xtype: 'box',
                        autoEl: {tag:'div', html: "Размещение в выпуске" },
                        cls: 'inprint-form-message'
                    },
                    
                    // Date field
                    {   xtype : 'xdatefield',
                        allowBlank : true,
                        name : 'date',
                        fieldLabel : 'Дата сдачи',
                        format : 'd F, Y',
                        altFormats : 'Y-m-d H:i:sO',
                        submitFormat : 'Y/m/d'
                    },

                    // Fascicle
                    {   xtype : 'inprint.combos.fascicles',
                        allowBlank : false,
                        clearable : false,
                        disabled : true,
                        listeners : {
                            scope : this,
                            select : function(field, record, index) {
                                myform.getForm().findField('section').enable();
                                myform.getForm().findField('section').resetStore({fascicle : record.data.uuid});
                            },
                            clear : function(combo) {
                                myform.getForm().findField('section').disable();
                                myform.getForm().findField('rubric').disable();
                                
                                myform.getForm().findField('section').resetStore({});
                                myform.getForm().findField('rubric').resetStore({});
                            },
                            render : function(combo) {
                                if (Inprint.session.access['document.edition.manage'] || Inprint.session.access['document.department.manage']) {
                                    combo.enable();
                                }
                            }
                        }
                    },
                    
                    // Section
                    {   xtype : 'inprint.combos.sections',
                        allowBlank : true,
                        clearable : true,
                        disabled : true,
                        listeners : {
                            scope : this,
                            select : function(field, record, index) {
                                myform.getForm().findField('rubric').enable();
                                myform.getForm().findField('rubric').resetStore({section : record.data.uuid});
                            },
                            clear : function(field, record, index) {
                                myform.getForm().findField('rubric').disable();
                                myform.getForm().findField('rubric').resetStore({});
                            }
                        }
                    },
                    
                    // Rubrics
                    {   xtype : 'inprint.combos.rubrics',
                        allowBlank : true,
                        clearable : true,
                        disabled : true
                    }
                ]
            });
            
            var mywindow = new Ext.Window({
                title : 'Быстрое добавление материала',
                width : 400,
                height : 450,
                layout : 'fit',
                draggable:true,
                buttonAlign : 'right',
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
                
                items : myform
            });
            
            myform.on("actioncomplete", function() {
                mywindow.hide();
                this.parent.cmpReload();
            }, this)
            
            this.dlgAdd = mywindow;
        }
        
        this.dlgAdd.show();
        
        var form = this.dlgAdd.items.first().getForm();
        
        form.reset();
        
        form.baseParams.session = new Ext.ux.UUID();
        
        form.findField('fascicle').CmpSetValue(this.fascicle);
        form.findField('fascicle').disable();
        
    },
    
    cmpEdit:function() {
        
        if (!this.dlgEdit) {
            
            var myform = new Ext.FormPanel({
                
                url: this.url.edit,
                
                baseParams: {
                    edition : Inprint.session.edition,
                    fascicle: this.fascicle
                },
                
                labelWidth: 100,
                defaults: { anchor: '100%' },
                bodyStyle: 'padding:0px 10px;',
                
                items: [
                    
                    {   xtype: 'box',
                        autoEl: {tag:'div', html: "Обязательные параметры" },
                        cls: 'inprint-form-message'
                    },
                    
                    {   xtype : 'textarea',
                        name : 'title',
                        fieldLabel : 'Название',
                        allowBlank : false,
                        maxLength : 200,
                        height : 40
                    }, {
                        xtype : 'textarea',
                        allowBlank : true,
                        name : 'author',
                        fieldLabel : 'Автор',
                        maxLength : 250,
                        height : 50
                    },
                    
                    {   xtype: 'box',
                        autoEl: {tag:'div', html: "Назначение редактора" },
                        cls: 'inprint-form-message'
                    },
                    
                    {   xtype : 'inprint.combos.departments',
                        allowBlank : true,
                        clearable : true,
                        listeners : {
                            scope : this,
                            clear : function(field) {
                                myform.getForm().findField('manager').resetStore({
                                    edition : Inprint.session.edition
                                });
                            },
                            select : function(field) {
                                myform.getForm().findField('manager').resetStore({
                                    edition : Inprint.session.edition,
                                    department : field.getValue()
                                });
                            }
                        }
                    },
                    {       xtype : 'inprint.combos.managers',
                            allowBlank : true
                    },
                    
                    {   xtype: 'box',
                        autoEl: {tag:'div', html: "Размещение в выпуске" },
                        cls: 'inprint-form-message'
                    },
                    
                    // Date field
                    {   xtype : 'xdatefield',
                        allowBlank : true,
                        name : 'date',
                        fieldLabel : 'Дата сдачи',
                        format : 'd F, Y',
                        altFormats : 'Y-m-d H:i:sO',
                        submitFormat : 'Y/m/d'
                    },

                    // Fascicle
                    {   xtype : 'inprint.combos.fascicles',
                        allowBlank : false,
                        clearable : false,
                        disabled : true,
                        listeners : {
                            scope : this,
                            select : function(field, record, index) {
                                myform.getForm().findField('section').enable();
                                myform.getForm().findField('section').resetStore({fascicle : record.data.uuid});
                            },
                            clear : function(combo) {
                                myform.getForm().findField('section').disable();
                                myform.getForm().findField('rubric').disable();

                                myform.getForm().findField('section').resetStore({});
                                myform.getForm().findField('rubric').resetStore({});
                            },
                            render : function(combo) {
                                if (Inprint.session.access['document.edition.manage'] || Inprint.session.access['document.department.manage']) {
                                    combo.enable();
                                }
                            }
                        }
                    },
                    
                    // Section
                    {   xtype : 'inprint.combos.sections',
                        allowBlank : true,
                        clearable : true,
                        disabled : true,
                        listeners : {
                            scope : this,
                            select : function(field, record, index) {
                                myform.getForm().findField('rubric').enable();
                                myform.getForm().findField('rubric').resetStore({section : record.data.uuid});
                            },
                            clear : function(field, record, index) {
                                myform.getForm().findField('rubric').disable();
                                myform.getForm().findField('rubric').resetStore({});
                            }
                        }
                    },
                    
                    // Rubrics
                    {   xtype : 'inprint.combos.rubrics',
                        allowBlank : true,
                        clearable : true,
                        disabled : true
                    }
                ]
            });
            
            var mywindow = new Ext.Window({
                title : 'Быстрое редактирование материала',
                width : 400,
                height : 450,
                layout : 'fit',
                draggable:true,
                buttonAlign : 'right',
                buttons: [{
                    text: "Сохранить изменения",
                    handler: function() {
                        myform.getForm().submit();
                    }
                }, 
                {   text: Inprint.str.cancel,
                    handler: function() {
                        mywindow.hide();
                    }
                }],
                
                items : myform
            });
            
            myform.on("actioncomplete", function() {
                mywindow.hide();
                this.parent.cmpReload();
            }, this)
            
            this.dlgEdit = mywindow;
        }
        
        this.dlgEdit.show();
        
        var form = this.dlgEdit.items.first().getForm();
        
        form.reset();
        
        form.baseParams.uuid = Inprint.grid.getValues(this, 'uuid');
        
        form.findField('fascicle').CmpSetValue(this.fascicle);
        form.findField('fascicle').CmpSetValue(this.fascicle);
        form.findField('fascicle').disable();
        
        if (this.getSelectionModel().getCount() == 1) {
            
            var record = this.getSelectionModel().getSelected();
            
            form.findField('title').enable();
            form.findField('author').enable();
            
            form.findField('title').setValue(record.data.title);
            
            form.findField('date').setValue(record.data.planned_date+ '00');
            form.findField('author').setValue(record.data.author);
            
            form.findField('department').CmpSetValue(record.data.department);
            form.findField('manager').CmpSetValue(record.data.manager);
            
            form.findField('fascicle').CmpSetValue(record.data.fascicle);
            
            form.findField('section').enable();
            form.findField('section').resetStore({ fascicle : record.data.fascicle });
            
            if (record.data.section) {
                
                form.findField('section').CmpSetValue(record.data.section);
                
                form.findField('rubric').enable();
                form.findField('rubric').resetStore({
                    section : record.data.section
                });
                
                if (record.data.rubric) {
                    form.findField('rubric').CmpSetValue(record.data.rubric);
                }
            }
            
        } else if (this.getSelectionModel().getCount() > 1) {
            
            Inprint.grid.getValues(this, 'uuid');
            
            form.findField('title').disable();
            form.findField('author').disable();
        }
        
    },
    
    cmpMoveToFascicle: function() {
        
        if (!this.dlgMoveToFascicle) {
            
            var myform = new Ext.FormPanel({
                
                url: this.url.tofascicle,
                
                baseParams: {
                    fascicle: this.fascicle
                },
                
                labelWidth: 100,
                defaultType: 'checkbox',
                defaults: { anchor: '100%' },
                bodyStyle: 'padding:5px 5px 0;',
                
                items: [
                    new Ext.form.ComboBox({
                        fieldLabel: 'В выпуск',
                        loadingText: 'Ищем...',
                        store: new Ext.data.Store({
                            baseParams: {
                                edition: Inprint.session.edition
                            },
                            proxy:  new Ext.data.HttpProxy ({ url: '/common/list/fascicle/' }),
                            reader: new Ext.data.JsonReader({ id: 'uuid' }, [ 'uuid', 'title'] )
                        }),
                        allowBlank:false,
                        hiddenName: 'tofascicle',
                        displayField: 'title',
                        valueField:   'uuid',
                        forceSelection: true,
                        triggerAction: 'all'
                    })
                ]
            });
            
            var mywindow = new Ext.Window({
                
                title: 'Отправить материалы в выпуск',
                width: 300,
                height: 140,
                draggable:true,
                buttons: [{
                    text: "Отправить",
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
            }, this);
            
            this.dlgMoveToFascicle = mywindow;
        }
        
        this.dlgMoveToFascicle.show();
        
        var form = this.dlgMoveToFascicle.items.first().getForm();
        form.baseParams.uuid = Inprint.grid.getValues(this, 'uuid');
        form.reset();
    },

    cmpMoveToBriefcase: function(inc) {
        
        if (inc == 'no') {
            return;
        }
        
        else if ( inc == 'yes') {
            Ext.Ajax.request({
                url: this.url.tobriefcase,
                scope: this,
                params: {
                    fascicle: this.fascicle,
                    uuid: Inprint.grid.getValues(this, 'uuid')
                },
                success: function(response, options) {
                    this.parent.cmpReload();
                },
                failure: Inprint.ajax.failure
            });
            
        }
        
        else {
            Ext.MessageBox.confirm(
                'Подтверждение',
                'Вы действительно хотите отправить выбранные материалы в портфель?',
                this.cmpMoveToBriefcase, this
            );
        }
        
    },
    
    cmpMoveToTrash: function(inc) {
        
        if (inc == 'no') {
            return;
        } else if ( inc == 'yes') {
            Ext.Ajax.request({
                url: this.url.totrash,
                scope: this,
                params: {
                    fascicle: this.fascicle,
                    uuid: Inprint.grid.getValues(this, 'uuid')
                },
                success: function(response, options) {
                    this.parent.cmpReload();
                },
                failure: Inprint.ajax.failure
            });
        } else {
            Ext.MessageBox.confirm(
                'Подтверждение',
                'Вы действительно хотите удалить выбранные материалы в корзину?',
                this.cmpMoveToTrash, this
            );
        }
        
    },
    
    cmpShowBriefcase: function() {
        
        if (!this.dlgShowBriefcase) {
            
            this.dlgShowBriefcase = new Ext.Window({
                
                title: 'Просмотр портфеля материалов',
                width: 800,
                height: 600,
                draggable:true,
                buttons: [{
                    text: "Поместить в выпуск",
                    scope: this,
                    handler: this.cmpMoveFromBriefcase
                }, 
                {   text: Inprint.str.cancel,
                    handler: function() { this.ownerCt.hide(); }
                }],
                
                items: {
                    xtype: "PlanningBriefcase",
                    fascicle: this.fascicle,
                    parent: this
                }
            });
        }
        
        this.dlgShowBriefcase.show();
        
    },
    
    cmpMoveFromBriefcase: function() {
        
        var grid = this.dlgShowBriefcase.items.first();
        
        Ext.Ajax.request({
            url: this.url.frombriefcase,
            scope: this,
            params: {
                fascicle: this.fascicle,
                uuid: grid.cmpGetValues()
            },
            success: function(response, options) {
                this.parent.cmpReload();
                this.dlgShowBriefcase.hide();
            },
            failure: Inprint.ajax.failure
        });
    },
    
    cmpReload: function(){
        
        var state = this.getView().getScrollState();
        this.getStore().on("load", function(){
            this.getView().restoreScroll(state);
        }, this, { single:true });
        
        var department = this.getTopToolbar().items.get("departments").getValue();
        var rubric = this.getTopToolbar().items.get("rubrics").getValue();
        var section = this.getTopToolbar().items.get("sections").getValue();
        
        this.getStore().reload({
            params: {
                fascicle: this.fascicle,
                department: department,
                rubric: rubric,
                section: section
            }
        });
    }
    
});
