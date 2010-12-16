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

        "/advertising/requests/list/":          [ "id", "serialnum", "title", "shortcut", "status", "payment", "readiness", "edition", "edition_shortcut",  "fascicle", "fascicle_shortcut", "advertiser", "advertiser_shortcut", "place", "place_shortcut", "manager", "manager_shortcut", "x", "y", "h", "w", "seqnum", createDateField("created"), createDateField("updated") ],
        "/advertising/advertisers/list/":       [ "id", "serialnum", "edition", "edition_shortcut", "title", "shortcut", "description", "address", "contact", "phones", "inn", "kpp", "bank", "rs", "ks", "bik", createDateField("created"), createDateField("updated") ],
        "/advertising/pages/list/":             [ "id", "edition", "title", "shortcut", "description", "w", "h", createDateField("created"), createDateField("updated") ],
        "/advertising/modules/list/":           [ "id", "edition", "page", "title", "shortcut", "description", "amount", "area", "x", "y", "w", "h", createDateField("created"), createDateField("updated") ],
        

        "/common/transfer/list/":               [ "id", "principal", "type", "title", "description" ],

        // Calendar
        '/calendar/list/':                      [ 'id', 'edition', 'edition_shortcut', 'is_enabled', 'title', 'shortcut', 'description', 'begindate', 'enddate', 'totaldays', 'passeddays' ],
        
        // Documents
        '/documents/list/':         [
            'id', 'access',

            'edition',  'edition_shortcut',
            'fascicle', 'fascicle_shortcut',
            'headline', 'headline_shortcut',
            'rubric', 'rubric_shortcut',
            'copygroup',

            'holder','creator','manager','holder_shortcut','creator_shortcut','manager_shortcut',
            'workgroup','workgroup_shortcut','ingroups',
            'islooked','isopen',
            'branch','branch_shortcut','stage','stage_shortcut','color','progress',
            'title','author','pages',
            'pdate','psize','rdate','rsize',
            'images','files',
            'created','updated'
        ],
        
        '/documents/common/fascicles/':         [ "id", "edition", "edition_shortcut", "title", "shortcut", 'description', "headline", "headline_shortcut", "rubric", "rubric_shortcut" ],
        '/documents/files/list/':               [ "id", "preview", "filename", "extension", "description", "mimetype", "digest", "draft", "size", "created", "updated" ],

        // Catalog
        "/catalog/readiness/list/":             [ "id", "color", "percent", "title", "shortcut", "description" ],
        "/catalog/roles/list/":                 [ "id", "title", "shortcut", "description", "rules" ],
        "/catalog/rules/list/":                 [ "id", "rule",  "icon", "title", "groupby", "limit", "selection" ],
        "/catalog/members/list/":               [ "id", "login", "password", "position", "email", "title", "shortcut", createDateField("created"), createDateField("updated") ],
        "/catalog/members/rules/":              [ "id", "binding", "binding_shortcut", "area", "area_shortcut", "rules" ],
        "/catalog/stages/list/":                [ "id", "chain", "readiness_shortcut", "readiness_color", "weight", "title", "shortcut", "description", "members" ],
        "/catalog/stages/principals-mapping/":  [ "id", "type", "catalog", "stage", "principal", "title", "description", "catalog_shortcut", "stage_shortcut" ],
        "/catalog/principals/list/":            [ "id", "type", "title", "description" ],
        "/catalog/rubrics/list/":               [ "id", "title", "shortcut", "description" ],
        
        // Fascicles
        "/fascicle/rubrics/list/":              [ "id", "title", "shortcut", "description" ],
        "/fascicle/summary/":                   [ "place", "place_shortcut", "module", "module_shortcut", "holes", "requests", "free" ],
        "/fascicle/documents/list/":            [
            'id', 'access',    'edition',  'edition_shortcut',    'fascicle',    'fascicle_shortcut',    'headline', 'headline_shortcut',
            'rubric', 'rubric_shortcut',    'copygroup',    'holder','creator','manager','holder_shortcut','creator_shortcut','manager_shortcut',
            'workgroup','workgroup_shortcut','ingroups',    'islooked','isopen',    'branch','branch_shortcut','stage','stage_shortcut','color','progress',
            'title','author','pages',    'pdate','psize','rdate','rsize',    'images','files',    'created','updated'
        ],
        
        // System
        "/system/events/list/":                 [ "id", "initiator", "initiator_login", "initiator_shortcut", "initiator_position", "entity", "entity_type", "message", "message_type", "message_variables", createDateField("created") ],


        "" : []

    }

    var combos = new Array(

        "/advertising/combo/managers/",
        "/advertising/combo/advertisers/",
        "/advertising/combo/fascicles/",
        "/advertising/combo/places/",
        "/advertising/combo/modules/",

        "/calendar/combos/copypages/",
        "/calendar/combos/copyindex/",

        "/catalog/combos/groups/",
        "/catalog/combos/editions/",
        "/catalog/combos/fascicles/",
        "/catalog/combos/readiness/",
        "/catalog/combos/roles/",
        
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
