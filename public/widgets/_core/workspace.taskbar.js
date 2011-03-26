// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.Taskbar = Ext.extend(Ext.Toolbar,{

    initComponent: function() {
        Ext.apply(this, {
            height:28,
            enableOverflow: true,
            items: [ '-' ]
        });
        Inprint.Taskbar.superclass.initComponent.call(this);
    },

    onRender: function() {
        Inprint.Taskbar.superclass.onRender.apply(this, arguments);
    },

    addButton: function(cfg) {
        var btn = new Inprint.TaskbarBtn(cfg);
        this.add(btn);
        this.doLayout();
        return btn;
    },

    pressButton : function(btn) {
        this.items.each(function(item, index, length) {
            item.removeClass('x-btn-pressed');
            if (item == btn) {
                item.addClass('x-btn-pressed');
            }
        });
    }

});
