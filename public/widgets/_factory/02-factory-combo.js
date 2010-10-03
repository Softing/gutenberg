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
        "/catalog/combos/groups/": {
            name: "catalog",
            icon: "building",
            fieldLabel: _("Group"),
            emptyText: _("Select a path...")
        },
        "/catalog/combos/editions/": {
            name: "catalog",
            icon: "book",
            fieldLabel: _("Group"),
            emptyText: _("Select a path...")
        },
        "/catalog/combos/roles/": {
            name: "role",
            fieldLabel: _("Role"),
            emptyText: _("Role") + "..."
        },


        "/exchange/combos/chains/": {
            name: "chain",
            fieldLabel: _("Chain"),
            emptyText: _("Select chain") + "..."
        },


        // Fascicles
        "/calendar/combo/groups/": {
            name: "calendar-group",
            emptyText: _("Select an edition..."),
            fieldLabel: _("Edition")
        },


        // Documents
        "/documents/combos/groups": {
            name: "group",
            icon: "toggle-small",
            emptyText: _("Select an group..."),
            fieldLabel: _("Group")
        },

        "/documents/combos/fascicles": {
            name: "fascicle",
            icon:"folder",
            emptyText: _("Select an fascicle..."),
            fieldLabel: _("Fascicle")
        },

        "/documents/combos/headlines": {
            name: "headline",
            icon: "tag-label",
            emptyText: _("Select an headline..."),
            fieldLabel: _("Headline")
        },

        "/documents/combos/rubrics": {
            name: "rubric",
            icon: "tag-label-pink",
            emptyText: _("Select an rubric..."),
            fieldLabel: _("rubric")
        },

        "/documents/combos/holders": {
            name: "holder",
            icon: "user-business",
            emptyText: _("Select an holder..."),
            fieldLabel: _("Holder")
        },

        "/documents/combos/managers": {
            name: "manager",
            icon: "user-business",
            emptyText: _("Select an manager..."),
            fieldLabel: _("Manager")
        },

        "/documents/combos/progress": {
            name: "progress",
            emptyText: _("Select an progress..."),
            fieldLabel: _("Progress")
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
                '</tpl>', {
                    haveIcon: function(values) {

                        var src = '';
                        var hpadding = 2;
                        var vpadding = 1;

                        if (values.icon) {
                            src = _ico(values.icon);
                        }
                        if (combo.icon) {
                            src = _ico(combo.icon);
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
