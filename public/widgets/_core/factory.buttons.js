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

        get: function(name, icon, tooltip, params) {

            var item = items[name];

            if (!item) {
                return {
                    text: name,
                    icon: _ico("question-button"),
                    cls: "x-btn-text-icon"
                };
            }

            item.disabled = true;
            item.cls = "x-btn-text-icon";
            item.tooltip = item.ref;

            if (icon) {
                item.icon = _ico(icon);
            }

            if (tooltip) {
                item.tooltip = _(tooltip);
            }

            if (params) {
                Ext.apply(item, params);
            }

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

Inprint.setButton("move.item", {
    text: _("Move"),
    icon: _ico("navigation-000-button"),
    ref: "../btnMoveItem"
});

Inprint.setButton("layout.item", {
    text: _("Layout"),
    icon: _ico("layout-design"),
    ref: "../btnLayoutItem"
});

Inprint.setButton("placing.item", {
    text: _("Placing"),
    icon: _ico("layout-select-content"),
    ref: "../btnPlacingItem"
});


Inprint.setButton("select.principals", {
    text: _("Select employees"),
    icon: _ico("users"),
    ref: "../btnSelectPrincipals"
});
