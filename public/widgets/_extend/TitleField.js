Ext.form.TitleField = Ext.extend(Ext.BoxComponent, {

    autoCreate: { tag: 'div' },

    initComponent: function() {
        this.style = "background:#f5f5f5;padding:4px;margin-bottom:5px;";
        Ext.form.TitleField.superclass.initComponent.apply(this);
    },

    onRender: function() {
        Ext.form.TitleField.superclass.onRender.apply(this, arguments);
        this.el.dom.innerHTML = '<b>'+ this.value+'</b>';
    }

});

Ext.reg('titlefield', Ext.form.TitleField);
