// Comboboxes

Ext.ns("Inprint.ext");

Inprint.ext.Combobox = Ext.extend(Ext.form.ComboBox, {
    
    initComponent: function(){
        
        // Add default values
        if ( ! this.valueField )   this.valueField   = 'id';
        if ( ! this.displayField ) this.displayField = 'title';
        
        Ext.apply(this, {
            triggerAction:'all',
            hideOnSelect:false,
            editable:false,
            trigger1Class: "x-form-clear-trigger",
            trigger2Class: "x-form-trigger",
            hideTrigger1: true
        });
        
        // Create clearable config
        this.triggerConfig = {
            tag:'span', cls:'x-form-twin-triggers', cn:[
                {tag: "img", src: Ext.BLANK_IMAGE_URL, cls: "x-form-trigger " + this.trigger1Class},
                {tag: "img", src: Ext.BLANK_IMAGE_URL, cls: "x-form-trigger " + this.trigger2Class}
            ]
        };
        
        //this.reset = Ext.form.Field.prototype.reset.createSequence(function() {
        //    this.getTrigger(0).hide();
        //}, this);
        
        this.onViewClick = Ext.form.ComboBox.prototype.onViewClick.createSequence(function(combo) {
            this.getTrigger(0).show();
        }, this);
        
        this.addEvents({"select": true});
        this.addEvents({"clear": true});
        
        Inprint.ext.Combobox.superclass.initComponent.call(this);
        
        // Add no cache functionality
        if ( this.nocache ){
            this.on('beforequery', function(qe){
                delete qe.combo.lastQuery;
            }, this);
        }
        
    },
    
    // Triggers configuration
    
    getTrigger: Ext.form.TwinTriggerField.prototype.getTrigger,
    initTrigger: Ext.form.TwinTriggerField.prototype.initTrigger,
    
    onTrigger1Click: function() {
            this.clearValue();
            this.reset();
            this.getTrigger(0).hide();
            this.fireEvent('clear', this);
        },
    trigger1Class: Ext.form.ComboBox.prototype.triggerClass,
    
    onTrigger2Click: Ext.form.ComboBox.prototype.onTriggerClick,
    trigger2Class: Ext.form.ComboBox.prototype.triggerClass,
   
   
   // Combo Helpers
   
   resetValue: function(baseParams) {
      this.reset();
      this.store.removeAll();
      this.lastQuery = null;
      this.store.baseParams = baseParams || {};
   },
   
   setValueById: function(value, params) {
      if (value)
      {
         
         this.store.on('load', function()
            {
               this.setValue(value);
               this.mode = 'local';
               this.fireEvent('select', this, this.getStore().getById( this.getValue() ) );
               if (this.clearable)
                  this.triggers[0].show();
               
            }, this,
            {
               single: true
            }
         );
         
         this.store.load({
               params: params
         });
      }
   }
   
});

Ext.reg("xcombo", Inprint.ext.Combobox);

//Ext.form.ComboBox.prototype.CmpClear = function(baseParams) {
//   this.reset();
//   this.store.removeAll();
//   this.lastQuery = null;
//   this.store.baseParams = baseParams || {};
//};
//
//Ext.form.ComboBox.prototype.CmpSelectFirst = function() {
//    this.select(1);
//};
//
//Ext.form.ComboBox.prototype.CmpLoadValue = function(value, params) {
//
//   if (value) {
//      this.store.on('load', function() {
//            this.setValue(value);
//            this.mode = 'local';
//            this.fireEvent('select', this, this.getStore().getById( this.getValue() ) );
//
//            if (this.clearable)
//               this.triggers[0].show();
//
//         }, this, { single: true }
//      );
//      this.store.load({
//            params: params
//      });
//   }
//}
