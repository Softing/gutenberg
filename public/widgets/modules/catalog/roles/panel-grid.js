Inprint.catalog.roles.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            "list":        "/catalog/roles/list/",
            "create": _url("/catalog/roles/create/"),
            "read":   _url("/catalog/roles/read/"),
            "update": _url("/catalog/roles/update/"),
            "delete": _url("/catalog/roles/delete/")
        };

        this.store = Inprint.factory.Store.json(this.urls.list, {
            autoLoad:true
        });

        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        // Toolbar
        this.tbar = [
            {
                icon: _ico("plus-button"),
                cls: "x-btn-text-icon",
                text: _("Add"),
                ref: "../btnCreate",
                scope:this,
                handler: this.cmpCreate
            },
            {
                icon: _ico("pencil"),
                cls: "x-btn-text-icon",
                text: _("Update"),
                disabled:true,
                ref: "../btnUpdate",
                scope:this,
                handler: this.cmpUpdate
            },
            {
                icon: _ico("key-solid"),
                cls: "x-bt  n-text-icon",
                text: _("The rights"),
                disabled:true,
                scope:this,
                ref: "../btnManageRules",
                handler: this.cmpManageRules
            },
            '-',
            {
                icon: _ico("minus-button"),
                cls: "x-btn-text-icon",
                text: _("Remove"),
                disabled:true,
                ref: "../btnDelete",
                scope:this,
                handler: this.cmpDelete
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
                dataIndex: "title"
            },
            {
                id:"shortcut",
                header: _("Shortcut"),
                width: 160,
                sortable: true,
                dataIndex: "shortcut"
            },
            {
                id:"description",
                header: _("Description"),
                width: 200,
                sortable: true,
                dataIndex: "description"
            },
            {
                id:"rules",
                header: _("Rules"),
                sortable: true,
                dataIndex: "rules"
            }
        ];

        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "rules"
        });

        Inprint.catalog.roles.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.catalog.roles.Grid.superclass.onRender.apply(this, arguments);
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
    },


    cmpCreate: function() {

        var win = this.components["create-window"];
        if (!win) {

            var form = new Ext.FormPanel({
                url: this.urls.create,
                frame:false,
                border:false,
                labelWidth: 75,
                defaults: {
                    anchor: "100%",
                    allowBlank:false
                },
                bodyStyle: "padding:5px 5px",
                items: [
                    _FLD_TITLE,
                    _FLD_SHORTCUT,
                    _FLD_DESCRIPTION
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_SAVE,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Create role"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:300,
                items: form
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit") {
                    win.hide();
                }
                this.getStore().load();
            }, this);

            this.components["create-window"] = win;
        }

        var form = win.items.first().getForm();
        form.reset();

        win.show();

    },

    cmpUpdate: function() {

        var win = this.components["update-window"];
        if (!win) {

            var form = new Ext.FormPanel({
                border:false,
                labelWidth: 75,
                url: this.urls.update,
                bodyStyle: "padding:5px 5px",
                defaults: {
                    anchor: "100%",
                    allowBlank:false
                },
                items: [
                    _FLD_HDN_ID,
                    _FLD_TITLE,
                    _FLD_SHORTCUT,
                    _FLD_DESCRIPTION
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_SAVE,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Update role"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:260,
                items: form
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit") {
                    win.hide();
                }
                this.getStore().load();
            }, this);

            this.components["update-window"] = win;
        }

        var form = win.items.first().getForm();
        form.reset();

        form.load({
            url: this.urls.read,
            scope:this,
            params: {
                id: this.getValue("id")
            },
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });

        win.show(this);
    },

    cmpDelete: function() {
        Ext.MessageBox.confirm(
            _("Warning"),
            _("You really wish to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls["delete"],
                        scope:this,
                        success: this.cmpReload,
                        params: { id: this.getValues("id") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }

});
