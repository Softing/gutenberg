// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Ext.form.TitleField = Ext.extend(Ext.BoxComponent, {

    autoCreate: { tag: 'div' },

    initComponent: function() {
        this.style = "background:#DDDDDD;padding:4px;margin-bottom:5px;";

        if (this.margin) {
            this.style += "margin-top:"+ this.margin+"px;";
        }

        Ext.form.TitleField.superclass.initComponent.apply(this);
    },

    onRender: function() {
        Ext.form.TitleField.superclass.onRender.apply(this, arguments);
        this.el.dom.innerHTML = '<b>'+ this.value+'</b>';
    }

});

Ext.reg('titlefield', Ext.form.TitleField);
