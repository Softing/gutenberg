/*
 * Inprint Content 4.5
 * Copyright(c) 2001-2010, Softing, LLC.
 * licensing@softing.ru
 *
 * http://softing.ru/license
 */

Inprint.registry = function() {
    
    var registr = {

        register : function(id, item) {
            this[id] = item;
            if (item['xobject'])
                Ext.reg(id, item['xobject']);
        },

        "core": {
            icon: "target",
            text: _("Inprint"),
            xtype: "splitbutton",
            handler: function() {
                Inprint.layout.getPanel().layout.setActiveItem(0);
            }
        },
        
        "documents": {
            icon: "document-word",
            text: _("Documents")
        },
        "composition": {
            icon: "newspapers",
            text:  _("Composition")
        },
        "fascicle": {
            icon: "blue-folder",
            text: _("Unknown fascicle")
        },
        "settings": {
            icon: "switch",
            text: _("Settings")
        },

        "employee": {
            icon: "dummy",
            text: _("Employee")
        },
        
        "employee-logout": {
            icon: "door-open",
            text: _("Logout"),
            handler: function () {
                Inprint.Logout();
            }
        }
    };
    
    return registr;
}();
