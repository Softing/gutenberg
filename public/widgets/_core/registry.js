// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.registry = {

    "register": function(id, item) {
        this[id] = item;
        if (item.xobject) {
            Ext.reg(id, item.xobject);
        }
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
        text: _("Documents"),
        icon: "document-word"
    },

    "advertising": {
        text: _("Advertising"),
        icon: "document-excel"
    },

    "composition": {
        text:  _("Composition"),
        icon: "newspapers"
    },

    "fascicle": {
        text: _("Unknown fascicle"),
        icon: "blue-folder-horizontal"
    },

    "attachment": {
        text: _("Unknown attachment"),
        icon: "folder-horizontal"
    },

    "fascicles": {
        text: _("Fascicles"),
        icon: "blue-folders-stack"
    },

    "settings": {
        text: _("Settings"),
        icon: "switch"
    },

    "employee": {
        text: _("Employee"),
        icon: "dummy"
    },

    "employee-logout": {
        text: _("Logout"),
        icon: "door-open",
        handler: function () {
            Inprint.Logout();
        }
    }
};
