Inprint.catalog.editions.Tree = Ext.extend(Ext.tree.TreePanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            "tree":    _url("/catalog/editions/tree/"),
            "create":  _url("/catalog/editions/create/"),
            "read":    _url("/catalog/editions/read/"),
            "update":  _url("/catalog/editions/update/"),
            "delete":  _url("/catalog/editions/delete/")
        };

        Ext.apply(this, {
            autoScroll:true,
            dataUrl: this.urls.tree,
            border:false,
            root: {
                id:'00000000-0000-0000-0000-000000000000',
                nodeType: 'async',
                expanded: true,
                draggable: false,
                icon: _ico("blue-folders"),
                text: _("All editions")
            }
        });

        Inprint.catalog.organization.Tree.superclass.initComponent.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {

            if (node.attributes.icon == undefined) {
                node.attributes.icon = 'blue-folders';
            }

            node.attributes.icon = _ico(node.attributes.icon);

            if (node.attributes.color) {
                node.text = "<span style=\"color:#"+ node.attributes.color +"\">" + node.attributes.text + "</span>";
            }

        });

    },

    onRender: function() {

        Inprint.catalog.organization.Tree.superclass.onRender.apply(this, arguments);

        this.getRootNode().on("expand", function(node) {
            node.firstChild.expand();
            node.firstChild.select();
        });

        this.getLoader().on("beforeload", function() { this.body.mask(_("Loading")); }, this);
        this.getLoader().on("load", function() { this.body.unmask(); }, this);

    },

    // Create new Edition

    cmpCreate: function(node) {

        var win = this.components["add-window"];

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
                    {
                        xtype: "titlefield",
                        value: _("Basic parameters")
                    },
                    _FLD_HDN_PATH,
                    _FLD_TITLE,
                    _FLD_SHORTCUT,
                    _FLD_DESCRIPTION,
                    {
                        xtype: "titlefield",
                        value: _("More options")
                    },
                    {
                        xtype: "combo",
                        mode: "local",
                        hiddenName: "default.file.format.text",
                        fieldLabel: _("Text format"),
                        emptyText: _("Select a file extension"),
                        editable:false,
                        typeAhead: true,
                        allowBlank:true,
                        valueField: "id",
                        displayField:"text",
                        selectOnFocus:true,
                        triggerAction: "all",
                        forceSelection: true,
                        store: {
                            xtype: "arraystore",
                            fields: ["id", "text"],
                            data : [
                                ["none", _("Without conversion")],
                                ["doc",  _("Microsoft Word (doc)")],
                                ["odt",  _("OpenOffice.org (odt)")],
                                ["rtf",  _("Rich Text Format (rtf)")],
                                ["txt",  _("Simple Text (txt)")]
                            ]
                        }
                    },
                    {
                        xtype: "combo",
                        mode: "local",
                        hiddenName: "default.file.format.table",
                        fieldLabel: _("Table format"),
                        emptyText: _("Select a file extension"),
                        editable:false,
                        typeAhead: true,
                        allowBlank:true,
                        valueField: "id",
                        displayField:"text",
                        selectOnFocus:true,
                        triggerAction: "all",
                        forceSelection: true,
                        store: {
                            xtype: "arraystore",
                            fields: ["id", "text"],
                            data : [
                                ["none", _("Without conversion")],
                                ["doc",  _("Microsoft Excel (xls)")],
                                ["ods",  _("OpenOffice.org (ods)")],
                                ["txt",  _("Tabular text (txt)")]
                            ]
                        }
                    },
                    {
                        xtype: "checkbox",
                        fieldLabel: "",
                        boxLabel: _("Apply to enclosed"),
                        name: "applymode"
                    }
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_ADD,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Adding a new edition"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:350,
                items: form
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit") {
                    win.hide();
                    node.reload();
                }
            }, this);

        }

        var form = win.items.first().getForm();
        form.reset();

        form.findField("path").setValue(node.id);

        win.show(this);
        this.components["add-window"] = win;
    },

    cmpUpdate: function(node) {

        var win = this.components["edit-window"];

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
                    _FLD_HDN_PATH,
                    {
                        xtype: "titlefield",
                        value: _("Basic parameters")
                    },
                    _FLD_TITLE,
                    _FLD_SHORTCUT,
                    _FLD_DESCRIPTION,
                    {
                        xtype: "titlefield",
                        value: _("Parent")
                    },
                    Inprint.factory.Combo.create("/catalog/combos/editions/", {
                        scope:this,
                        listeners: {
                            select: function(combo, record, indx) {
                                combo.ownerCt.getForm().findField("path").setValue(record.get("id"));
                            }
                        }
                    }),
                    {
                        xtype: "titlefield",
                        value: _("More options")
                    },
                    {
                        xtype: "combo",
                        mode: "local",
                        hiddenName: "default.file.format.text",
                        fieldLabel: _("Text format"),
                        emptyText: _("Select a file extension"),
                        editable:false,
                        typeAhead: true,
                        allowBlank:true,
                        valueField: "id",
                        displayField:"text",
                        selectOnFocus:true,
                        triggerAction: "all",
                        forceSelection: true,
                        store: {
                            xtype: "arraystore",
                            fields: ["id", "text"],
                            data : [
                                ["none", _("Without conversion")],
                                ["doc",  _("Microsoft Word (doc)")],
                                ["odt",  _("OpenOffice.org (odt)")],
                                ["rtf",  _("Rich Text Format (rtf)")],
                                ["txt",  _("Simple Text (txt)")]
                            ]
                        }
                    },
                    {
                        xtype: "combo",
                        mode: "local",
                        hiddenName: "default.file.format.table",
                        fieldLabel: _("Table format"),
                        emptyText: _("Select a file extension"),
                        editable:false,
                        typeAhead: true,
                        allowBlank:true,
                        valueField: "id",
                        displayField:"text",
                        selectOnFocus:true,
                        triggerAction: "all",
                        forceSelection: true,
                        store: {
                            xtype: "arraystore",
                            fields: ["id", "text"],
                            data : [
                                ["none", _("Without conversion")],
                                ["doc",  _("Microsoft Excel (xls)")],
                                ["ods",  _("OpenOffice.org (ods)")],
                                ["txt",  _("Tabular text (txt)")]
                            ]
                        }
                    },
                    {
                        xtype: "checkbox",
                        fieldLabel: "",
                        boxLabel: _("Apply to enclosed"),
                        name: "applymode"
                    }
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_SAVE,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Catalog item creation"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:400,
                items: form
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit") {
                    win.hide();
                    if (node.parentNode) {
                        node.parentNode.reload();
                    } else {
                        node.reload();
                    }
                }
            }, this);
        }

        win.show(this);
        win.body.mask(_("Loading..."));
        this.components["edit-window"] = win;

        var form = win.items.first().getForm();
        form.reset();

        form.load({
            url: this.urls.read,
            scope:this,
            params: {
                id: node.id
            },
            success: function(form, action) {

                win.body.unmask();

                form.findField("id").setValue(action.result.data.id);
                form.findField("path").setValue(action.result.data.parent);
                form.findField("edition").setValue(action.result.data.parent_shortcut);

                if (action.result.data.id == '00000000-0000-0000-0000-000000000000') {
                    form.findField("edition").disable();
                } else {
                    form.findField("edition").enable();
                }

            },
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });
    },

    cmpDelete: function(node) {

        var title = _("Group removal") +" <"+ node.attributes.shortcut +">";

        Ext.MessageBox.confirm(
            title,
            _("You really wish to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls["delete"],
                        scope:this,
                        success: function() {
                            node.parentNode.reload();
                        },
                        params: { id: node.attributes.id }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }

});
