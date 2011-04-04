Inprint.cmp.memberRulesForm.Window = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.panels = {};

        this.panels.domain = new Inprint.cmp.memberRulesForm.Domain({
            memberId: this.memberId
        });

        this.panels.editions = new Inprint.cmp.memberRulesForm.Editions({
            memberId: this.memberId
        });

        this.panels.organization = new Inprint.cmp.memberRulesForm.Organization({
            memberId: this.memberId
        });

        this.panels.tabs = new Ext.TabPanel({
            border:false,
            activeTab: 0,
            items:[
                this.panels.domain,
                this.panels.editions,
                this.panels.organization
            ]
        });

        this.tools = [{
            id: "refresh",
            scope:this,
            handler: function() {
                this.panels.tabs.getActiveTab().cmpReload();
            }
        }];

        Ext.apply(this, {
            title: _("Access rights management"),
            layout: "fit",
            modal:true,
            width:800, height:400,
            items: this.panels.tabs
        });

        Inprint.cmp.memberRulesForm.Window.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.cmp.memberRulesForm.Window.superclass.onRender.apply(this, arguments);
        Inprint.cmp.memberRulesForm.Interaction(this, this.panels);
    },

    cmpGetDomainPanel: function() {
        return this.panels.domain;
    },

    cmpGetEditionsPanel: function() {
        return this.panels.editions;
    },

    cmpGetOrganizationPanel: function() {
        return this.panels.organization;
    },

    cmpSave: function(grid) {

        var member  = this.memberId;
        var binding = grid.cmpGetBinding();
        var section = grid.cmpGetSection();

        var params = {
            rules:   [],
            member:  member,
            binding: binding,
            section: section
        };

        Ext.each(grid.getSelectionModel().getSelections(), function(record) {
            var id = record.get("id");
            var mode = record.get("selection") || section;
            params.rules.push( id + "::" + mode );
        });

        grid.body.mask(_("Loading"));

        Ext.Ajax.request({
            url: _url("/catalog/rules/map/"),
            scope:this,
            params: params,
            success: function() {
                this.cmpFill(grid);
            }
        });

    },

    cmpClear: function(grid, member) {

        var params = {
            member:  this.memberId,
            binding: grid.cmpGetBinding(),
            section: grid.cmpGetSection()
        };

        grid.body.mask(_("Loading"));

        Ext.Ajax.request({
            url: _url("/catalog/rules/clear/"),
            scope:this,
            params: params,
            success: function() {
                this.cmpFill(grid);
            }
        });

    },

    cmpFill: function(grid) {

        var section = grid.cmpGetSection();

        grid.getSelectionModel().clearSelections();
        grid.getStore().rejectChanges();

        grid.getStore().each(function(record) {

            if (section == "editions") {
                record.set("limit", _("Edition"));
                record.set("selection", "edition");
            }

            if (section == "catalog") {
                record.set("limit", _("Employee"));
                record.set("selection", "member");
            }
        });

        grid.body.mask(_("Loading"));

        Ext.Ajax.request({
            url: _url("/catalog/rules/mapping/"),
            scope: this,
            params: {
                member:  this.memberId,
                binding: grid.cmpGetBinding(),
                section: grid.cmpGetSection()
            },
            callback: function() {
                grid.body.unmask();
            },
            success: function(responce) {

                var result = Ext.util.JSON.decode(responce.responseText);
                var store  = grid.getStore();

                for (var i in result.data) {

                    var mode = result.data[i].area;
                    var record = store.getById(i);

                    if (record) {

                        record.set("icon", result.data[i].icon);

                        if (result.data[i].type == "obtained") {
                            grid.getSelectionModel().selectRecords([ record ], true);
                        }

                        if (mode == 'edition') {
                            record.set("limit", _("Edition"));
                            record.set("selection", "edition");
                        }

                        if (mode == 'editions') {
                            record.set("limit", _("Editions"));
                            record.set("selection", "editions");
                        }

                        if (mode == 'member') {
                            record.set("limit", _("Employee"));
                            record.set("selection", "member");
                        }

                        if (mode == 'group') {
                            record.set("limit", _("Group"));
                            record.set("selection", "group");
                        }

                    }

                }

                store.commitChanges();
            }
        });
    }

});
