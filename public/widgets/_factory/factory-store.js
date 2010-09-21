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

        // Calendar
        '/calendar/list/':          [ 'id', 'catalog', 'catalog_shortcut', 'enabled', 'title', 'shortcut', 'description', 'begindate', 'enddate', 'totaldays', 'passeddays' ],

        // Documents
        '/documents/list/':         [
            'id',
            
            'fascicle', 'fascicle_shortcut',
            'headline', 'headline_shortcut',
            'rubric', 'rubric_shortcut',
            'copygroup',
            
            'holder','creator','manager','owner_shortcut','creator_shortcut','manager_shortcut',
            'maingroup','maingroup_shortcut','ingroups',
            'islooked','isopen',
            'branch','branch_shortcut','stage','stage_shortcut','color','progress',
            'title','author',
            'pdate','psize','rdate','rsize',
            'images','files',
            'created','updated'
        ],

        // System

        // Settings

        "/principals/list/":        [ "id", "name", "shortcut", "description", "type" ],
        "/members/list/":           [ "id", "login", "password", "position", "email", "name", "shortcut", createDateField("created"), createDateField("updated") ],
        "/rules/list/":             [ "id", "rule",  "name", "shortcut", "groupby", "limit", "selection" ],
        "/roles/list/":             [ "id", "name", "shortcut", "description", "catalog_id", "catalog_name", "catalog_shortcut" ],

        /*???*/ 
        "/exchange/list/":          [ "id", "rule",  "name", "shortcut", "groupby", "limit", "selection" ],

        "/chains/list/":            [ "id", "rule",  "name", "shortcut", "groupby", "limit", "selection" ],
        "/stages/list/":            [ "id", "chain", "color", "weight", "name", "shortcut", "description" ],

        // Comboboxes
        "/catalog/combo/":          [ 'id', 'name', 'path', 'shortcut' ],
        "/chains/combo/":           [ 'id', 'name', 'path', 'shortcut', 'catalog_shortcut' ],
        "/calendar/combo/groups/":  [ 'id', 'name', 'shortcut' ],

        "" : []

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
                alert("Can't find array store <" + myclass + ">");
            }
            return false;
        },

        json: function(myclass, config) {
            if (items[myclass]) {
                var configuration = defaults;
                configuration = Ext.apply(configuration, items[myclass]);
                configuration = Ext.apply(configuration, config);
                return new Ext.data.JsonStore(configuration);
            } else {
                alert("Can't find json store <" + myclass + ">");
            }
            return false;
        },

        group: function(myclass, storeconfig, readerconfig) {
            if (items[myclass]) {

                var configuration = defaults;

                var configuration2 = {
                    idProperty: 'id',
                    root: 'data',
                    fields: items[myclass].fields
                };

                Ext.apply(configuration2, readerconfig);

                var reader = new Ext.data.JsonReader(configuration2);

                configuration = Ext.apply(configuration, {
                    reader: reader,
                    remoteSort: true,
                    //sortInfo:{field: 'name', direction: "ASC"},
                    groupField:'groupby'
                });

                configuration = Ext.apply(configuration, { url: items[myclass].url });
                configuration = Ext.apply(configuration, storeconfig);

                return new Ext.data.GroupingStore(configuration);
            } else {
                alert("Can't find group store <" + myclass + ">");
            }
            return false;
        }

    };

}
