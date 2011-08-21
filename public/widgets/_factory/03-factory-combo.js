// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.factory.Combo = function() {

    var items = {};

    var combos = {

        //Calendar
        //"/calendar/combos/editions/": {
        //    hiddenName: "edition",
        //    icon: "blue-folders",
        //    fieldLabel: _("Edition")
        //},
        //"/calendar/combos/sources/": {
        //    hiddenName: "template",
        //    icon: "building",
        //    fieldLabel: _("Template")
        //},
        //"/calendar/combos/childrens/": {
        //    hiddenName: "edition",
        //    icon: "blue-folders",
        //    fieldLabel: _("Edition")
        //},
        "/calendar/combos/parents/": {
            hiddenName: "parent",
            icon: "building",
            fieldLabel: _("Issue")
        },
        "/calendar/combos/copyfrom/": {
            hiddenName: "copyfrom",
            icon: "puzzle",
            fieldLabel: _("Copy from")
        },
        "/calendar/combos/templates/": {
            hiddenName: "template",
            icon: "puzzle",
            fieldLabel: _("Template")
        },

        // Catalog
        "/catalog/combos/editions/": {
            hiddenName: "edition",
            icon: "building",
            fieldLabel: _("Edition")
        },
        "/catalog/combos/groups/": {
            hiddenName: "catalog",
            icon: "building",
            fieldLabel: _("Group")
        },
        "/catalog/combos/fascicles/": {
            hiddenName: "catalog",
            icon: "book",
            fieldLabel: _("Fascicle")
        },
        "/catalog/combos/readiness/": {
            hiddenName: "readiness",
            fieldLabel: _("Readiness")
        },
        "/catalog/combos/roles/": {
            hiddenName: "role",
            fieldLabel: _("Role")
        },

        // Advertising
        "/advertising/combo/managers/": {
            hiddenName: "manager",
            fieldLabel: _("Manager")
        },
        "/advertising/combo/advertisers/": {
            hiddenName: "advertiser",
            fieldLabel: _("Advertiser")
        },
        "/advertising/combo/fascicles/": {
            hiddenName: "fascicle",
            fieldLabel: _("Fascicle")
        },
        "/advertising/combo/places/": {
            hiddenName: "place",
            fieldLabel: _("Place")
        },
        "/advertising/combo/modules/": {
            hiddenName: "module",
            fieldLabel: _("Module")
        },

        // Fascicles
        "/fascicle/combos/templates/": {
            hiddenName: "template",
            fieldLabel: _("Template")
        },
        "/fascicle/combos/headlines/": {
            hiddenName: "headline",
            fieldLabel: _("Headline")
        },
        "/fascicle/combos/rubrics/": {
            hiddenName: "rubric",
            fieldLabel: _("Rubric")
        },

        // Templates
        "/template/combos/templates/": {
            hiddenName: "template",
            fieldLabel: _("Template")
        },
        "/template/combos/headlines/": {
            hiddenName: "headline",
            fieldLabel: _("Headline")
        },
        "/template/combos/rubrics/": {
            hiddenName: "rubric",
            fieldLabel: _("Rubric")
        },

        // Combos for documents dialogs
        "/documents/combos/editions/": {
            hiddenName: "edition",
            icon: "toggle-small",
            fieldLabel: _("Edition")
        },
        "/documents/combos/stages/": {
            hiddenName: "stage",
            icon: "toggle-small",
            fieldLabel: _("Stage")
        },
        "/documents/combos/assignments/": {
            hiddenName: "assignment",
            icon: "toggle-small",
            fieldLabel: _("Assignment")
        },
        "/documents/combos/managers/": {
            name: "manager-shortcut",
            hiddenName: "manager",
            icon: "user-business",
            fieldLabel: _("Manager")
        },
        "/documents/combos/fascicles/": {
            hiddenName: "fascicle",
            icon:"folder",
            fieldLabel: _("Fascicle")
        },
        "/documents/combos/headlines/": {
            hiddenName: "headline",
            icon: "tag-label",
            fieldLabel: _("Headline")
        },
        "/documents/combos/rubrics/": {
            hiddenName: "rubric",
            icon: "tag-label-pink",
            fieldLabel: _("Rubric")
        },

        // Combos for document grid filters
        "/documents/filters/editions/": {
            hiddenName: "edition",
            icon: "toggle-small",
            fieldLabel: _("Edition")
        },
        "/documents/filters/groups/": {
            hiddenName: "group",
            icon: "toggle-small",
            fieldLabel: _("Group")
        },
        "/documents/filters/fascicles/": {
            hiddenName: "fascicle",
            icon:"folder",
            fieldLabel: _("Fascicle")
        },
        "/documents/filters/headlines/": {
            hiddenName: "headline",
            icon: "marker",
            fieldLabel: _("Headline")
        },
        "/documents/filters/rubrics/": {
            hiddenName: "rubric",
            icon: "marker",
            fieldLabel: _("Rubric")
        },
        "/documents/filters/holders/": {
            hiddenName: "holder",
            icon: "user-business",
            fieldLabel: _("Holder")
        },
        "/documents/filters/managers/": {
            hiddenName: "manager",
            icon: "user-business",
            fieldLabel: _("Manager")
        },
        "/documents/filters/progress/": {
            hiddenName: "progress",
            fieldLabel: _("Progress")
        },

        "/options/combos/capture-destination/": {
            hiddenName: "capture.destination",
            fieldLabel: _("Default destination")
        }

    };

    return {

        getConfig: function(url, comboconfig, storeconfig) {

            var combotpl = new Ext.XTemplate(
                '<tpl for=".">'+
                    '<div class="x-combo-list-item" style="'+
                    '{[ this.haveIcon(values) ]}'+
                    '<tpl if="nlevel"> padding-left:{nlevel*10+8}px; </tpl>'+
                    '<tpl if="!nlevel && !color"> padding-left:23px; </tpl>'+
                    '<tpl if="bold"> font-weight:bold;padding-top:4px;padding-bottom:4px;</tpl>'+
                    '<tpl if="spacer"> padding-bottom:8px;margin-bottom:4px;border-bottom:1px solid silver; </tpl>'+
                    '">'+
                        '<tpl if="color"><div style="width:10px;height:10px;margin:2px 5px 2px 3px;float:left;background:#{color};">&nbsp;</div></tpl>'+
                        '{title}'+
                        '<tpl if="description"><div style="color:silver">{description}</div></tpl>'+
                    '</div>'+
                '</tpl>',
                {
                    haveIcon: function(values) {

                        var src = '';
                        var hpadding = 3;
                        var vpadding = 3;

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

            var combo = {
                xtype: "combo",
                editable:false,
                clearable:false,

                valueField: "id",
                displayField: "title",

                fieldLabel: _("Label"),
                emptyText: _("Select..."),

                minChars:2,
                queryDelay: 50,
                minListWidth: 200,

                forceSelection: true,
                triggerAction: "all",

                tpl: combotpl,
                itemSelector: "div.x-combo-list-item",

                store: {
                    url: url,
                    root: "data",
                    baseParams: {  },
                    idProperty: "id",
                    autoDestroy: true,
                    xtype: "jsonstore",
                    fields: Inprint.store.Columns.common.combo
                }
            };

            // Add predefined configuration
            Ext.apply(combo, combos[url]);

            // Add custom configuration
            if (comboconfig) Ext.apply(combo, comboconfig);

            // Add store configuration
            if (storeconfig) Ext.apply(combo.store, storeconfig);

            // Add baseparams to store configuration
            if (comboconfig && comboconfig.baseParams)  Ext.apply(combo.store.baseParams, comboconfig.baseParams);

            if (!combo.emptyText) {
                combo.emptyText = _("Select...");
            }

            return combo;
        },

        create: function(url, comboconfig, storeconfig) {
            if (combos[url]) {
                var combo = this.getConfig(url, comboconfig, storeconfig);
                return combo;
            }
            alert("Can't find combobox <" + url + ">");
            return new Ext.Component();
        }
    };

} ();
