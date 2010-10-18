Inprint.cmp.memberRulesForm.Editions.Restrictions = Ext.extend(Ext.grid.EditorGridPanel, {

    initComponent: function() {

        this.uid;
        this.record;

        this.components = {};

        this.urls = {
            "list":    "/catalog/rules/list/",
            "save":    _url("/catalog/rules/map/"),
            "fill":    _url("/catalog/rules/mapping/")
        };

        this.sm = new Ext.grid.CheckboxSelectionModel({
            checkOnly:true
        });

        this.store = Inprint.factory.Store.group(this.urls.list, {
            autoLoad: false
        });

        this.view = new Ext.grid.GroupingView({
            forceFit:true,
            showGroupName:false,
            hideGroupedColumn:true
        });

        Ext.apply(this, {
            disabled: true,
            stripeRows: true,
            columnLines: true,
            clicksToEdit: 1,
            columns: [
                this.sm,
                {
                    id:"shortcut",
                    header: _("Rule"),
                    width: 120,
                    sortable: true,
                    dataIndex: "shortcut"
                },
                {
                    id:"groupby",
                    header: _("Group by"),
                    width: 120,
                    sortable: true,
                    dataIndex: "groupby"
                }
            ],

            tbar: [
                {
                    icon: _ico("disk-black"),
                    cls: "x-btn-text-icon",
                    text: _("Save"),
                    ref: "../btnSave",
                    scope:this,
                    handler: this.cmpSave
                },
                '->',
                {
                    icon: _ico("arrow-circle-double"),
                    cls: "x-btn-icon",
                    scope:this,
                    handler: function() { this.cmpFill(this.memberId, this.nodeId); }
                }
            ]
        });

        Inprint.cmp.memberRulesForm.Editions.Restrictions.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.memberRulesForm.Editions.Restrictions.superclass.onRender.apply(this, arguments);
        this.getStore().load();
    },

    cmpFill: function(member, node) {

        this.memberId = member;
        this.nodeId = node;

        this.getSelectionModel().clearSelections();
        this.getStore().rejectChanges();

        this.body.mask(_("Loading"));

        Ext.Ajax.request({
            url: this.urls.fill,
            scope:this,
            params: {
                member: member,
                binding: node
            },
            callback: function() {
                this.body.unmask();
            },
            success: function(responce) {

                var result = Ext.util.JSON.decode(responce.responseText);

                var store = this.getStore();

                for (var i in result.data) {
                    var rule = i;
                    var mode = result.data[i];
                    var record = store.getById(rule);

                    if (record) {
                        this.getSelectionModel().selectRecords([ record ], true);
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
        });
    },

    cmpSave: function() {
        var data = [];
        Ext.each(this.getSelectionModel().getSelections(), function(record) {
            var id = record.get("id");
            var mode = "edition";
            data.push( id + "::" + mode );
        });
        Ext.Ajax.request({
            url: this.urls.save,
            scope:this,
            success: this.cmpReload,
            params: {
                rules: data,
                member: this.memberId,
                binding: this.nodeId
            }
        });
    }

});
