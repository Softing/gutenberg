//// Comboboxes
//
//Ext.ns("Inprint.ext");
//
//Inprint.ext.Combobox = Ext.extend(Ext.form.ComboBox, {
//    
//    initComponent: function(){
//        
//        //Ext.apply(this, {
//        //    triggerAction:'all',
//        //    hideOnSelect:false,
//        //    editable:false,
//        //    trigger1Class: "x-form-clear-trigger",
//        //    trigger2Class: "x-form-trigger",
//        //    hideTrigger1: true
//        //});
//        
//   //     this.triggerConfig = {
//   //         tag:'span', cls:'x-form-twin-triggers', cn:[
//   //             {tag: "img", src: Ext.BLANK_IMAGE_URL, cls: "x-form-trigger " + this.trigger1Class},
//   //             {tag: "img", src: Ext.BLANK_IMAGE_URL, cls: "x-form-trigger " + this.trigger2Class}
//   //         ]
//   //     };
//   //     
//   //     this.onTrigger1Click = this.onTrigger1Click.createInterceptor(
//   //         function(){
//   //             alert(1);
//   //             //this.clearValue();
//   //             //this.triggers[0].hide();
//   //             //this.fireEvent('clear', this);
//   //         }
//   //     );
//   //     
//   //     this.onTrigger2Click = this.onTrigger2Click.createInterceptor(
//   //         function() {
//   //             this.collapse();
//   //         }
//   //     );
//   //     
//   ////      this.reset = Ext.form.Field.prototype.reset.createSequence(
//   ////         function()
//   ////         {
//   ////            this.triggers[0].hide();
//   ////         }
//   ////      );
//   ////      
//   ////      this.onViewClick = Ext.form.ComboBox.prototype.onViewClick.createSequence(
//   ////         function()
//   ////         {
//   ////            this.triggers[0].show();
//   ////         }
//   ////      );
//        
//        Inprint.ext.Combobox.superclass.initComponent.call(this);
//    }
//    
//    //getTrigger: Ext.form.TwinTriggerField.prototype.getTrigger,
//    //initTrigger: Ext.form.TwinTriggerField.prototype.initTrigger,
//    //onTrigger1Click: Ext.form.ComboBox.prototype.onTriggerClick,
//    //trigger1Class: Ext.form.ComboBox.prototype.triggerClass,
//    //
//    //onTrigger2Click: Ext.form.ComboBox.prototype.onTriggerClick,
//    //trigger2Class: Ext.form.ComboBox.prototype.triggerClass,
//    //
//    
//   //
//   //   }
//   //
//   //   if ( ! this.displayField ) this.displayField = 'title';
//   //   if ( ! this.valueField )   this.valueField   = 'uuid';
//   //
//   //   var baseParams = {
//   //      
//   //   };
//   //   
//   //   Ext.apply( baseParams,  this.baseParams );
//   //   Ext.apply( this.store, {
//   //      baseParams: baseParams
//   //   });
//   //
//   //   var config = {
//   //      mode:'remote',
//   //      store: new Ext.data.Store( this.store )
//   //   };
//   //   
//   //   Ext.apply(this, config);
//   //   Ext.apply(this.initialConfig, config);
//   //   
//   //   Inprint.combobox.superclass.initComponent.apply(this, arguments);
//   //   
//   //   if ( this.nocache )
//   //   {
//   //        this.on('beforequery', 
//   //           function(qe){
//   //              delete qe.combo.lastQuery;
//   //           }, this);
//   //    }
//   //
//   //},
//   
//   //onRender:function(){
//   // 
//   //   Inprint.ext.Combobox.superclass.onRender.apply(this, arguments);
//   //   
//   //   if ( this.cmpDefaultValue ) {
//   //      this.CmpSetValue( this.cmpDefaultValue );
//   //   }
//   //   
//   //},
//   
//   // Combo Helpers
//   
//   //clearValue: function(baseParams) {
//   //   this.reset();
//   //   this.store.removeAll();
//   //   this.lastQuery = null;
//   //   this.store.baseParams = baseParams || {};
//   //},
//   //
//   //setValue: function(value, params) {
//   //   if (value)
//   //   {
//   //      
//   //      this.store.on('load', function()
//   //         {
//   //            this.setValue(value);
//   //            this.mode = 'local';
//   //            this.fireEvent('select', this, this.getStore().getById( this.getValue() ) );
//   //            
//   //            if (this.clearable)
//   //               this.triggers[0].show();
//   //            
//   //         }, this,
//   //         {
//   //            single: true
//   //         }
//   //      );
//   //      
//   //      this.store.load({
//   //            params: params
//   //      });
//   //   }
//   //}
//   
//});
//
//Ext.reg("xcombo", Inprint.ext.Combobox);
//
////Ext.form.ComboBox.prototype.CmpClear = function(baseParams) {
////   this.reset();
////   this.store.removeAll();
////   this.lastQuery = null;
////   this.store.baseParams = baseParams || {};
////};
////
////Ext.form.ComboBox.prototype.CmpSelectFirst = function() {
////    this.select(1);
////};
////
////Ext.form.ComboBox.prototype.CmpLoadValue = function(value, params) {
////
////   if (value) {
////      this.store.on('load', function() {
////            this.setValue(value);
////            this.mode = 'local';
////            this.fireEvent('select', this, this.getStore().getById( this.getValue() ) );
////
////            if (this.clearable)
////               this.triggers[0].show();
////
////         }, this, { single: true }
////      );
////      this.store.load({
////            params: params
////      });
////   }
////}
