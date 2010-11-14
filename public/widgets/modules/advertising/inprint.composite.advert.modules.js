///*
// * Inprint Content 4.0
// * Copyright(c) 2001-2009, Softing, LLC.
// * licensing@softing.ru
// *
// * http://softing.ru/license
// */
//
//Inprint.Composite2.Advert.Modules = Ext.extend(Ext.Panel,
//{
//   
//   VarFascicle: false,
//   
//   initComponent: function()
//   {
//      
//      var cmp = new Inprint.advert.grids.Modules({
//         VarFascicle: this.VarFascicle
//      });
//      
//      Ext.apply(this, 
//      {
//         title: 'Модули',
//         layout:'fit',
//         items: cmp,
//         tbar: [
//            {
//               text: 'Отчеты',
//               tooltip : 'Различные отчеты в PDF',
//               cls : 'x-btn-text-icon',
//               icon: _icon("chart"),
//               menu: [
//                  {
//                     text : 'Количество модулей',
//                     tooltip : 'Распечатать таблицу на принтере',
//                     
//                     cls : 'x-btn-text-icon',
//                     icon: _icon("chart"),
//                     
//                     scope : this,
//                     handler : function() 
//                     {
//                        window.location = '/reports/advert-quantity-of-units/?fascicle='+ this.VarFascicle;
//                     }
//                  }
//               ]
//            }
//         ]
//      });
//      
//      Inprint.Composite2.Advert.Modules.superclass.initComponent.apply(this, arguments);
//       
//   },
// 
//   // Override other inherited methods 
//   onRender: function()
//   {
//      Inprint.Composite2.Advert.Modules.superclass.onRender.apply(this, arguments);
//   }
//    
//});
//
//
//Inprint.advert.grids.Modules = Ext.extend(Ext.grid.GridPanel, 
//{
//   
//   VarFascicle: false,
//   
//   initComponent : function() 
//   {
//      
//      var sm = new Ext.grid.CheckboxSelectionModel();
//      
//      var cm = new Ext.grid.ColumnModel([
//         sm,
//         {
//            header: Inprint.str.name,
//            width: 130,
//            dataIndex: 'size'
//         }, 
//         {
//            header: Inprint.str.description,
//            width: 300,
//            dataIndex: 'description'
//         }, 
//         {
//            header: 'group',
//            width: 300,
//            dataIndex: 'group',
//            hidden:true
//         },
//         
//         {
//            id: 'size',
//            header: 'Размер',
//            width: 150,
//            dataIndex: 'size'
//         }, 
//         {
//            id: 'place',
//            header: 'Позиция',
//            dataIndex: 'place',
//            hidden:true
//         },
//         
//         {
//            id: 'page',
//            header: Inprint.str.pages,
//            dataIndex: 'page'
//         }, 
//         {
//            id: 'inplace',
//            header: 'Заявлено',
//            width: 80,
//            dataIndex: 'inplace'
//         }, 
//         {
//            id: 'outplace',
//            header: 'Размещено',
//            width: 80,
//            dataIndex: 'outplace'
//         }, 
//         {
//            id: 'freeplace',
//            header: 'Свободно',
//            width: 80,
//            dataIndex: 'freeplace',
//            renderer: function(v, p, r)
//            {
//               if (r.data.inplace != r.data.outplace) 
//                  return '<span style="color:red">' + v + '</span>';
//               return v;
//            }
//         }
//      ]);
//      
//      // Create Grid store
//      var store = new Ext.data.GroupingStore({
//         autoLoad : true,
//         groupField: 'place',
//         sortInfo : {
//            field: 'place',
//            direction: 'ASC'
//         },
//         remoteSort : true,
//         baseParams : {
//            fascicle: this.VarFascicle
//         },
//         proxy : new Ext.data.HttpProxy({ url : '/advert/matrix/' }),
//         reader : new Ext.data.JsonReader({
//            id: 'uuid',
//            root: 'data',
//            fields: ['uuid', 'group', 'selected', 'place', 'size', 'title', 'description', 'size', 'page', 'inplace', 'outplace', 'freeplace']
//         })
//      });
//      
//      // Create Grid view
//      var view = new Ext.grid.GroupingView({
//         forceFit: false,
//         hideGroupedColumn: true,
//         showGroupName: false
//      });
//      
//      // Create Statusbar 
//      this.statusbar = {};
//      this.statusbar.all = new Ext.Toolbar.TextItem('Полос всего: 0');
//      this.statusbar.doc = new Ext.Toolbar.TextItem('Материалов: 0');
//      this.statusbar.adv = new Ext.Toolbar.TextItem('Рекламных: 0');
//      
//      
//      store.on('load', function(store)
//      {
//      
//        var data = store.reader.jsonData;
//        
//        Ext.fly(this.statusbar.all.getEl()).update('Полос всего: ' + data.statusbar_all);
//        Ext.fly(this.statusbar.doc.getEl()).update('Материалов: ' + data.statusbar_doc);
//        Ext.fly(this.statusbar.adv.getEl()).update('Рекламных: ' + data.statusbar_adv);
//        
//      }, this);
//      
//      var bbar = new Ext.StatusBar({
//        defaultText: 'Реклама выпуска',
//        items: [this.statusbar.all, this.statusbar.doc, this.statusbar.adv],
//        listeners: {
//            scope: this,
//            render: function()
//            {
//                Ext.fly(this.statusbar.all.getEl()).addClass('x-status-text-panel');
//                Ext.fly(this.statusbar.doc.getEl()).addClass('x-status-text-panel');
//                Ext.fly(this.statusbar.adv.getEl()).addClass('x-status-text-panel');
//            }
//        }
//      });
//      
//      Ext.apply(this, 
//      {
//         
//         layout : 'fit',
//         
//         sm : sm,
//         cm : cm,
//         store : store,
//         view : view,
//         
//         stateful : true,
//         stateId : 'inprint-grids-advmodules',
//         
//         stripeRows : true,
//         trackMouseOver : false,
//         enableHdMenu : true,
//         enableDragDrop : false,
//         enableColumnResize : true,
//         enableColumnMove : true,
//         enableColumnHide : true,
//         
//         bbar: bbar
//         
//      });
//         
//      Inprint.advert.grids.Modules.superclass.initComponent.apply(this, arguments);
//         
//   },
//   
//   // Override other inherited methods
//   onRender : function() 
//   {
//      Inprint.advert.grids.Modules.superclass.onRender.apply(this, arguments);
//   },
//   
//   // reload this grid
//   reload : function(params) 
//   {
//   
//      this.getStore().reload();
//   }
//   
//});
