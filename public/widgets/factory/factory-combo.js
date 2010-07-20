Inprint.factory.Combo = new function() {

    var defaults = {
        clearable:true,
        editable:false,
        //forceSelection: true,
        //typeAhead: true,        
        triggerAction: "all",
        hideOnSelect:false,
        valueField: "id",
        displayField: "title"
    };

    var items = {};

    items["editions"] = Ext.extend(Ext.form.ComboBox, {
        initComponent: function() {
            Ext.apply(this, defaults);
            Ext.apply(this, {
                name:"edition",
                hiddenName:"edition",
                store: Inprint.factory.Store.json("/combo/edtions/"),
                width: this.width,
                fieldLabel: _("Edition"),
                emptyText: _("Edition") + "...",
                tpl: '<tpl for="."><div class="x-combo-list-item" style="background: url('+ _ico("newspaper.png") +') no-repeat;padding-left:20px;">{title}</div></tpl>',
                itemSelector: "div.x-combo-list-item"
            });
            items["editions"].superclass.initComponent.apply(this, arguments);
        }
    });

    items["members"] = Ext.extend(Ext.form.ComboBox, {
        initComponent: function() {
            Ext.apply(this, defaults);
            Ext.apply(this, {
                name: "member",
                hiddenName:"edition",
                store: Inprint.factory.Store.json("/combo/members/"),
                width: this.width,
                fieldLabel: _("Employee"),
                emptyText: _("Employee") + "...",
                tpl: '<tpl for="."><div class="x-combo-list-item" style="background: url('+ _ico("user.png") +') no-repeat;padding-left:20px;">{title}</div></tpl>',
                itemSelector: "div.x-combo-list-item"
            });
            items["editions"].superclass.initComponent.apply(this, arguments);
        }
    });

    items["roles"] = Ext.extend(Ext.form.ComboBox, {
        initComponent: function() {
            Ext.apply(this, defaults);
            Ext.apply(this, {
                name: "role",
                hiddenName:"role",
                store: Inprint.factory.Store.json("/combo/roles/"),
                width: this.width,
                fieldLabel: _("Role"),
                emptyText: _("Role") + "...",
                tpl: '<tpl for="."><div class="x-combo-list-item" style="background: url('+ _ico("key.png") +') no-repeat;padding-left:20px;">{title}</div></tpl>',
                itemSelector: "div.x-combo-list-item"
            });
            items["roles"].superclass.initComponent.apply(this, arguments);
        }
    });

    return {
        create: function(myclass, config) {
            
            if (items[myclass]) {

                var combo = new items[myclass](config);

                if (config.disableCaching) {
                    combo.on("beforequery", function(qe){ delete qe.combo.lastQuery; });
                }

                return combo;
            }

            alert("Can't find combobox <" + myclass + ">");
            return new Ext.Component();
        }
    };

}
