Inprint.cmp.DuplicateDocument.Grid = Ext.extend(Ext.grid.EditorGridPanel, {

    initComponent: function() {

        this.currentRecord = null;

        var xc = Inprint.factory.Combo;

        this.sm = new Ext.grid.CheckboxSelectionModel();

        this.store = Inprint.factory.Store.json("/documents/common/fascicles/", {
            autoLoad:true
        });

        Ext.apply(this, {
            border: false,
            title: _("Fascicles"),
            stripeRows: true,
            columnLines: true,
            clicksToEdit: 1,
            autoExpandColumn: "shortcut",
            columns: [
                this.sm,
                {
                    id:"edition",
                    header: _("Edition"),
                    width: 80,
                    sortable: true,
                    dataIndex: "edition_shortcut"
                },
                {
                    id:"shortcut",
                    header: _("Shortcut"),
                    width: 100,
                    sortable: true,
                    dataIndex: "shortcut"
                },
                {
                    id: "headline",
                    header: _("Headline"),
                    width: 100,
                    dataIndex: 'headline_shortcut',
                    editor: xc.getConfig("/documents/combos/headlines/", {
                        listeners: {
                            scope: this,
                            select: function(combo, record) {
                                this.currentRecord.set("headline", record.get("id"));
                            },
                            beforequery: function(qe) {
                                delete qe.combo.lastQuery;
                                qe.combo.getStore().baseParams.flt_edition = this.currentRecord.get("edition");
                                qe.combo.getStore().baseParams.flt_fascicle = this.currentRecord.get("id");
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
                            select: function(combo, record) {
                                this.currentRecord.set("rubric", record.get("id"));
                            },
                            beforequery: function(qe) {
                                delete qe.combo.lastQuery;
                                qe.combo.getStore().baseParams.flt_edition =  this.currentRecord.get("edition");
                                qe.combo.getStore().baseParams.flt_fascicle = this.currentRecord.get("id");
                                qe.combo.getStore().baseParams.flt_headline = this.currentRecord.get("headline");
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
