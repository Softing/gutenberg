Inprint.cmp.AccessPanel = Ext.extend(Ext.grid.EditorGridPanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            rolemap:    "/roles/mapping/"
        };

        this.sm = new Ext.grid.CheckboxSelectionModel({
            checkOnly:true
        });

        this.store = Inprint.factory.Store.group("/rules/list/", {
            autoLoad:true
        });

        this.view = new Ext.grid.GroupingView({
            forceFit:true,
            showGroupName:false,
            startCollapsed:true,
            hideGroupedColumn:true
        });

        Ext.apply(this, {
            title: _("Group rules"),
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
                },
                {
                    id: "limit",
                    header: _("Limit"),
                    width: 50,
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
            ],

            tbar: [
                {
                    icon: _ico("plus-circle"),
                    cls: "x-btn-text-icon",
                    text: _("Save"),
                    disabled:true,
                    ref: "../btnSave",
                    scope:this,
                    handler: this.cmpSave
                },
                {
                    icon: _ico("plus-circle"),
                    cls: "x-btn-text-icon",
                    text: _("Save recursive"),
                    disabled:true,
                    ref: "../btnSaveRecursive",
                    scope:this,
                    handler: this.cmpSave
                },
                '->',
                   Inprint.factory.Combo.create("roles", {
                    width: 150,
                    disableCaching: true,
                    listeners: {
                        scope:this,
                        select: function(combo, record) {
                            this.cmpFillByRole(record.get("id"));
                        }
                    }
                }),
                {
                    icon: _ico("arrow-circle-double"),
                    cls: "x-btn-icon",
                    scope:this,
                    handler: this.cmpReload
                }
            ]
        });

        Inprint.cmp.AccessPanel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.AccessPanel.superclass.onRender.apply(this, arguments);

        this.on("afteredit", function(e) {
            var combo = this.getColumnModel().getCellEditor(e.column, e.row).field;
            e.record.set(e.field, combo.getRawValue());
            e.record.set("selection", combo.getValue());
            this.getSelectionModel().selectRow(e.row, true);
        });

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
                account: this.params.account,
                rule: data
            }
        });
    },

    cmpFill: function() {
        alert("Inprint.cmp.AccessPanel:cmpFill must be redefined!");
        //
        //var sm = this.getSelectionModel();
        //sm.clearSelections();
        //
        //var store = this.getStore();
        //
        //this.body.mask(_("Loading"));
        //
        //Ext.Ajax.request({
        //    url: this.urls.fill,
        //    scope:this,
        //    params: {
        //        account: this.params.account
        //    },
        //    success: function(responce) {
        //
        //        this.body.unmask();
        //
        //        var responce = Ext.util.JSON.decode(responce.responseText);
        //        var selection = responce.data;
        //
        //        store.each(function(record) {
        //            if (selection[ record.get("id") ]) {
        //
        //                var rule = record.get("id");
        //                var area = selection[ record.get("id") ];
        //
        //                record.set("selection", area);
        //
        //                Ext.each(record.get("area"), function(item) {
        //                    if (item[0] == area) {
        //                        record.set("empty", "<b>"+ item[1] +"</b>");
        //                    }
        //                });
        //
        //                sm.selectRecords([ record ], true);
        //            }
        //        })
        //    }
        //});
    },

    cmpFillByRole: function(role) {

        var sm = this.getSelectionModel();
        sm.clearSelections();

        var store = this.getStore();

        this.body.mask(_("Loading"));

        Ext.Ajax.request({
            url: this.urls.rolemap,
            scope:this,
            params: {
                role: role
            },
            success: function(responce) {

                this.body.unmask();

                responce = Ext.util.JSON.decode(responce.responseText);
                var selection = responce.data;

        //        store.each(function(record) {
        //            if (selection[ record.get("id") ]) {
        //
        //                var rule = record.get("id");
        //                var area = selection[ record.get("id") ];
        //
        //                record.set("selection", area);
        //
        //                Ext.each(record.get("area"), function(item) {
        //                    if (item[0] == area) {
        //                        record.set("empty", "<b>"+ item[1] +"</b>");
        //                    }
        //                });
        //
        //                sm.selectRecords([ record ], true);
        //            }
        //        })
            }
        });
    }


});
