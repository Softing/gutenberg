// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.Workspace = function() {

    var Portal  = new Inprint.Portal();
    var Menu    = new Inprint.Menu();
    var Taskbar = new Inprint.Taskbar();

    var Panel = new Ext.Panel({
        layout: 'card',
        border: false,
        bodyBorder:false,
        bodyStyle: 'padding:2px;background:transparent;',
        items: [],
        tbar: Menu,
        bbar: Taskbar
    })

    var Viewport = new Ext.Viewport({
        layout: 'fit',
        items: Panel
    });

    return {

        getViewport: function(){
            return Viewport;
        },

        getMenu: function(){
            return Menu;
        },

        getPanel: function(){
            return Panel;
        },

        getTaskbar: function(){
            return Taskbar;
        }

    };

};
