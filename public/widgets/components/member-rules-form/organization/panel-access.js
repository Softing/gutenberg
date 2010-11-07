Inprint.cmp.memberRulesForm.Organization.Restrictions = Ext.extend(Ext.grid.EditorGridPanel, {

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

        this.store = Inprint.factory.Store.json(this.urls.list, {
            autoLoad: false,
            baseParams: {
                section: 'catalog'
            }
        });

        this.columns = [
            this.sm,
            {
                id:"icon",
                width: 30,
                dataIndex: "icon",
                renderer: function (value, meta, record) {
                    return '<img src="'+ _ico(value) +'"/>';
                }
            },
            {
                id:"title",
                header: _("Rule"),
                width: 120,
                sortable: true,
                dataIndex: "title",
                renderer: function (value, meta, record) {
                    return _(value);
                }
            },
            {
                id: "limit",
                width: 120,
                header: _("Limit"),
                dataIndex: 'limit',
                renderer: function(value, metadata, record, row, col, store) {
                    if (value == undefined || value == "") {
                        return _("Employee");
                    }
                    return value;
                },
                editor: new Ext.form.ComboBox({
                    lazyRender : true,
                    store: new Ext.data.ArrayStore({
                        fields: ['id', 'name'],
                        data : [
                            [ 'member', _("Employee")],
                            [ 'group', _("Group")]
                        ]
                    }),
                    hiddenName: "id",
                    valueField: "id",
                    displayField:'name',
                    mode: 'local',
                    forceSelection: true,
                    editable:false,
                    emptyText:_("Limitation...")
                })
            }
        ];

        Ext.apply(this, {
            disabled:true,
            stripeRows: true,
            columnLines: true,
            clicksToEdit: 1,
            autoExpandColumn: "title"
        });

        Inprint.cmp.memberRulesForm.Organization.Restrictions.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.memberRulesForm.Organization.Restrictions.superclass.onRender.apply(this, arguments);
        this.on("afteredit", function(e) {
            var combo = this.getColumnModel().getCellEditor(e.column, e.row).field;
            e.record.set(e.field, combo.getRawValue());
            e.record.set("selection", combo.getValue());
            this.getSelectionModel().selectRow(e.row, true);
        });
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
                binding: node,
                member: member,
                section: "catalog"
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
            }
        });
    },

    cmpSave: function() {
        var data = [];
        Ext.each(this.getSelectionModel().getSelections(), function(record) {
            var id = record.get("id");
            var mode = record.get("selection") || "member";
            data.push( id + "::" + mode );
        });
        Ext.Ajax.request({
            url: this.urls.save,
            scope:this,
            params: {
                rules: data,
                section: "catalog",
                member: this.memberId,
                binding: this.nodeId
            },
            success: function() {
                this.cmpReload;
                new Ext.ux.Notification({
                    iconCls: 'event',
                    title: _("System event"),
                    html: _("Changes have been saved")
                }).show(document);
            }
        });
    }

});
