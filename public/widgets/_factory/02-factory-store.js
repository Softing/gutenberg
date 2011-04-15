// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.factory.StoreMappings = {

    // Advertising

    "/advertisers/list/":                   Inprint.store.Columns.advertisers.list,

    "/advertising/advertisers/list/":       Inprint.store.Columns.advertising.list,
    "/advertising/modules/list/":           Inprint.store.Columns.advertising.modules,
    "/advertising/pages/list/":             Inprint.store.Columns.advertising.pages,
    "/advertising/requests/list/":          Inprint.store.Columns.advertising.requests,
    "/advertising/index/headlines/":        Inprint.store.Columns.advertising.index.headlines,
    "/advertising/index/modules/":          Inprint.store.Columns.advertising.index.modules,

    // Common
    "/common/transfer/list/":               Inprint.store.Columns.common.transfer,

    // Calendar
    "/calendar/list/":                      Inprint.store.Columns.calendar.list,

    // Documents
    "/documents/array/":                    Inprint.store.Columns.documents.list,
    "/documents/list/":                     Inprint.store.Columns.documents.list,
    '/documents/common/fascicles/':         Inprint.store.Columns.documents.fascicles,
    '/documents/files/list/':               Inprint.store.Columns.documents.files,

    // Catalog
    "/catalog/readiness/list/":             Inprint.store.Columns.catalog.readiness,
    "/catalog/roles/list/":                 Inprint.store.Columns.catalog.roles,
    "/catalog/rules/list/":                 Inprint.store.Columns.catalog.rules,
    "/catalog/members/list/":               Inprint.store.Columns.catalog.members,
    "/catalog/members/rules/":              Inprint.store.Columns.catalog.members_rules,
    "/catalog/stages/list/":                Inprint.store.Columns.catalog.stages,
    "/catalog/stages/principals-mapping/":  Inprint.store.Columns.catalog.stages_mapping,
    "/catalog/principals/list/":            Inprint.store.Columns.catalog.principals,
    "/catalog/rubrics/list/":               Inprint.store.Columns.catalog.rubrics,

    // Fascicles
    "/fascicle/composer/templates/":        Inprint.store.Columns.fascicle.composer_templates,
    "/fascicle/composer/modules/":          Inprint.store.Columns.fascicle.composer_modules,
    "/fascicle/documents/list/":            Inprint.store.Columns.documents.list,
    "/fascicle/modules/list/":              Inprint.store.Columns.fascicle.modules,
    "/fascicle/requests/list/":             Inprint.store.Columns.fascicle.requests,
    "/fascicle/rubrics/list/":              Inprint.store.Columns.fascicle.rubrics,
    "/fascicle/summary/":                   Inprint.store.Columns.fascicle.summary,

    "/fascicle/templates/pages/list/":      Inprint.store.Columns.tfascicle.pages,
    "/fascicle/templates/modules/list/":    Inprint.store.Columns.tfascicle.modules,
    "/fascicle/templates/index/headlines/": Inprint.store.Columns.tfascicle.index_headlines,
    "/fascicle/templates/index/modules/":   Inprint.store.Columns.tfascicle.index_modules,

    "/system/events/list/":                 Inprint.store.Columns.system.events,

    // Combos
    "/advertising/combo/managers/":         Inprint.store.Columns.common.combo,
    "/advertising/combo/advertisers/":      Inprint.store.Columns.common.combo,
    "/advertising/combo/fascicles/":        Inprint.store.Columns.common.combo,
    "/advertising/combo/places/":           Inprint.store.Columns.common.combo,
    "/advertising/combo/modules/":          Inprint.store.Columns.common.combo,

    "/calendar/combos/editions/":           Inprint.store.Columns.common.combo,
    "/calendar/combos/parents/":            Inprint.store.Columns.common.combo,
    "/calendar/combos/sources/":            Inprint.store.Columns.common.combo,

    "/catalog/combos/groups/":              Inprint.store.Columns.common.combo,
    "/catalog/combos/editions/":            Inprint.store.Columns.common.combo,
    "/catalog/combos/fascicles/":           Inprint.store.Columns.common.combo,
    "/catalog/combos/readiness/":           Inprint.store.Columns.common.combo,
    "/catalog/combos/roles/":               Inprint.store.Columns.common.combo,

    "/fascicle/combos/templates/":          Inprint.store.Columns.common.combo,
    "/fascicle/combos/workgroups/":         Inprint.store.Columns.common.combo,
    "/fascicle/combos/headlines/":          Inprint.store.Columns.common.combo,
    "/fascicle/combos/rubrics/":            Inprint.store.Columns.common.combo,

    "/documents/combos/editions/":          Inprint.store.Columns.common.combo,
    "/documents/combos/stages/":            Inprint.store.Columns.common.combo,
    "/documents/combos/assignments/":       Inprint.store.Columns.common.combo,
    "/documents/combos/managers/":          Inprint.store.Columns.common.combo,
    "/documents/combos/fascicles/":         Inprint.store.Columns.common.combo,
    "/documents/combos/headlines/":         Inprint.store.Columns.common.combo,
    "/documents/combos/rubrics/":           Inprint.store.Columns.common.combo,

    "/documents/filters/editions/":         Inprint.store.Columns.common.combo,
    "/documents/filters/groups/":           Inprint.store.Columns.common.combo,
    "/documents/filters/fascicles/":        Inprint.store.Columns.common.combo,
    "/documents/filters/headlines/":        Inprint.store.Columns.common.combo,
    "/documents/filters/rubrics/":          Inprint.store.Columns.common.combo,
    "/documents/filters/holders/":          Inprint.store.Columns.common.combo,
    "/documents/filters/managers/":         Inprint.store.Columns.common.combo,
    "/documents/filters/progress/":         Inprint.store.Columns.common.combo,

    "/options/combos/capture-destination/": Inprint.store.Columns.common.combo

};

Inprint.factory.Store = function() {

    // Store defaults
    var defaults = {
        root: "data",
        autoDestroy: true,
        idProperty: "id",
        params:{}
    };

    var items = {};

    for (var j in Inprint.factory.StoreMappings) {
        items[j] = {
            url: _url(j), fields: Inprint.factory.StoreMappings[j]
        };
    }

    return {

        // Return ArrayStore
        array: function(myclass, config) {
            if (items[myclass]) {
                var configuration = {};
                configuration = Ext.apply(configuration, defaults);
                configuration = Ext.apply(configuration, items[myclass]);
                configuration = Ext.apply(configuration, config);
                return new Ext.data.ArrayStore(configuration);
            }
            alert("Can't find array store <" + myclass + ">");
            return false;
        },

        //Return JsonStore
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

        // Return GroupStore
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
            }
            alert("Can't find group store <" + myclass + ">");
            return false;
        }

    };

} ();
