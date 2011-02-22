Inprint.factory.StoreDefaults = {
        root: "data",
        autoDestroy: true,
        idProperty: "id",
        params:{}
    };

Inprint.factory.createDateField = function(field) {
    return {
        name: field,
        type: "date",
        dateFormat: "c"
    };
};

Inprint.factory.StoreFields = {

    "/advertising/advertisers/list/":       [
        "id", "serialnum",
        "edition", "edition_shortcut",
        "title", "shortcut", "description",
        "address", "contact", "phones",
        "inn", "kpp", "bank",
        "rs", "ks", "bik",
        Inprint.factory.createDateField("created"),
        Inprint.factory.createDateField("updated")
    ],

    "/advertising/index/headlines/":        [ "id", "selected", "title", "description", Inprint.factory.createDateField("created"), Inprint.factory.createDateField("updated") ],
    "/advertising/index/modules/":          [ "id", "selected", "title", "description", "page", "page_title", "amount", "area", "x", "y", "w", "h", Inprint.factory.createDateField("created"), Inprint.factory.createDateField("updated") ],
    "/advertising/modules/list/":           [ "id", "edition", "page", "title", "shortcut", "description", "amount", "area", "x", "y", "w", "h", Inprint.factory.createDateField("created"), Inprint.factory.createDateField("updated") ],
    "/advertising/pages/list/":             [ "id", "edition", "title", "description", "w", "h", Inprint.factory.createDateField("created"), Inprint.factory.createDateField("updated") ],
    "/advertising/requests/list/":          [ "id", "serialnum", "title", "shortcut", "status", "payment", "readiness", "edition", "edition_shortcut",  "fascicle", "fascicle_shortcut", "advertiser", "advertiser_shortcut", "place", "place_shortcut", "manager", "manager_shortcut", "x", "y", "h", "w", "seqnum", Inprint.factory.createDateField("created"), Inprint.factory.createDateField("updated") ],


    "/common/transfer/list/":               [ "id", "principal", "type", "title", "description" ],

    // Calendar
    "/calendar/list/":                      [ 'id', 'edition', 'edition_shortcut', 'is_enabled', 'title', 'shortcut', 'description', 'begindate', 'enddate', 'totaldays', 'passeddays' ],

    // Documents
    "/documents/list/":         [
        'id', 'access',

        'edition',  'edition_shortcut',
        'fascicle', 'fascicle_shortcut',
        'headline', 'headline_shortcut',
        'rubric', 'rubric_shortcut',
        'copygroup',

        'holder','creator','manager','holder_shortcut','creator_shortcut','manager_shortcut',
        'maingroup','maingroup_shortcut',
        'workgroup','workgroup_shortcut','ingroups',
        'islooked','isopen',
        'branch','branch_shortcut','stage','stage_shortcut','color','progress',
        'title','author','pages',
        'pdate','psize','rdate','rsize',
        'images','files', 'links',
        Inprint.factory.createDateField("created"),
        Inprint.factory.createDateField("updated"),
        Inprint.factory.createDateField("uploaded"),
        Inprint.factory.createDateField("moved")
    ],

    '/documents/common/fascicles/':                 [ "id", "edition", "edition_shortcut", "title", "shortcut", 'description', "headline", "headline_shortcut", "rubric", "rubric_shortcut" ],
    '/documents/files/list/':                       [ "id", "preview", "filename", "extension", "description", "mimetype", "digest", "draft", "size", "created", "updated" ],

    // Catalog
    "/catalog/readiness/list/":                     [ "id", "color", "percent", "title", "shortcut", "description" ],
    "/catalog/roles/list/":                         [ "id", "title", "shortcut", "description", "rules" ],
    "/catalog/rules/list/":                         [ "id", "rule",  "icon", "title", "groupby", "limit", "selection" ],
    "/catalog/members/list/":                       [ "id", "login", "password", "position", "email", "title", "shortcut", Inprint.factory.createDateField("created"), Inprint.factory.createDateField("updated") ],
    "/catalog/members/rules/":                      [ "id", "binding", "binding_shortcut", "area", "area_shortcut", "rules" ],
    "/catalog/stages/list/":                        [ "id", "chain", "readiness_shortcut", "readiness_color", "weight", "title", "shortcut", "description", "members" ],
    "/catalog/stages/principals-mapping/":          [ "id", "type", "catalog", "stage", "principal", "title", "description", "catalog_shortcut", "stage_shortcut" ],
    "/catalog/principals/list/":                    [ "id", "type", "title", "description" ],
    "/catalog/rubrics/list/":                       [ "id", "title", "shortcut", "description" ],

    // Fascicles

    "/fascicle/composer/templates/":
        [ "id", "fascicle", "page", "place", "place_title", "title", "description", "amount", "area", "x", "y", "w", "h", Inprint.factory.createDateField("created"), Inprint.factory.createDateField("updated") ],

    "/fascicle/composer/modules/":
        [ "id", "fascicle", "page", "place", "place_title", "title", "description", "amount", "area", "x", "y", "w", "h", Inprint.factory.createDateField("created"), Inprint.factory.createDateField("updated") ],

    "/fascicle/documents/list/": [
            'id', 'access',    'edition',  'edition_shortcut',    'fascicle',    'fascicle_shortcut',    'headline', 'headline_shortcut',
            'rubric', 'rubric_shortcut',    'copygroup',    'holder','creator','manager','holder_shortcut','creator_shortcut','manager_shortcut',
            'workgroup','workgroup_shortcut','ingroups',    'islooked','isopen',    'branch','branch_shortcut','stage','stage_shortcut','color','progress',
            'title','author','pages',    'pdate','psize','rdate','rsize',    'images','files',    'created','updated'
        ],

    "/fascicle/modules/list/":
        [ "id", "fascicle", "page", "place", "place_title", "title", "description", "amount", "area", "x", "y", "w", "h", Inprint.factory.createDateField("created"), Inprint.factory.createDateField("updated") ],

    "/fascicle/requests/list/": [
            "id", "serialnum", "edition", "fascicle", "advertiser", "advertiser_shortcut",
            "place", "place_shortcut", "manager", "manager_shortcut",
            "origin", "origin_shortcut", "origin_area",
            "origin_x", "origin_y", "origin_w", "origin_h",
            "module", "module_shortcut", "pages", "firstpage", "amount", "shortcut", "description", "status", "payment", "readiness",
            Inprint.factory.createDateField("created"), Inprint.factory.createDateField("updated")
        ],

    "/fascicle/rubrics/list/":
        [ "id", "title", "shortcut", "description" ],

    "/fascicle/summary/":
        [ "id", "shortcut", "pages", "place", "module", "place_shortcut", "holes", "requests", "free" ],

    "/fascicle/templates/pages/list/":
        [ "id", "fascicle", "title", "shortcut", "description", "w", "h", Inprint.factory.createDateField("created"), Inprint.factory.createDateField("updated") ],

    "/fascicle/templates/modules/list/":
        [ "id", "fascicle", "page", "title", "shortcut", "description", "amount", "area", "x", "y", "w", "h", Inprint.factory.createDateField("created"), Inprint.factory.createDateField("updated") ],

    "/fascicle/templates/index/headlines/":
        [ "id", "selected", "title", "shortcut", "description", Inprint.factory.createDateField("created"), Inprint.factory.createDateField("updated") ],

    "/fascicle/templates/index/modules/":
        [ "id", "selected", "title", "shortcut", "description", "page", "page_shortcut", "amount", "area", "x", "y", "w", "h", Inprint.factory.createDateField("created"), Inprint.factory.createDateField("updated") ],

    "/fascicle/templates/modules/":
        [ "id", "fascicle", "page", "place", "place_title", "title", "description", "amount", "area", "x", "y", "w", "h", Inprint.factory.createDateField("created"), Inprint.factory.createDateField("updated") ],

    // System
    "/system/events/list/":
        [ "id", "initiator", "initiator_login", "initiator_shortcut", "initiator_position", "entity", "entity_type", "message", "message_type", "message_variables", Inprint.factory.createDateField("created") ],

    "" : []

};

Inprint.factory.Store = function() {

    var defaults = Inprint.factory.StoreDefaults;
    var source = Inprint.factory.StoreFields;
    var items = {};

    var combos = [

        "/advertising/combo/managers/",
        "/advertising/combo/advertisers/",
        "/advertising/combo/fascicles/",
        "/advertising/combo/places/",
        "/advertising/combo/modules/",

        "/calendar/combos/editions/",
        "/calendar/combos/parents/",
        "/calendar/combos/sources/",

        "/catalog/combos/groups/",
        "/catalog/combos/editions/",
        "/catalog/combos/fascicles/",
        "/catalog/combos/readiness/",
        "/catalog/combos/roles/",

        "/fascicle/combos/templates/",
        "/fascicle/combos/workgroups/",
        "/fascicle/combos/headlines/",
        "/fascicle/combos/rubrics/",

        "/documents/combos/editions/",
        "/documents/combos/stages/",
        "/documents/combos/assignments/",
        "/documents/combos/managers/",
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

    ];

    for ( var i = 0; i < combos.length; i++ ) {
        source[ combos[i] ] = [ 'id', 'icon', 'color', 'spacer', 'bold', 'nlevel', 'title', 'shortcut', 'description' ];
    }

    for (var j in source) {
        items[j] = {
            url: _url(j), fields: source[j]
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

} ();
