Inprint.factory.Combo = new function() {

    var defaults = {
        clearable:true,
        editable:false,
        forceSelection: true,

        typeAhead: true,
        triggerAction: "all",
        //hideOnSelect:false,
        //selectOnFocus:true,

        valueField: "id",
        displayField: "name"
    };

    var items = {};

    items["catalog"] = Ext.extend(Ext.form.ComboBox, {
        initComponent: function() {
            Ext.apply(this, defaults);
            Ext.apply(this, {
                name: "catalog",
                valueField: "id",
                displayField: "shortcut",
                emptyText: _("Select a path..."),
                fieldLabel: _("Group"),
                store: Inprint.factory.Store.json("/catalog/combo/"),
                width: this.width,
                editable:false,
                forceSelection: true,
                triggerAction: "all",
                tpl: '<tpl for="."><div class="x-combo-list-item" style="background:url('+ _ico("node") +') no-repeat;padding-left:20px;">{path}</div></tpl>',
                itemSelector: "div.x-combo-list-item"
            });
            items["catalog"].superclass.initComponent.apply(this, arguments);
        }
    });

    items["calendar-groups"] = Ext.extend(Ext.form.ComboBox, {
        initComponent: function() {
            Ext.apply(this, defaults);
            Ext.apply(this, {
                name: "calendar-group",
                valueField: "id",
                displayField: "shortcut",
                emptyText: _("Select an edition..."),
                fieldLabel: _("Edition"),
                store: Inprint.factory.Store.json("/calendar/combo/groups/"),
                width: this.width,
                editable:false,
                forceSelection: true,
                triggerAction: "all",
                tpl: '<tpl for="."><div class="x-combo-list-item" style="background:url('+ _ico("folder") +') no-repeat;padding-left:20px;">{shortcut}</div></tpl>',
                itemSelector: "div.x-combo-list-item"
            });
            items["calendar-groups"].superclass.initComponent.apply(this, arguments);
        }
    });

    //items["members"] = Ext.extend(Ext.form.ComboBox, {
    //    initComponent: function() {
    //        Ext.apply(this, defaults);
    //        Ext.apply(this, {
    //            name: "member",
    //            hiddenName:"edition",
    //            store: Inprint.factory.Store.json("/members/list/"),
    //            width: this.width,
    //            fieldLabel: _("Employee"),
    //            emptyText: _("Employee") + "...",
    //            tpl: '<tpl for="."><div class="x-combo-list-item" style="background: url('+ _ico("user") +') no-repeat;padding-left:20px;">{name}</div></tpl>',
    //            itemSelector: "div.x-combo-list-item"
    //        });
    //        items["members"].superclass.initComponent.apply(this, arguments);
    //    }
    //});

    items["roles"] = Ext.extend(Ext.form.ComboBox, {
        initComponent: function() {
            Ext.apply(this, defaults);
            Ext.apply(this, {
                name: "role",
                hiddenName:"role",
                store: Inprint.factory.Store.json("/roles/list/"),
                width: this.width,
                fieldLabel: _("Role"),
                emptyText: _("Role") + "...",
                tpl: '<tpl for="."><div class="x-combo-list-item" style="background: url('+ _ico("key") +') no-repeat;padding-left:20px;">{name}</div></tpl>',
                itemSelector: "div.x-combo-list-item"
            });
            items["roles"].superclass.initComponent.apply(this, arguments);
        }
    });

    items["chains"] = Ext.extend(Ext.form.ComboBox, {
        initComponent: function() {
            Ext.apply(this, defaults);
            Ext.apply(this, {
                name: "role",
                hiddenName:"role",
                store: Inprint.factory.Store.json("/chains/combo/"),
                width: this.width,
                fieldLabel: _("Chain"),
                emptyText: _("Select chain") + "...",
                tpl: '<tpl for=".">'+
                    '<div class="x-combo-list-item" style="background: url('+ _ico("arrow-switch") +') no-repeat;padding-left:20px;">'+
                        '{shortcut}<br><small><i>{catalog_shortcut}</i></small>'+
                    '</div></tpl>',
                itemSelector: "div.x-combo-list-item"
            });
            items["roles"].superclass.initComponent.apply(this, arguments);
        }
    });

    return {
        create: function(myclass, config) {

            if (items[myclass]) {

                var combo = new items[myclass](config);

                if (config && config.disableCaching) {
                    combo.on("beforequery", function(qe){ delete qe.combo.lastQuery; });
                }

                return combo;
            }

            alert("Can't find combobox <" + myclass + ">");
            return new Ext.Component();
        }
    };

}
