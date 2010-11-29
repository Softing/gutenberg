Inprint.advert.modules.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.params = {};
        this.components = {};
        this.urls = {
            "create": _url("/advertising/modules/create/"),
            "read":   _url("/advertising/modules/read/"),
            "update": _url("/advertising/modules/update/"),
            "delete": _url("/advertising/modules/delete/")
        }

        this.store = Inprint.factory.Store.json("/advertising/modules/list/");
        
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            this.selectionModel,
            {
                id:"amount",
                header: _("Amount"),
                width: 50,
                sortable: true,
                dataIndex: "amount"
            },
            {
                id:"volume",
                header: _("Volume"),
                width: 50,
                sortable: true,
                dataIndex: "volume"
            },
            {
                id:"size",
                header: _("Size"),
                width: 50,
                sortable: true,
                renderer: function(v, p, record) {
                    var w = record.get("w");
                    var h = record.get("h");
                    return  w +"x"+ h;
                }
            },
            {
                id:"title",
                header: _("Title"),
                width: 150,
                sortable: true,
                dataIndex: "title"
            },
            {
                id:"shortcut",
                header: _("Shortcut"),
                width: 150,
                sortable: true,
                dataIndex: "shortcut"
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
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "description"
        });

        Inprint.advert.modules.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.advert.modules.Grid.superclass.onRender.apply(this, arguments);
    },
    
    
    cmpCreate: function() {

        var win = this.components["create-window"];
        if (!win) {

            var form = new Ext.FormPanel({
                url: this.urls["create"],
                frame:false,
                border:false,
                labelWidth: 75,
                defaults: {
                    anchor: "100%",
                    allowBlank:false
                },
                bodyStyle: "padding:5px 5px",
                items: [
                    _FLD_HDN_PLACE,
                    _FLD_TITLE,
                    _FLD_SHORTCUT,
                    _FLD_DESCRIPTION,
                    {
                        xtype: "textfield",
                        allowBlank:false,
                        name: "amount",
                        fieldLabel: _("Amount")
                    },
                    {
                        xtype: "textfield",
                        allowBlank:false,
                        name: "volume",
                        fieldLabel: _("Volume")
                    },
                    {
                        xtype: "textfield",
                        allowBlank:false,
                        name: "w",
                        fieldLabel: _("Width")
                    },
                    {
                        xtype: "textfield",
                        allowBlank:false,
                        name: "h",
                        fieldLabel: _("Height")
                    }
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_SAVE,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Create role"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:320,
                items: form
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit")
                    win.hide();
                this.cmpReload();
            }, this);

            this.components["create-window"] = win;
        }

        var form = win.items.first().getForm();
        form.reset();
        
        form.findField("place").setValue(this.params["place"]);

        win.show();

    },

    cmpUpdate: function() {

        var win = this.components["update-window"];
        if (!win) {

            var form = new Ext.FormPanel({
                border:false,
                labelWidth: 75,
                url: this.urls["update"],
                bodyStyle: "padding:5px 5px",
                defaults: {
                    anchor: "100%",
                    allowBlank:false
                },
                items: [
                    _FLD_HDN_ID,
                    _FLD_TITLE,
                    _FLD_SHORTCUT,
                    _FLD_DESCRIPTION,
                    {
                        xtype: "textfield",
                        allowBlank:false,
                        name: "amount",
                        fieldLabel: _("Amount")
                    },
                    {
                        xtype: "textfield",
                        allowBlank:false,
                        name: "volume",
                        fieldLabel: _("Volume")
                    },
                    {
                        xtype: "textfield",
                        allowBlank:false,
                        name: "w",
                        fieldLabel: _("Width")
                    },
                    {
                        xtype: "textfield",
                        allowBlank:false,
                        name: "h",
                        fieldLabel: _("Height")
                    }
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_SAVE,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Update role"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:320,
                items: form
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit")
                    win.hide();
                this.cmpReload();
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
