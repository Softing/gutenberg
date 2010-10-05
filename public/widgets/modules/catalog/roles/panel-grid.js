Inprint.catalog.roles.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            list:    "/roles/list/",
            create:  _url("/roles/create/"),
            update:  _url("/roles/update/"),
            remove:  _url("/roles/delete/")
        }

        this.store = Inprint.factory.Store.json(this.urls.list);
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        // Editor
        var editor = new Inprint.factory.RowEditor({
            create: this.urls.create,
            update: this.urls.update,
            record: [
                { name: 'id', type: 'string' },
                { name: 'title', type: 'string' },
                { name: 'shortcut', type: 'string' },
                { name: 'description', type: 'string' }
            ]
        });

        editor.on("success", function() {
            this.cmpReload();
        }, this);

        // Toolbar
        this.tbar = [
            {
                icon: _ico("plus-button"),
                cls: "x-btn-text-icon",
                text: _("Add"),
                ref: "../btnCreate",
                scope:this,
                handler: function() {
                    var e = new editor.cmpRecord();
                    editor.stopEditing();
                    this.store.insert(0, e);
                    this.getView().refresh();
                    this.getSelectionModel().selectRow(0);
                    editor.startEditing(0);
                }
            },
            {
                icon: _ico("minus-button"),
                cls: "x-btn-text-icon",
                text: _("Remove"),
                disabled:true,
                ref: "../btnDelete",
                scope:this,
                handler: function() {
                    Ext.MessageBox.confirm(
                    _("Warning"),
                    _("You really wish to do this?"),
                    function(btn) {
                        if (btn == "yes") {
                            Ext.Ajax.request({
                                url: this.urls.remove,
                                scope:this,
                                success: this.cmpReload,
                                params: { id: this.getValues("id") }
                            });
                        }
                    }, this);
                }
            },
            {
                icon: _ico("key-solid"),
                cls: "x-bt  n-text-icon",
                text: _("The rights"),
                disabled:true,
                scope:this,
                ref: "../btnManageRules",
                handler: this.cmpManageRules
            }
        ];

        // Column model
        this.columns = [
            this.selectionModel,
            {
                id:"title",
                header: _("Title"),
                width: 160,
                sortable: true,
                dataIndex: "title",
                editor: {
                    xtype: 'textfield',
                    allowBlank: false
                }
            },
            {
                id:"shortcut",
                header: _("Shortcut"),
                width: 160,
                sortable: true,
                dataIndex: "shortcut",
                editor: {
                    xtype: 'textfield',
                    allowBlank: false
                }
            },
            {
                id:"description",
                header: _("Description"),
                width: 200,
                sortable: true,
                dataIndex: "description",
                editor: {
                    xtype: 'textfield'
                }
            },
            {
                id:"rules",
                header: _("Rules"),
                sortable: true,
                dataIndex: "rules"
            }
        ];

        Ext.apply(this, {
            disabled:true,
            border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "rules",
            plugins: [editor]
        });

        Inprint.catalog.roles.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.catalog.roles.Grid.superclass.onRender.apply(this, arguments);
        this.on("afterrender", function(grid) {
            grid.store.load();
        });
    },

    cmpManageRules: function() {
        var win = this.components["manage-rules-window"];
        if (!win) {
            win = new Ext.Window({
                title: _("Rules"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:350,
                items: new Inprint.catalog.roles.RestrictionsPanel()
            });
            this.components["manage-rules-window"] = win;
        }
        win.show(this);
        win.items.first().cmpSetId(this.getValue("id"));
        win.items.first().cmpFill();
    }

});
