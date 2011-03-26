// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Ext.form.ImageField = Ext.extend(Ext.form.Field, {

    autoCreate: {tag: 'img'},

    setValue: function(new_value) {
        if (new_value) {
            this.el.dom.src = new_value;
        }
    },

    initValue : function() {
        this.setValue(this.value);
    },

    initComponent: function() {
        Ext.form.ImageField.superclass.initComponent.apply(this);
    }
});
Ext.reg('imagefield', Ext.form.ImageField);
