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
            dateFormat: "c"
        };
    }

    var source = {

        // Calendar
        '/calendar/list/':          [ 'id', 'edition', 'edition_shortcut', 'enabled', 'title', 'shortcut', 'description', 'begindate', 'enddate', 'totaldays', 'passeddays' ],

        // Documents
        '/documents/list/':         [
            'id',

            'edition',  'edition_shortcut',
            'fascicle', 'fascicle_shortcut',
            'headline', 'headline_shortcut',
            'rubric', 'rubric_shortcut',
            'copygroup',

            'holder','creator','manager','holder_shortcut','creator_shortcut','manager_shortcut',
            'workgroup','workgroup_shortcut','ingroups',
            'islooked','isopen',
            'branch','branch_shortcut','stage','stage_shortcut','color','progress',
            'title','author',
            'pdate','psize','rdate','rsize',
            'images','files',
            'created','updated'
        ],
        '/documents/common/fascicles/':         [ 'id', 'title', 'shortcut', 'description', "headline", "headline_shortcut", "rubric", "rubric_shortcut" ],

        // Catalog
        "/catalog/readiness/list/":             [ "id", "color", "percent", "title", "shortcut", "description" ],
        "/catalog/roles/list/":                 [ "id", "title", "shortcut", "description", "rules" ],
        "/catalog/rules/list/":                 [ "id", "rule",  "title", "shortcut", "groupby", "limit", "selection" ],
        "/catalog/members/list/":               [ "id", "login", "password", "position", "email", "title", "shortcut", createDateField("created"), createDateField("updated") ],
        "/catalog/members/rules/":              [ "id", "binding", "binding_shortcut", "area", "area_shortcut", "rules" ],
        "/catalog/stages/list/":                [ "id", "chain", "readiness_shortcut", "readiness_color", "weight", "title", "shortcut", "description", "members" ],
        "/catalog/stages/principals-mapping/":  [ "id", "type", "catalog", "stage", "principal", "title", "description", "catalog_shortcut", "stage_shortcut" ],
        "/catalog/principals/list/":            [ "id", "type", "title", "description" ],
        "/catalog/transfer/list/":              [ "id", "type", "title", "description" ],

        // System
        "/system/events/list/":                 [ "id", "initiator", "initiator_login", "initiator_shortcut", "initiator_position", "entity", "entity_type", "message", "message_type", "message_variables", createDateField("created") ],


        "" : []

    }

    var combos = new Array(

        "/catalog/combos/groups/",
        "/catalog/combos/editions/",
        "/catalog/combos/fascicles/",
        "/catalog/combos/readiness/",
        "/catalog/combos/roles/",

        "/documents/combos/editions/",
        "/documents/combos/stages/",
        "/documents/combos/assignments/",
        "/documents/combos/fascicles/",
        "/documents/combos/headlines/",
        "/documents/combos/rubrics/",

        "/documents/filters/editions/",
        "/documents/filters/groups/",
        "/documents/filters/fascicles/",
        "/documents/filters/headlines/",
        "/documents/filters/rubrics/",
        "/documents/filters/holders/",
        "/documents/filters/managers/",
        "/documents/filters/progress/",

        "/options/combos/capture-destination/"

    );

    for ( var i = 0; i < combos.length; i++ ) {
        source[ combos[i] ] = [ 'id', 'icon', 'color', 'spacer', 'bold', 'nlevel', 'title', 'shortcut', 'description' ];
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
                var configuration = {};
                configuration = Ext.apply(configuration, defaults);
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

                var configuration = {};
                configuration = Ext.apply(configuration, defaults);
                configuration = Ext.apply(configuration, items[myclass]);
                configuration = Ext.apply(configuration, config);

                return new Ext.data.JsonStore(configuration);
            }

            alert("Can't find json store <" + myclass + ">");
            return false;
        },

        group: function(myclass, storeconfig, readerconfig) {
            
            if (items[myclass]) {
                
                var configuration = {};
                configuration = Ext.apply(configuration, defaults);
                
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
                    groupField:'groupby'
                });

                configuration = Ext.apply(configuration, { url: items[myclass].url });
                configuration = Ext.apply(configuration, storeconfig);

                var store = new Ext.data.GroupingStore(configuration);
                
                return store;
            } else {
                alert("Can't find group store <" + myclass + ">");
            }
            return false;
        }

    };

}
