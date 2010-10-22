Inprint.cmp.DuplicateDocument.Grid = Ext.extend(Ext.grid.EditorGridPanel, {

    initComponent: function() {

        this.currentRecord;

        var xc = Inprint.factory.Combo;

        this.sm = new Ext.grid.CheckboxSelectionModel();

        this.store = Inprint.factory.Store.json("/documents/common/fascicles/");

        Ext.apply(this, {
            disabled: true,
            border: false,
            title: _("Fascicles"),
            stripeRows: true,
            columnLines: true,
            clicksToEdit: 1,
            autoExpandColumn: "shortcut",
            columns: [
                this.sm,
                {
                    id:"shortcut",
                    header: _("Shortcut"),
                    width: 120,
                    sortable: true,
                    dataIndex: "shortcut"
                },
                {
                    id: "headline",
                    header: _("Headline"),
                    width: 150,
                    dataIndex: 'headline_shortcut',
                    editor: xc.getConfig("/documents/combos/headlines/", {
                        listeners: {
                            scope: this,
                            focus: function(combo) {
                                combo.getStore().baseParams["flt_fascicle"] = this.currentRecord.get("id");
                            },
                            select: function(combo, record) {
                                this.currentRecord.set("headline", record.get("id"));
                            },
                            beforequery: function(qe) {
                                delete qe.combo.lastQuery;
                            }
                        }
                    })
                },
                {
                    id: "rubric",
                    header: _("Rubric"),
                    width: 150,
                    dataIndex: 'rubric_shortcut',
                    editor: xc.getConfig("/documents/combos/rubrics/", {
                        disabled: true,
                        listeners: {
                            scope: this,
                            show: function(combo) {
                                if (this.currentRecord.get("headline")) {
                                    combo.enable();
                                } else {
                                    combo.disable();
                                }
                            },
                            focus: function(combo) {
                                combo.getStore().baseParams["flt_headline"] = this.currentRecord.get("headline");
                            },
                            beforequery: function(qe) {
                                delete qe.combo.lastQuery;
                            }
                        }
                    })
                }
            ]
        });

        Inprint.cmp.DuplicateDocument.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {

        Inprint.cmp.DuplicateDocument.Grid.superclass.onRender.apply(this, arguments);

        this.on("beforeedit", function(e) {
            this.getSelectionModel().selectRow(e.row, true);
            this.currentRecord = e.record;
        });

        this.on("afteredit", function(e) {
            this.getSelectionModel().selectRow(e.row, true);
            var combo = this.getColumnModel().getCellEditor(e.column, e.row).field;
            e.record.set(e.field, combo.getRawValue());
        });

    }

});
