Inprint.factory.Combo = new function() {

    var defaults = {
        xtype: "combo",
        
        clearable:true,
        
        editable:false,
        forceSelection: true,

        typeAhead: true,
        triggerAction: "all",
        //hideOnSelect:false,
        //selectOnFocus:true,

        minListWidth: 200,

        valueField: "id",
        displayField: "title",
        emptyText: _("Select..."),
        fieldLabel: _("Label")
    };

    var items = {};

    //items["catalog"] = Ext.extend(Inprint.ext.Combobox, {
    //    initComponent: function() {
    //        Ext.apply(this, defaults);
    //        Ext.apply(this, {
    //            name: "catalog",
    //            valueField: "id",
    //            displayField: "shortcut",
    //            emptyText: _("Select a path1..."),
    //            fieldLabel: _("Group"),
    //            store: Inprint.factory.Store.json("/catalog/combo/"),
    //            width: this.width,
    //            editable:false,
    //            forceSelection: true,
    //            triggerAction: "all",
    //            tpl: '<tpl for="."><div class="x-combo-list-item" style="background:url('+ _ico("node") +') no-repeat;padding-left:20px;">{path}</div></tpl>',
    //            itemSelector: "div.x-combo-list-item"
    //        });
    //        items["catalog"].superclass.initComponent.apply(this, arguments);
    //    }
    //});
    //
    //items["calendar-groups"] = Ext.extend(Ext.form.ComboBox, {
    //    initComponent: function() {
    //        Ext.apply(this, defaults);
    //        Ext.apply(this, {
    //            name: "calendar-group",
    //            valueField: "id",
    //            displayField: "shortcut",
    //            emptyText: _("Select an edition..."),
    //            fieldLabel: _("Edition"),
    //            store: Inprint.factory.Store.json("/calendar/combo/groups/"),
    //            width: this.width,
    //            editable:false,
    //            forceSelection: true,
    //            triggerAction: "all",
    //            tpl: '<tpl for="."><div class="x-combo-list-item" style="background:url('+ _ico("folder") +') no-repeat;padding-left:20px;">{shortcut}</div></tpl>',
    //            itemSelector: "div.x-combo-list-item"
    //        });
    //        items["calendar-groups"].superclass.initComponent.apply(this, arguments);
    //    }
    //});
    //
    //
    //items["roles"] = Ext.extend(Ext.form.ComboBox, {
    //    initComponent: function() {
    //        Ext.apply(this, defaults);
    //        Ext.apply(this, {
    //            name: "role",
    //            hiddenName:"role",
    //            store: Inprint.factory.Store.json("/roles/list/"),
    //            width: this.width,
    //            fieldLabel: _("Role"),
    //            emptyText: _("Role") + "...",
    //            tpl: '<tpl for="."><div class="x-combo-list-item" style="background: url('+ _ico("key") +') no-repeat;padding-left:20px;">{name}</div></tpl>',
    //            itemSelector: "div.x-combo-list-item"
    //        });
    //        items["roles"].superclass.initComponent.apply(this, arguments);
    //    }
    //});
    //
    //items["chains"] = Ext.extend(Ext.form.ComboBox, {
    //    initComponent: function() {
    //        Ext.apply(this, defaults);
    //        Ext.apply(this, {
    //            name: "role",
    //            hiddenName:"role",
    //            store: Inprint.factory.Store.json("/chains/combo/"),
    //            width: this.width,
    //            fieldLabel: _("Chain"),
    //            emptyText: _("Select chain") + "...",
    //            tpl: '<tpl for=".">'+
    //                '<div class="x-combo-list-item" style="background: url('+ _ico("arrow-switch") +') no-repeat;padding-left:20px;">'+
    //                    '{shortcut}<br><small><i>{catalog_shortcut}</i></small>'+
    //                '</div></tpl>',
    //            itemSelector: "div.x-combo-list-item"
    //        });
    //        items["roles"].superclass.initComponent.apply(this, arguments);
    //    }
    //});
    
    var combos = {
        
        // Catalog
        "/catalog/combo/": {
            name: "catalog",
            fieldLabel: _("Group"),
            emptyText: _("Select a path1...")
        },
        
        "/roles/list/": {
            name: "role",
            fieldLabel: _("Role"),
            emptyText: _("Role") + "..."
        },
        
        // Exchange
        "/chains/combo/": {
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
            icon: "node",
            emptyText: _("Select an group..."),
            fieldLabel: _("Group")
        },
        
        "/documents/combos/fascicles": {
            name: "fascicle",
            emptyText: _("Select an fascicle..."),
            fieldLabel: _("Fascicle")
        },
        
        "/documents/combos/headlines": {
            name: "headline",
            emptyText: _("Select an headline..."),
            fieldLabel: _("Headline")
        },
        
        "/documents/combos/rubrics": {
            name: "rubric",
            emptyText: _("Select an rubric..."),
            fieldLabel: _("rubric")
        },
        
        "/documents/combos/holders": {
            name: "holder",
            icon: "user",
            emptyText: _("Select an holder..."),
            fieldLabel: _("Holder")
        },
        
        "/documents/combos/managers": {
            name: "manager",
            icon: "user",
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
            if (combo.icon) {
                Ext.apply(combo, {
                    tpl:    '<tpl for=".">'+
                               '<div class="x-combo-list-item" style="background: url('+ _ico( combo.icon ) +') no-repeat;padding-left:20px;">'+
                                    '{shortcut}'+
                                    '<tpl if="description"><br><small><i>{description}</i></small></tpl>'+
                                '</div>'+
                            '</tpl>',
                    itemSelector: "div.x-combo-list-item"
                });
            } else {
                Ext.apply(combo, {
                    tpl:    '<tpl for=".">'+
                               '<div class="x-combo-list-item">'+
                                    '{shortcut}'+
                                    '<tpl if="description"><br><small><i>{description}</i></small></tpl>'+
                                '</div>'+
                            '</tpl>'
                });
            }
            
            // Add custom config
            if (combos[url] && config)
                Ext.apply(combo, config);
            
            return combo;
            
        },
        
        create: function(url, config) {

            if (combos[url]) {

                //var combo = new items[myclass](config);
                
                var combo = this.getConfig(url, config);
                
                //if (config && config.disableCaching) {
                //    combo.on("beforequery", function(qe){ delete qe.combo.lastQuery; });
                //}
                
                return combo;
            }

            alert("Can't find combobox <" + myclass + ">");
            return new Ext.Component();
        }
    };

}
