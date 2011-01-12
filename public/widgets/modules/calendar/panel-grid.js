Inprint.edition.calendar.Grid = Ext.extend(Ext.ux.tree.TreeGrid, {

    initComponent: function() {

        this.components = {};

        this.url = {
            'load':    _url('/calendar/list/'),
            'create':  _url('/calendar/create/'),
            'read':    _url('/calendar/read/'),
            'update':  _url('/calendar/update/'),
            'delete':  _url('/calendar/delete/'),
            'enable':  _url('/calendar/enable/'),
            'disable': _url('/calendar/disable/')
        };

        //this.sm = new Ext.grid.CheckboxSelectionModel();

        Ext.apply(this, {

            columns: [
                {
                    header: _("Shortcut"),
                    dataIndex: 'shortcut',
                    width: 240
                },
                {
                    header: _("Title"),
                    dataIndex: 'title',
                    width: 240
                },
                {
                    header: _("Description"),
                    dataIndex: 'description',
                    width: 240
                }

            ],

            dataUrl: _url('/calendar/list/')

        });

        this.tbar = [
            {
                id: 'create',
                text: _("Create"),
                disabled: true,
                icon: _ico("plus-button"),
                cls: 'x-btn-text-icon',
                ref: "../btnCreate",
                scope: this,
                handler: this.cmpCreate
            },
            {
                id: 'update',
                text: _("Update"),
                disabled: true,
                icon: _ico("pencil"),
                cls: 'x-btn-text-icon',
                ref: "../btnUpdate",
                scope: this,
                handler: this.cmpUpdate
            },
            {
                id: 'delete',
                text: _("Delete"),
                disabled: true,
                icon: _ico("minus-button"),
                cls: 'x-btn-text-icon',
                ref: "../btnDelete",
                scope: this,
                handler: this.cmpDelete
            },
            '-',
            {
                id: 'archvie',
                text: _("Show archvies"),
                icon: _ico("folder-zipper"),
                cls: 'x-btn-text-icon',
                enableToggle: true,
                pressed: false,
                scope: this,
                toggleHandler: function(btn, pressed) {
                    this.cmpLoad({
                        showArchive:pressed
                    });
                }
            }
        ];

        Inprint.edition.calendar.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.edition.calendar.Grid.superclass.onRender.apply(this, arguments);

        this.on("contextmenu", function(node) {

            var items = [];

            node.select();

            var edition = node.attributes.edition;
            var parent  = node.attributes.parent;

            if (edition == parent) {
                items.push({
                    icon: _ico("blueprint--plus"),
                    cls: 'x-btn-text-icon',
                    text    : _('Create attachment'),
                    scope:this,
                    handler : function() {
                        this.cmpCreateAttachment(node);
                    }
                });
            }

            if (edition != parent) {
                items.push({
                    icon: _ico("blueprint--pencil"),
                    cls: 'x-btn-text-icon',
                    text    : _('Edit attachment'),
                    scope:this,
                    handler : this.cmpUpdate
                });
                items.push({
                    icon: _ico("blueprint--minus"),
                    cls: 'x-btn-text-icon',
                    text    : _('Delete attachment'),
                    scope:this,
                    handler: this.cmpDelete
                });
            }

            items.push("-");

            items.push({
                icon: _ico("table"),
                cls: 'x-btn-text-icon',
                text    : _('View plan'),
                handler : function() {
                    Inprint.ObjectResolver.resolve({ aid:'fascicle-plan', oid: node.id, text: node.text });
                }
            });

            items.push({
                icon: _ico("clock"),
                cls: 'x-btn-text-icon',
                text    : _('View composer'),
                handler : function() {
                    Inprint.ObjectResolver.resolve({ aid:'fascicle-planner', oid: node.id, text: node.text });
                }
            });

            items.push('-', {
                icon: _ico("arrow-circle-double"),
                cls: "x-btn-text-icon",
                text: _("Reload"),
                scope: this,
                handler: this.cmpReload
            });

            new Ext.menu.Menu({ items : items }).show(node.ui.getAnchor());
        }, this);

    },

    cmpGetSelectedNode: function() {
        return this.getSelectionModel().getSelectedNode();
    },

    cmpLoad: function(params) {
        Ext.apply(this.getLoader().baseParams, params);
        this.getRootNode().reload();
    },

    cmpReload: function() {
        this.getRootNode().reload();
    },

    cmpCreate: function() {

        var wndw = this.components["create-window"];

        if (!wndw) {
            var form = this.cmpCreateForm("create", "fascicle", this.url["create"]);
            wndw = this.cmpCreateWindow(_("Release addition"), [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ], form);
            this.components["create-window"] = wndw;
        }

        var form = wndw.findByType("form")[0].getForm();
        form.reset();
        form.findField("edition").setValue(this.currentEdition);

        wndw.show(this);
    },

    cmpUpdate: function() {

        var wndw = this.components["update-window"];

        if (!wndw) {
            var form = this.cmpCreateForm("update", "fascicle", this.url["update"]);
            wndw = this.cmpCreateWindow(_("Release addition"), [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ], form);
            this.components["update-window"] = wndw;
        }

        var form = wndw.findByType("form")[0].getForm();
        form.reset();

        form.load({
            url: this.url["read"],
            scope:this,
            params: {
                id: this.cmpGetSelectedNode().id
            },
            success: function (form, action) {
                var record = action.result.data;
                form.findField('id').setValue(record.id);
                form.findField('title').setValue(record.title);
                form.findField('shortcut').setValue(record.shortcut);
                form.findField('description').setValue(record.description);
                form.findField('enabled').setValue(record.enabled);
                form.findField('deadline').setValue( _fmtDate( record.deadline, 'F j, Y' ) );
                form.findField('advertisement').setValue( _fmtDate( record.advert_deadline, 'F j, Y' ) );
            },
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });

        wndw.show(this);

    },

    cmpCreateAttachment: function(node) {

        var wndw = this.components["create-attachment-window"];

        if (!wndw) {
            var form = this.cmpCreateForm("create", "attachment", this.url["create"]);
            wndw = this.cmpCreateWindow(_("Release addition"), [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ], form);
            this.components["create-attachment-window"] = wndw;
        }

        var form = wndw.findByType("form")[0].getForm();
        form.reset();

        form.findField("parent").setValue(node.id);
        form.findField("edition").getStore().baseParams = {
            parent: node.attributes.edition
        };

        wndw.show(this);
    },

    cmpDelete: function(btn) {
        if (btn != 'yes' && btn != 'no') {
            Ext.MessageBox.confirm(
                _("Warning"),
                _("You really want to do it?"),
                this.cmpDelete, this);
            return;
        }
        if (btn == 'yes') {
            Ext.Ajax.request({
                url: this.url["delete"],
                params: {
                    id: this.cmpGetSelectedNode().id
                },
                scope: this,
                success: this.cmpReload,
                failure: this.failure
            });
        }
    },

    cmpCreateForm: function(mode, type, url) {

        var items = [];

        if (mode == "create" && type == "fascicle") {
            items.push(_FLD_HDN_EDITION);
        }

        if (mode == "update") {
            items.push(_FLD_HDN_ID);
        }

        if (type == "attachment") {
            items.push(_FLD_HDN_PARENT);
        }

        items.push(
            {
                xtype: "titlefield",
                value: _("Basic parameters")
            }
        );

        if (type == "attachment") {
            items.push(
                Inprint.factory.Combo.create(
                    "/calendar/combos/editions/",
                    {
                        name: "copyfrom",
                        listeners: {
                            beforequery: function(qe) {
                                delete qe.combo.lastQuery;
                            }
                        }
                    })
            );
        }

        items.push(

            _FLD_SHORTCUT,
            _FLD_TITLE,
            _FLD_DESCRIPTION,

            {
                xtype: "titlefield",
                value: _("Deadline")
            },

            {
                xtype:"checkbox",
                fieldLabel: _("State"),
                boxLabel: _("Enabled"),
                checked: true,
                name: "enabled"
            },

            {
                xtype: "xdatefield",
                name: "deadline",
                format: "F j, Y",
                submitFormat: "Y-m-d",
                allowBlank:false,
                fieldLabel: _("Issue"),
                listeners: {
                    scope:this,
                    change: function(field, value, old)
                    {
                        var v = field.getValue();

                        var f1 = field.ownerCt.getForm().findField('title');
                        if (f1.getValue().length === 0) {
                            f1.setValue(v.dateFormat('j-M-y'));
                        }

                        var f2 = field.ownerCt.getForm().findField('shortcut');
                        if (f2.getValue().length === 0) {
                            f2.setValue(v.dateFormat('j-M-y'));
                        }
                    }
                }
            },
            {
                xtype: 'xdatefield',
                name: 'advertisement',
                format:'F j, Y',
                submitFormat:'Y-m-d',
                allowBlank:false,
                fieldLabel: _("Advertisement")
            }
        );

        if (mode == "create") {
            items.push(
                {
                    xtype: "titlefield",
                    value: _("Copy parameters")
                },

                Inprint.factory.Combo.create(
                    "/calendar/combos/sources/",
                    {
                        name: "copyfrom",
                        listeners: {
                            render: function(combo) {
                                combo.setValue("00000000-0000-0000-0000-000000000000", _("Defaults"));
                            },
                            beforequery: function(qe) {
                                delete qe.combo.lastQuery;
                            }
                        }
                    })
            );
        }

        return {
            xtype: "form",
            border:false,
            labelWidth: 100,
            url: url,
            bodyStyle: "padding:5px",

            defaults: {
                anchor: "100%"
            },

            items: items,

            listeners: {
                scope:this,
                "actioncomplete": function(form, action) {
                    if (action.type == "submit") {
                        form.window.hide();
                        this.getRootNode().reload();
                    }
                }
            }
        }
    },

    cmpCreateWindow: function(title, btns, form) {
        return new Ext.Window({
            modal:true,
            layout: "fit",
            closeAction: "hide",
            width:400, height:440,
            title: title,
            items: form,
            buttons: btns,
            listeners: {
                scope:this,
                afterrender: function(panel) {
                    panel.form  = panel.findByType("form")[0];
                    panel.form.getForm().window = panel;
                }
            }
        });
    }

});
