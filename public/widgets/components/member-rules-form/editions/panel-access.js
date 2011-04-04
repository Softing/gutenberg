Inprint.cmp.memberRulesForm.Editions.Restrictions = Ext.extend(Ext.grid.EditorGridPanel, {

    initComponent: function() {

        var url = "/catalog/rules/list/";

        this.sm = new Ext.grid.CheckboxSelectionModel({
            checkOnly:true
        });

        this.store = Inprint.factory.Store.json(url, {
            autoLoad: false,
            baseParams: {
                section: this.cmpGetSection()
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
                editor: new Ext.form.ComboBox({
                    lazyRender : true,
                    store: new Ext.data.ArrayStore({
                        fields: ['id', 'name'],
                        data: [
                            [ 'edition', _("Edition")],
                            [ 'editions', _("Editions")]
                        ]
                    }),
                    mode: 'local',
                    hiddenName: "id",
                    valueField: "id",
                    displayField:'name',
                    editable:false,
                    forceSelection: true,
                    emptyText:_("Limitation..."),
                    listeners: {
                        expand: function(combo) {
                            var store = combo.getStore();
                            store.removeAll();
                            store.loadData([
                                [ 'edition', _("Edition")],
                                [ 'editions', _("Editions")]
                            ]);
                        }
                    }
                })
            }
        ];

        this.tbar = [
            {
                icon: _ico("disk-black"),
                cls: "x-btn-text-icon",
                text: _("Save"),
                ref: "../btnSave",
                scope:this
            },
            '->',
            {
                icon: _ico("broom"),
                cls: "x-btn-text-icon",
                text: _("Clear rights"),
                ref: "../btnClear",
                scope:this
            }
        ];

        Ext.apply(this, {
            disabled: true,
            stripeRows: true,
            columnLines: true,
            clicksToEdit: 1,
            autoExpandColumn: "title"
        });

        Inprint.cmp.memberRulesForm.Editions.Restrictions.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.memberRulesForm.Editions.Restrictions.superclass.onRender.apply(this, arguments);

        this.on("afteredit", function(e) {
            var combo = this.getColumnModel().getCellEditor(e.column, e.row).field;
            e.record.set("limit", combo.getRawValue());
            e.record.set("selection", combo.getValue());
            this.getSelectionModel().selectRow(e.row, true);
        });

        this.getStore().load();
    },

    cmpSetBinding: function(id) {
        this.nodeId = id;
    },

    cmpGetBinding: function() {
        return this.nodeId;
    },

    cmpGetSection: function() {
        return "editions";
    }

});
