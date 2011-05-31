// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Ext.namespace("Inprint.factory.actions");

Inprint.factory.actions.manager = new function () {
    var items = {};
    return {
        set: function(name, item) {
            items[name] = item;
        },
        get: function(name, scope, params) {
            var item = items[name];
            if (scope) {
                Ext.apply(item, { scope: scope });
            }
            if (params) {
                Ext.apply(item, params);
            }
            return item;
        }
    }
};

Inprint.setAction = function (name, fnct) {
    return Inprint.factory.actions.manager.set(name, fnct);
}

Inprint.getAction = function (name, scope, params) {
    return Inprint.factory.actions.manager.get(name, scope, params);
}
