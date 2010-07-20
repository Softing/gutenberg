Inprint.factory.Store = new function() {

    var defaults = {
        root: "data",
        autoDestroy: true,
        idProperty: "id",
        params:{}
    };

    var items = {};
    var createDateField = function(field) {
        return {
            name: field,
            type: "date",
            dateFormat: "U000"
        };
    }

    var source = {

        // Grid Stores

        "/common/passport/members/list/":     [ "id", "edition", "title", "stitle", "description", "icon" ],
        "/common/passport/accounts/list/":    [ "id", "edition", "title", "stitle", "description", "icon" ],
        "/common/passport/departments/list/": [ "id", "edition", "title", "stitle", "description", "icon" ],
        "/common/passport/mixed/list/":       [ "id", "edition", "title", "stitle", "description", "icon" ],

        //"/edition/get/accounts/list/":      [ "id", "enabled", "color", "title", "stitle", "description", createDateField("created"), createDateField("updated") ],
        //"/edition/get/departments/list/":   [ "id", "enabled", "color", "title", "stitle", "description", createDateField("created"), createDateField("updated") ],

        // System
        "/system/logservice/":              [ "id", "edition","initiator", "object", "event", "message", "metadata", createDateField("created") ],

        // Settings
        "/settings/editions/list/":         [ "id", "enabled", "color", "title", "stitle", "description", createDateField("created"), createDateField("updated") ],
        "/settings/exchange/list/":         [ "id", "edition", "enabled", "type", "color", "order", "title", "description", createDateField("created"), createDateField("updated") ],
        "/settings/roles/list/":            [ "id", "edition", "enabled", "title", "stitle", "description", createDateField("created"), createDateField("updated") ],
        "/settings/departments/list/":      [ "id", "edition", "enabled", "color", "title", "stitle", "description", createDateField("created"), createDateField("updated") ],
        "/settings/members/list/":          [ "id", "enabled", "login", "email", "title", "stitle", createDateField("created"), createDateField("updated") ],
        "/settings/accounts/list/":         [ "id", "edition", "member", "enabled", "title", "stitle", "etitle", "estitle", "metadata", createDateField("created"), createDateField("updated") ],

        // Comboboxes
        "/combo/edtions/":  [ "id", "icon", "color", "title", "description" ],
        "/combo/members/":  [ "id", "icon", "color", "title", "description" ],
        "/combo/roles/":    [ "id", "icon", "color", "title", "description" ]
    }

    for (var i in source) {
        items[i] = {
            url: _url(i), fields: source[i]
        };
    }

    return {

        items: items,
        source: source,

        array: function(myclass, config) {
            if (items[myclass]) {
                var configuration = defaults;
                configuration = Ext.apply(configuration, items[myclass]);
                configuration = Ext.apply(configuration, config);
                return new Ext.data.ArrayStore(configuration);
            } else {
                alert("Can't find store <" + myclass + ">");
            }
        },

        json: function(myclass, config) {
            if (items[myclass]) {
                var configuration = defaults;
                configuration = Ext.apply(configuration, items[myclass]);
                configuration = Ext.apply(configuration, config);
                return new Ext.data.JsonStore(configuration);
            } else {
                alert("Can't find store <" + myclass + ">");
            }
        }

    };

}
