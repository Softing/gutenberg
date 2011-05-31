// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Ext.namespace("Inprint.factory.buttons");

Inprint.factory.buttons.manager = new function () {
    var items = {};
    return {

        set: function(name, item) {
            items[name] = item;
        },

        get: function(name, params) {

            var item = items[name];
            if (item) {
                if (params) {
                    Ext.apply(item, params);
                }
            } else {
                item = {
                    text: name,
                    icon: _ico("question-button")
                };
            }

            item.cls = "x-btn-text-icon";

            item.tooltip = item.ref;

            return item;
        }

    }
};

Inprint.setButton = function (name, item) {
    return Inprint.factory.buttons.manager.set(name, item);
}

Inprint.getButton = function (name, params) {
    return Inprint.factory.buttons.manager.get(name, params);
}

Inprint.setButton("create.item", {
    text: _("Add"),
    ref: "../btnCreateItem",
    icon: _ico("plus-button")
});

Inprint.setButton("update.item", {
    text: _("Edit"),
    ref: "../btnUpdateItem",
    icon: _ico("pencil")
});

Inprint.setButton("delete.item", {
    text: _("Delete"),
    icon: _ico("minus-button"),
    ref: "../btnDeleteItem"
});

Inprint.setButton("select.principals", {
    text: _("Select employees"),
    icon: _ico("users"),
    ref: "../btnSelectPrincipals"
});
