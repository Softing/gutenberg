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
