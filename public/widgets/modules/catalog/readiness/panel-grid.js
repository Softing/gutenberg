Inprint.catalog.readiness.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            "list":        "/catalog/readiness/list/",
            "create": _url("/catalog/readiness/create/"),
            "read":   _url("/catalog/readiness/read/"),
            "update": _url("/catalog/readiness/update/"),
            "delete": _url("/catalog/readiness/delete/")
        };

        this.store = Inprint.factory.Store.json(this.urls.list,{
            autoLoad:true
        });
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            this.selectionModel,
            {
                id:"color",
                header: _("Color"),
                width: 40,
                sortable: true,
                dataIndex: "color",
                renderer: function(value){
                    return '<div style="background:#'+ value +'">&nbsp;</div>';
                }
            },
            {
                id:"percent",
                header: _("Percent"),
                width: 60,
                sortable: true,
                dataIndex: "percent"
            },
            {
                id:"shortcut",
                header: _("Shortcut"),
                width: 120,
                sortable: true,
                dataIndex: "shortcut"
            },
            {
                id:"title",
                header: _("Title"),
                width: 120,
                sortable: true,
                dataIndex: "title"
            },
            {
                id:"description",
                header: _("Description"),
                sortable: true,
                dataIndex: "description"
            }
        ];

        this.tbar = [
            {
                icon: _ico("plus-button"),
                cls: "x-btn-text-icon",
                text: _("Create"),
                disabled:true,
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

        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "description"
        });

        Inprint.catalog.readiness.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.catalog.readiness.Grid.superclass.onRender.apply(this, arguments);
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
                    _FLD_DESCRIPTION,
                    _FLD_COLOR,
                    _FLD_PERCENT
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_SAVE,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Edition addition"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:350,
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

        win.show(this);

    },

    cmpUpdate: function() {

        var win = this.components["update-window"];
        if (!win) {

            var form = new Ext.FormPanel({
                url: this.urls.update,
                frame:false,
                border:false,
                labelWidth: 75,
                defaults: {
                    anchor: "100%",
                    allowBlank:false
                },
                bodyStyle: "padding:5px 5px",
                items: [
                    _FLD_HDN_ID,
                    _FLD_TITLE,
                    _FLD_SHORTCUT,
                    _FLD_DESCRIPTION,
                    _FLD_COLOR,
                    _FLD_PERCENT
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_SAVE,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Edition addition"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:350,
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
