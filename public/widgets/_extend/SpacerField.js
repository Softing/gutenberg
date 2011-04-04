// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Ext.form.SpacerField = Ext.extend(Ext.BoxComponent, {

    autoCreate: { tag: 'div' },

    initComponent: function() {
        this.style = "margin-bottom:10px;";
        Ext.form.SpacerField.superclass.initComponent.apply(this);
    },

    onRender: function() {
        Ext.form.SpacerField.superclass.onRender.apply(this, arguments);
    }

});

Ext.reg('spacerfield', Ext.form.SpacerField);
