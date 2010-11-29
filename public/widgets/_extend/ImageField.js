Ext.form.ImageField = Ext.extend(Ext.form.Field, {

    autoCreate: {tag: 'img'},

    setValue: function(new_value) {
        if (new_value)
            this.el.dom.src = new_value;
    },

    initValue : function() {
        this.setValue(this.value);
    },

    initComponent: function() {
        Ext.form.ImageField.superclass.initComponent.apply(this);
    }
});

Ext.reg('imagefield', Ext.form.ImageField);

Ext.form.TitleField = Ext.extend(Ext.form.Field, {

    autoCreate: { tag: 'div', style:'background:#f5f5f5;padding:4px;' },

    setValue: function(new_value) {
        if (new_value)
            this.el.dom.innerHTML = '<b>'+ new_value +'</b>';
    },

    initValue : function() {
        this.setValue(this.value);
    },

    initComponent: function() {
        this.hideLabel = true;
        Ext.form.ImageField.superclass.initComponent.apply(this);
    }
});

Ext.reg('titlefield', Ext.form.TitleField);
