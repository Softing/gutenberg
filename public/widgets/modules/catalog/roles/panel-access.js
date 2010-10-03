Inprint.catalog.roles.RestrictionsPanel = Ext.extend(Ext.grid.EditorGridPanel, {

    initComponent: function() {

        this.record;

        this.components = {};

        this.urls = {
            save:    _url("/roles/map/"),
            fill:    _url("/roles/mapping/")
        };

        this.sm = new Ext.grid.CheckboxSelectionModel({
            checkOnly:true
        });

        this.store = Inprint.factory.Store.group("/rules/list/", {
            autoLoad: false
        });

        this.view = new Ext.grid.GroupingView({
            forceFit:true,
            showGroupName:false,
            //startCollapsed:true,
            hideGroupedColumn:true
        });

        Ext.apply(this, {
            title: _("Rules"),
            stripeRows: true,
            columnLines: true,
            clicksToEdit: 1,
            disabled:true,
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
                    icon: _ico("disk-black"),
                    cls: "x-btn-text-icon",
                    text: _("Save"),
                    //disabled:true,
                    ref: "../btnSave",
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
                            this.cmpFill(record.get("id"));
                        }
                    }
                }),
                {
                    icon: _ico("arrow-circle-double"),
                    cls: "x-btn-icon",
                    scope:this,
                    handler: function() { this.cmpFill(); }
                }
            ]
        });

        Inprint.catalog.roles.RestrictionsPanel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {

        Inprint.catalog.roles.RestrictionsPanel.superclass.onRender.apply(this, arguments);

        this.on("afteredit", function(e) {
            var combo = this.getColumnModel().getCellEditor(e.column, e.row).field;
            e.record.set(e.field, combo.getRawValue());
            e.record.set("selection", combo.getValue());
            this.getSelectionModel().selectRow(e.row, true);
        });

        this.getStore().load();


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
            success: this.cmpReload,
            params: {
                id: this.cmpGetId(),
                rules: data
            }
        });

    },

    cmpFill: function(loadid) {

        if (this.rendered == false)
            return;

        if (!loadid || typeof loadid != "string")
            loadid = this.cmpGetId();

        this.getSelectionModel().clearSelections();
        this.getStore().rejectChanges();

        this.body.mask(_("Loading"));

        Ext.Ajax.request({
            url: this.urls.fill,
            scope:this,
            params: {
                id: loadid
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
    }

});
