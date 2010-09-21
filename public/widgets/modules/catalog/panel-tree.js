Inprint.catalog.Tree = Ext.extend(Ext.tree.TreePanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            tree:    _url("/catalog/tree/"),
            combo:   _url("/catalog/combo/"),
            create:  _url("/catalog/create/"),
            remove:  _url("/catalog/remove/")
        };

        Ext.apply(this, {
            autoScroll:true,
            dataUrl: this.urls.tree,
            border:false,

            // DD
            enableDD:true,
            ddGroup:'member2catalog',

            root: {
                id:'00000000-0000-0000-0000-000000000000',
                nodeType: 'async',
                expanded: true,
                draggable: false,
                icon: _ico("newspapers"),
                text: _("Publishing House")
            }
        });

        Inprint.catalog.Tree.superclass.initComponent.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {

            if (node.attributes.icon == undefined) {
                node.attributes.icon = 'folder-open';
            }

            node.attributes.icon = _ico(node.attributes.icon);

            if (node.attributes.color) {
                node.text = "<span style=\"color:#"+ node.attributes.color +"\">" + node.attributes.text + "</span>";
            }

        });

    },

    onRender: function() {

        Inprint.catalog.Tree.superclass.onRender.apply(this, arguments);

        this.on("beforeload", function() {
            this.body.mask(_("Please wait..."));
        });

        this.on("load", function() {
            this.body.unmask();
        });

        this.getRootNode().on("expand", function(node) {
            node.select();
        });

    },

    cmpCreate: function() {

        var win = this.components["add-window"];
        if (!win) {

            win = new Ext.Window({
                title: _("Catalog item creation"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:300,
                items: new Ext.FormPanel({

                    url: this.urls.create,

                    frame:false,
                    border:false,

                    labelWidth: 75,
                    defaults: {
                        anchor: "95%",
                        allowBlank:false
                    },
                    bodyStyle: "padding:5px 5px",
                    items: [
                        {
                            xtype: "textfield",
                            name: "name",
                            fieldLabel: _("Name")
                        },
                        {
                            xtype: "textfield",
                            name: "shortcut",
                            fieldLabel: _("Shortcut")
                        },
                        {
                            xtype: "textarea",
                            name: "description",
                            allowBlank: true,
                            fieldLabel: _("Description")
                        },
                        {
                            xtype: 'combo',
                            hiddenName: "path",
                            store: new Ext.data.JsonStore({
                                autoDestroy: true,
                                url: this.urls.combo,
                                root: 'data',
                                idProperty: 'id',
                                fields: [ 'id', 'name', 'shortcut' ]
                            }),
                            listeners: {
                                select: function(combo, record, indx) {
                                    var value = record.data.shortcut.replace(/&nbsp;/gi,"");
                                    combo.setRawValue( value );
                                },
                                change: function(combo, record, indx) {
                                    var value = combo.getRawValue().replace(/&nbsp;/gi,"");
                                    combo.setRawValue( value );
                                }
                            },
                            valueField: 'id',
                            displayField:'shortcut',
                            editable:false,
                            forceSelection: true,
                            triggerAction: 'all',
                            emptyText: _("Select a path..."),
                            fieldLabel: _("Path")
                        },

                        {
                            xtype: 'checkboxgroup',
                            fieldLabel: 'Capables',
                            itemCls: 'x-check-group-alt',
                            allowBlank: true,
                            columns: 1,
                            items: [
                                {boxLabel: _("Можно хранить выпуски"), name: 'capable-store'},
                                {boxLabel: _("Можно хранить материалы"), name: 'capable-exchange'}
                            ]
                        }
                    ],
                    buttons: [
                        {
                            text: _("Create"),
                            handler: function() {
                                win.items.first().getForm().submit();
                            }
                        },
                        {
                            text: _("Cancel"),
                            handler: function() {
                                win.hide();
                            }
                        }
                    ],
                    listeners: {
                        scope:this,
                        "actioncomplete": function() {
                            win.hide();
                            this.cmpReload();
                        }
                    }
                })
            });
        }

        var form = win.items.first().getForm();
        form.reset();

        win.show(this);
        this.components["add-window"] = win;
    },

    cmpEdit: function() {

        var win = this.components["edit-window"];

        if (!win) {

            win = new Ext.Window({
                title: _("Catalog item creation"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:300,
                items: new Ext.FormPanel({

                    url: this.urls.edit,

                    frame:false,
                    border:false,

                    labelWidth: 75,
                    defaults: {
                        anchor: "95%",
                        allowBlank:false
                    },
                    bodyStyle: "padding:5px 5px",
                    items: [
                        {
                            xtype: "textfield",
                            name: "name",
                            fieldLabel: _("Name")
                        },
                        {
                            xtype: "textfield",
                            name: "shortcut",
                            fieldLabel: _("Shortcut")
                        },
                        {
                            xtype: "textarea",
                            name: "description",
                            allowBlank: true,
                            fieldLabel: _("Description")
                        },
                        {
                            xtype: 'combo',
                            hiddenName: "parent",
                            store: new Ext.data.JsonStore({
                                autoDestroy: true,
                                url: this.urls.combo,
                                root: 'data',
                                idProperty: 'id',
                                fields: [ 'id', 'name', 'shortcut' ]
                            }),
                            listeners: {
                                select: function(combo, record, indx) {
                                    var value = record.data.shortcut.replace(/&nbsp;/gi,"");
                                    combo.setRawValue( value );
                                },
                                change: function(combo, record, indx) {
                                    var value = combo.getRawValue().replace(/&nbsp;/gi,"");
                                    combo.setRawValue( value );
                                }
                            },
                            valueField: 'id',
                            displayField:'shortcut',
                            editable:false,
                            forceSelection: true,
                            triggerAction: 'all',
                            emptyText: _("Select a path..."),
                            fieldLabel: _("Path")
                        },

                        {
                            xtype: 'checkboxgroup',
                            fieldLabel: 'Capables',
                            itemCls: 'x-check-group-alt',
                            allowBlank: true,
                            columns: 1,
                            items: [
                                {boxLabel: _("Можно хранить выпуски"), name: 'capable-store'},
                                {boxLabel: _("Можно хранить материалы"), name: 'capable-exchange'}
                            ]
                        }
                    ],
                    buttons: [
                        {
                            text: _("Save"),
                            handler: function() {
                                win.items.first().getForm().submit();
                            }
                        },
                        {
                            text: _("Cancel"),
                            handler: function() {
                                win.hide();
                            }
                        }
                    ],
                    listeners: {
                        scope:this,
                        "actioncomplete": function() {
                            win.hide();
                            this.cmpReload();
                        }
                    }
                })
            });
        }

        var form = win.items.first().getForm();
        form.reset();

        if( this.selection.attributes.object );
            form.loadRecord(this.selection.attributes);

        win.show(this);
        this.components["edit-window"] = win;
    },

    cmpRemove: function() {

        Ext.MessageBox.confirm(_("Group removal"), _("You really wish to do this?"), function(btn) {
            if (btn == "yes") {
                Ext.Ajax.request({
                    url: this.urls.remove,
                    scope:this,
                    success: this.cmpReload,
                    params: { id: this.getSelectionModel().getSelectedNode().attributes.id }
                });
            }
        }, this).setIcon(Ext.MessageBox.WARNING);
    }

});
