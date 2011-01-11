Inprint.factory.Combo = new function() {

    var defaults = {
        xtype: "combo",

        clearable:false,

        editable:false,
        forceSelection: true,
        triggerAction: "all",

        minChars:2,
        queryDelay: 50,

        minListWidth: 200,
        valueField: "id",
        displayField: "title",
        emptyText: _("Select..."),
        fieldLabel: _("Label")
    };

    var items = {};

    var combos = {

        //Calendar
        "/calendar/combos/editions/": {
            hiddenName: "edition",
            icon: "blue-folders",
            fieldLabel: _("Edition"),
            emptyText: _("Select") + "..."
        },
        "/calendar/combos/sources/": {
            hiddenName: "copyfrom",
            icon: "building",
            fieldLabel: _("Copy from"),
            emptyText: _("Select") + "..."
        },
        "/calendar/combos/parents/": {
            hiddenName: "copypages",
            icon: "building",
            fieldLabel: _("Copy pages"),
            emptyText: _("Select") + "..."
        },

        // Catalog
        "/catalog/combos/editions/": {
            hiddenName: "edition",
            icon: "building",
            fieldLabel: _("Edition"),
            emptyText: _("Select") + "..."
        },
        "/catalog/combos/groups/": {
            hiddenName: "catalog",
            icon: "building",
            fieldLabel: _("Group"),
            emptyText: _("Select") + "..."
        },
        "/catalog/combos/fascicles/": {
            hiddenName: "catalog",
            icon: "book",
            fieldLabel: _("Fascic;e"),
            emptyText: _("Select") + "..."
        },
        "/catalog/combos/readiness/": {
            hiddenName: "readiness",
            fieldLabel: _("Readiness"),
            emptyText: _("Select") + "..."
        },
        "/catalog/combos/roles/": {
            hiddenName: "role",
            fieldLabel: _("Role"),
            emptyText: _("Select") + "..."
        },

        // Advertising
        "/advertising/combo/managers/": {
            hiddenName: "manager",
            fieldLabel: _("Manager"),
            emptyText: _("Manager") + "..."
        },
        "/advertising/combo/advertisers/": {
            hiddenName: "advertiser",
            fieldLabel: _("Advertiser"),
            emptyText: _("Advertiser") + "..."
        },
        "/advertising/combo/fascicles/": {
            hiddenName: "fascicle",
            fieldLabel: _("Fascicle"),
            emptyText: _("Fascicle") + "..."
        },
        "/advertising/combo/places/": {
            hiddenName: "place",
            fieldLabel: _("Place"),
            emptyText: _("Place") + "..."
        },
        "/advertising/combo/modules/": {
            hiddenName: "module",
            fieldLabel: _("Module"),
            emptyText: _("Module") + "..."
        },

        //// Calendar
        //"/calendar/combo/groups/": {
        //    hiddenName: "calendar-group",
        //    fieldLabel: _("Edition"),
        //    emptyText: _("Edition") + "..."
        //},

        // Fascicles
        "/fascicle/combos/templates/": {
            hiddenName: "template",
            fieldLabel: _("Template"),
            emptyText: _("Template") + "..."
        },
        "/fascicle/combos/workgroups/": {
            hiddenName: "workgroup",
            fieldLabel: _("Workgroup"),
            emptyText: _("Workgroup") + "..."
        },
        "/fascicle/combos/headlines/": {
            hiddenName: "headline",
            fieldLabel: _("Headline"),
            emptyText: _("Headline") + "..."
        },
        "/fascicle/combos/rubrics/": {
            hiddenName: "rubric",
            fieldLabel: _("Rubric"),
            emptyText: _("Rubric") + "..."
        },

        // Combos for documents dialogs
        "/documents/combos/editions/": {
            hiddenName: "edition",
            icon: "toggle-small",
            fieldLabel: _("Edition"),
            emptyText: _("Edition") + "..."
        },
        "/documents/combos/stages/": {
            hiddenName: "stage",
            icon: "toggle-small",
            fieldLabel: _("Stage"),
            emptyText: _("Stage") + "..."
        },
        "/documents/combos/assignments/": {
            hiddenName: "assignment",
            icon: "toggle-small",
            fieldLabel: _("Assignment"),
            emptyText: _("Assignment") + "..."
        },
        "/documents/combos/managers/": {
            name: "manager-shortcut",
            hiddenName: "manager",
            icon: "user-business",
            fieldLabel: _("Manager"),
            emptyText: _("Manager") + "..."
        },
        "/documents/combos/fascicles/": {
            hiddenName: "fascicle",
            icon:"folder",
            fieldLabel: _("Fascicle"),
            emptyText: _("Fascicle") + "..."
        },
        "/documents/combos/headlines/": {
            hiddenName: "headline",
            icon: "tag-label",
            fieldLabel: _("Headline"),
            emptyText: _("Headline") + "..."
        },
        "/documents/combos/rubrics/": {
            hiddenName: "rubric",
            icon: "tag-label-pink",
            fieldLabel: _("Rubric"),
            emptyText: _("Rubric") + "..."
        },

        // Combos for document grid filters
        "/documents/filters/editions/": {
            hiddenName: "edition",
            icon: "toggle-small",
            fieldLabel: _("Edition"),
            emptyText: _("Edition") + "..."
        },
        "/documents/filters/groups/": {
            hiddenName: "group",
            icon: "toggle-small",
            fieldLabel: _("Group"),
            emptyText: _("Group") + "..."
        },
        "/documents/filters/fascicles/": {
            hiddenName: "fascicle",
            icon:"folder",
            fieldLabel: _("Fascicle"),
            emptyText: _("Fascicle") + "..."
        },
        "/documents/filters/headlines/": {
            hiddenName: "headline",
            icon: "marker",
            fieldLabel: _("Headline"),
            emptyText: _("Headline") + "..."
        },
        "/documents/filters/rubrics/": {
            hiddenName: "rubric",
            icon: "marker",
            fieldLabel: _("Rubric"),
            emptyText: _("Rubric") + "..."
        },
        "/documents/filters/holders/": {
            hiddenName: "holder",
            icon: "user-business",
            fieldLabel: _("Holder"),
            emptyText: _("Holder") + "..."
        },
        "/documents/filters/managers/": {
            hiddenName: "manager",
            icon: "user-business",
            fieldLabel: _("Manager"),
            emptyText: _("Manager") + "..."
        },
        "/documents/filters/progress/": {
            hiddenName: "progress",
            fieldLabel: _("Progress"),
            emptyText: _("Progress") + "..."
        },

        "/options/combos/capture-destination/": {
            hiddenName: "capture.destination",
            fieldLabel: _("Default destination"),
            emptyText: _("Default destination") + "..."
        }

    };

    return {

        getConfig: function(url, config, storeconfig) {

            var combo = {};

            // Add defaults
            Ext.apply(combo, defaults);

            // Add combo item
            if (combos[url])
                Ext.apply(combo, combos[url]);

            // Add store
            if (!config) {
                config = {};
            }
            if (!storeconfig) {
                storeconfig = {};
            }

            if (config.baseParams) {
                storeconfig.baseParams = config.baseParams;
            }
            Ext.apply(combo, {
                store: Inprint.factory.Store.json( url, storeconfig )
            });

            // Add icons

            var tpl = new Ext.XTemplate(
                '<tpl for=".">'+
                    '<div class="x-combo-list-item" style="'+
                    '{[ this.haveIcon(values) ]}'+
                    '<tpl if="nlevel"> padding-left:{nlevel*10+8}px; </tpl>'+
                    '<tpl if="!nlevel && !color"> padding-left:20px; </tpl>'+
                    '<tpl if="bold"> font-weight:bold;padding-top:4px;padding-bottom:4px;</tpl>'+
                    '<tpl if="spacer"> padding-bottom:8px;margin-bottom:4px;border-bottom:1px solid silver; </tpl>'+
                    '">'+
                        '<tpl if="color"><div style="width:10px;height:10px;margin:2px 5px 2px 3px;float:left;background:#{color};">&nbsp;</div></tpl>'+
                        '{title}'+
                        '<tpl if="description"><br><small><i>{description}</i></small></tpl>'+
                    '</div>'+
                '</tpl>',
                {
                    haveIcon: function(values) {

                        var src = '';
                        var hpadding = 3;
                        var vpadding = 1;

                        if (combo.icon) {
                            src = _ico(combo.icon);
                        }

                        if (values.icon) {
                            src = _ico(values.icon);
                        }

                        if (values.description) {
                            hpadding = 4;
                        }

                        if (values.nlevel) {
                            hpadding = 2;
                            vpadding = values.nlevel * 10 - 10;
                        }

                        if (values.color) {
                            hpadding = 0;
                            vpadding = 0;
                        }

                        return ' background: url('+ src +') '+ vpadding +'px '+ hpadding +'px no-repeat; ';
                    }
                }
            );

            Ext.apply(combo, {
                tpl: tpl,
                itemSelector: "div.x-combo-list-item"
            });

            // Add custom config
            if (combos[url] && config)
                Ext.apply(combo, config);

            return combo;

        },

        create: function(url, config, storeconfig) {
            if (combos[url]) {
                var combo = this.getConfig(url, config, storeconfig);
                return combo;
            }
            alert("Can't find combobox <" + url + ">");
            return new Ext.Component();
        }
    };

}
