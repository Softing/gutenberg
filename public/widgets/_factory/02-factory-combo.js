Inprint.factory.Combo = new function() {

    var defaults = {
        xtype: "combo",

        clearable:false,
        nocache: false,

        editable:false,
        forceSelection: true,
        typeAhead: true,
        triggerAction: "all",
        hideOnSelect:false,

        minListWidth: 200,
        valueField: "id",
        displayField: "title",
        emptyText: _("Select..."),
        fieldLabel: _("Label")
    };

    var items = {};

    var combos = {

        // Catalog
        "/catalog/combos/editions/": {
            name: "edition",
            icon: "building",
            fieldLabel: _("Edition"),
            emptyText: _("Select") + "..."
        },
        "/catalog/combos/groups/": {
            name: "catalog",
            icon: "building",
            fieldLabel: _("Group"),
            emptyText: _("Select") + "..."
        },
        "/catalog/combos/fascicles/": {
            name: "catalog",
            icon: "book",
            fieldLabel: _("Fascic;e"),
            emptyText: _("Select") + "..."
        },
        "/catalog/combos/roles/": {
            name: "role",
            fieldLabel: _("Role"),
            emptyText: _("Select") + "..."
        },


        "/exchange/combos/chains/": {
            name: "chain",
            fieldLabel: _("Chain"),
            emptyText: _("Select") + "..."
        },


        // Fascicles
        "/calendar/combo/groups/": {
            name: "calendar-group",
            fieldLabel: _("Edition"),
            emptyText: _("Select") + "..."
        },


        // Documents
        "/documents/combos/groups": {
            name: "group",
            icon: "toggle-small",
            fieldLabel: _("Group"),
            emptyText: _("Select") + "..."
        },

        "/documents/combos/fascicles": {
            name: "fascicle",
            icon:"folder",
            fieldLabel: _("Fascicle"),
            emptyText: _("Select") + "..."
        },

        "/documents/combos/headlines": {
            name: "headline",
            icon: "tag-label",
            fieldLabel: _("Headline"),
            emptyText: _("Select") + "..."
        },

        "/documents/combos/rubrics": {
            name: "rubric",
            icon: "tag-label-pink",
            fieldLabel: _("rubric"),
            emptyText: _("Select") + "..."
        },

        "/documents/combos/holders": {
            name: "holder",
            icon: "user-business",
            fieldLabel: _("Holder"),
            emptyText: _("Select") + "..."
        },

        "/documents/combos/managers": {
            name: "manager",
            icon: "user-business",
            fieldLabel: _("Manager"),
            emptyText: _("Select") + "..."
        },

        "/documents/combos/progress": {
            name: "progress",
            fieldLabel: _("Progress"),
            emptyText: _("Select") + "..."
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
            Ext.apply(combo, {
                store: Inprint.factory.Store.json( url, storeconfig )
            });

            // Add icons

            var tpl = new Ext.XTemplate(
                '<tpl for=".">'+
                    '<div class="x-combo-list-item" style="'+
                    '{[ this.haveIcon(values) ]}'+
                    '<tpl if="nlevel"> padding-left:{nlevel*10+8}px; </tpl>'+
                    '<tpl if="!nlevel"> padding-left:20px; </tpl>'+
                    '<tpl if="spacer"> padding-bottom:4px;margin-bottom:4px;border-bottom:1px solid silver; </tpl>'+
                    '<tpl if="bold"> font-weight:bold; </tpl>'+
                    '">'+
                        '{title}'+
                        '<tpl if="description"><br><small><i>{description}</i></small></tpl>'+
                    '</div>'+
                '</tpl>',
                {
                    haveIcon: function(values) {

                        var src = '';
                        var hpadding = 2;
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

        create: function(url, config) {
            if (combos[url]) {
                var combo = this.getConfig(url, config);
                return combo;
            }
            alert("Can't find combobox <" + url + ">");
            return new Ext.Component();
        }
    };

}
