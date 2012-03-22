// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Ext.form.ComboBox.prototype.setValue = function(v, t){

    if (t || t === "") {
        this.displayText = t;
    }

    var text = this.displayText || v;

    if(this.valueField){
        var r = this.findRecord(this.valueField, v);
        if(r){
            text = r.data[this.displayField];
        }else if(Ext.isDefined(this.valueNotFoundText)){
            text = this.valueNotFoundText;
        }
    }
    this.lastSelectionText = text;
    if(this.hiddenField){
        this.hiddenField.value = Ext.value(v, '');
    }

    Ext.form.ComboBox.superclass.setValue.call(this, text);

    this.value = v;
    return this;
};

Ext.form.ComboBox.prototype.setHiddenValue = function(id, value) {
    this.setValue(id, value);
    return this;
};

Ext.form.ComboBox.prototype.loadValue = function(value, params) {
    if (value) {
        this.getStore().on("load", function() {
            this.setValue(value);
        }, this, { single: true });
        this.getStore().load({ params: params });
    }
};

Ext.form.ComboBox.prototype.resetValue = function(baseParams) {
    this.reset();
    this.store.removeAll();
    this.lastQuery = null;
    this.store.baseParams = baseParams || {};
    this.setValue("", "");
};

// Create XCombobox

Ext.ns("Inprint.ext");

Inprint.ext.Combobox = Ext.extend(Ext.form.ComboBox, {

    initComponent: function(){

        // Add default values
        if ( ! this.valueField ) {
            this.valueField   = 'id';
        }

        if ( ! this.displayField ) {
            this.displayField = 'title';
        }

        Ext.apply(this, {
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

        this.onViewClick = Ext.form.ComboBox.prototype.onViewClick.createSequence(function(combo) {
            if ( this.clearable ) {
                this.getTrigger(0).show();
            }
        }, this);

        this.addEvents({"select": true});
        this.addEvents({"clear": true});

        Inprint.ext.Combobox.superclass.initComponent.call(this);

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
    trigger2Class: Ext.form.ComboBox.prototype.triggerClass

});

Ext.reg("xcombo", Inprint.ext.Combobox);
