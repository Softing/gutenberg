Inprint.settings.roles.RestrictionsPanel = Ext.extend(Ext.grid.EditorGridPanel, {
    initComponent: function() {

        this.urls = {
            list: _url("/access/rules/list/"),
            save: _url("/role/set/rules/"),
            fill: _url("/role/get/rules/")
        }

        this.params = {};

        this.selectionModel = new Ext.grid.CheckboxSelectionModel({
            checkOnly:true
        });

        var store = new Ext.data.GroupingStore({
            url: this.urls.list,
            reader: new Ext.data.JsonReader({
                root: "data", fields: [ 'id', 'icon', 'title', 'group', 'area', 'selection' ]
            }),
            remoteSort : true,
            sortInfo:false,//{field: 'id', direction: "ASC"},
            groupField:'group'
        });

        var view = new Ext.grid.GroupingView({
            forceFit:true,
            groupTextTpl: '{group}'
        });

        var cm = new Ext.grid.ColumnModel({
            columns: [
                this.selectionModel,
                {
                    hidden: true,
                    dataIndex: 'id'
                },
                {
                    hidden: true,
                    dataIndex: 'group'
                },
                {
                    header: _("Rule"),
                    dataIndex: 'title',
                    sortable: false,
                    editable: false,
                    renderer: function(value, p, r) {
                        return '<div style="padding-left:20px;background:url(' + _ico(r.get("icon")) + ') no-repeat;">' + value + '</div>';
                    }
                },
                {
                    header: _("Area"),
                    dataIndex: 'empty',
                    width: 50,
                    renderer: function(value, metadata, record, row, col, store) {
                        if (value == undefined) {
                            if (record.get("area").length == 1) {
                                record.data.selection = record.get("area")[0][0];
                                return record.get("area")[0][1];
                            }
                            return "<span style=\"color:gray;\">" + _("Select") + "...</span>";
                        }
                        
                        return value;
                    },
                    editor: new Ext.form.ComboBox({
                        width: 50,
                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender: true,
                        listClass: 'x-combo-list-small',
                        hiddenName: "id",
                        valueField: "id",
                        displayField: "title",
                        mode: 'local',
                        store: new Ext.data.ArrayStore({
                            fields: ['id', 'title']
                        })
                    })
                }
            ],
            isCellEditable: function(col, row) {
                var record = store.getAt(row);
                if (record.get("area").length == 1) {
                    return false;
                }
                return Ext.grid.ColumnModel.prototype.isCellEditable.call(this, col, row);
            }
        });

        Ext.apply(this, {
            title: _("Access"),
            disabled:true,
            cm: cm,
            view: view,
            store: store,
            clicksToEdit: 1,
            //columnLines : true,
            sm: this.selectionModel,
            autoExpandColumn: "title",
            tbar: [
                {
                    icon: _ico("disk-black.png"),
                    cls: "x-btn-text-icon",
                    text: _("Save"),
                    disabled:false,
                    ref: "../btnSave",
                    scope:this,
                    handler: this.cmpSave
                },
                '->',
                {
                    icon: _ico("arrow-circle-double.png"),
                    cls: "x-btn-icon",
                    scope:this,
                    handler: this.cmpReload
                }
            ]
        });

        Inprint.settings.roles.RestrictionsPanel.superclass.initComponent.apply(this, arguments);

        this.getStore().on("load", this.cmpFill, this);

        this.on("beforeedit", function(e) {
            var array = e.record.get("area");
            var combo = this.getColumnModel().getCellEditor(e.column, e.row).field;
            combo.getStore().loadData(array);
        });

        this.on("afteredit", function(e) {
            var combo = this.getColumnModel().getCellEditor(e.column, e.row).field;
            e.record.set(e.field, combo.getRawValue());
            e.record.set("selection", combo.getValue());
            this.getSelectionModel().selectRow(e.row, true);
        });

    },

    onRender: function() {
        Inprint.settings.roles.RestrictionsPanel.superclass.onRender.apply(this, arguments);
    },

    cmpSave: function() {
        var data = [];
        Ext.each(this.getSelectionModel().getSelections(), function(record) {
            data.push(record.get("id") + "::" + record.get("selection"));
        });
        Ext.Ajax.request({
            url: this.urls.save,
            scope:this,
            success: function() {
                this.cmpReload();
            },
            params: {
                role: this.params.role,
                rule: data
            }
        });
    },

    cmpFill: function() {

        var sm = this.getSelectionModel();
        sm.clearSelections();
        
        var store = this.getStore();

        Ext.Ajax.request({
            url: this.urls.fill,
            scope:this,
            success: function(responce) {
                var responce = Ext.util.JSON.decode(responce.responseText);
                var selection = responce.data;
                store.each(function(record) {
                    if (selection[ record.get("id") ]) {

                        var rule = record.get("id");
                        var area = selection[ record.get("id") ];

                        record.set("selection", area);

                        Ext.each(record.get("area"), function(item) {
                            if (item[0] == area) {
                                record.set("empty", "<b>"+ item[1] +"</b>");
                            }                                
                        });

                        sm.selectRecords([ record ], true);
                    }
                })
            },
            params: {
                role: this.params.role
            }
        });
    }

});
