/*
 * Inprint Content 4.5
 * Copyright(c) 2001-2010, Softing, LLC.
 * licensing@softing.ru
 *
 * http://softing.ru/license
 */

Inprint.Workspace = function() {

    // Activate state sore
    
    var items = [];

    var Portal  = new Inprint.Portal();
    var Menu    = new Inprint.Menu();
    var Taskbar = new Inprint.Taskbar();

    // Create Panel
    var Panel = new Ext.Panel({
        layout: 'card',
        activeItem: 0,
        border:false,
        bodyStyle: 'background:none;',
        items: Portal
    });

    //items.push( Portal.id );

    var Viewport = new Ext.Viewport({
        layout: 'fit',
        items: new Ext.Panel({
            layout: 'fit',
            bodyStyle: 'padding:5px;background:none;',
            tbar: Menu,
            items: Panel,
            bbar: Taskbar
        })
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

    }

};
