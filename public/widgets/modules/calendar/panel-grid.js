Inprint.calendar.Grid = Ext.extend(Ext.ux.tree.TreeGrid, {

    initComponent: function() {

        this.url = {
            'load':    _url('/calendar/list/'),
            'create':  _url('/calendar/create/'),
            'read':    _url('/calendar/read/'),
            'update':  _url('/calendar/update/'),
            'delete':  _url('/calendar/delete/'),
            'enable':  _url('/calendar/enable/'),
            'disable': _url('/calendar/disable/')
        };

        this.Components = new Inprint.calendar.Controls({
            scope: this,
            url: this.url
        });

        this.tbar = [
            {
                xtype: 'buttongroup',
                title: _("Issues"),
                columns: 3,
                defaults: { scale: 'small' },
                items: [
                    {
                        id: 'create',
                        text: _("Create"),
                        disabled: true,
                        icon: _ico("plus-button"),
                        cls: 'x-btn-text-icon',
                        ref: "../../btnCreate",
                        scope: this,
                        handler: function() {

                            var form = new Inprint.calendar.forms.Create({
                                parent: this,
                                url: this.url.create
                            });

                            form.getForm().findField("edition").setValue(this.currentEdition);

                            var wndw = this.cmpCreateWindow(
                                form, _("Adding issue"), [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
                            ).show();

                            form.on('actioncomplete', function(form, action) {
                                if (action.type == "submit") {
                                    wndw.close();
                                    this.cmpReload();
                                }
                            }, this);
                        }
                    },

                    {
                        id: 'update',
                        text: _("Edit"),
                        disabled: true,
                        icon: _ico("pencil"),
                        cls: 'x-btn-text-icon',
                        ref: "../../btnUpdate",
                        scope: this,
                        handler: function() {

                            var form = new Inprint.calendar.forms.Create({
                                parent: this,
                                url: this.url.create
                            });

                            form.getForm().findField("edition").setValue(this.currentEdition);

                            form.load({
                                url: this.url.read,
                                scope:this,
                                params: {
                                    id: this.cmpGetSelectedNode().id
                                },
                                failure: function(form, action) {
                                    Ext.Msg.alert("Load failed", action.result.errorMessage);
                                }
                            });

                            var wndw = this.cmpCreateWindow(
                                form, _("Adding issue"), [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
                            ).show();

                            form.on('actioncomplete', function(form, action) {
                                if (action.type == "submit") {
                                    wndw.close();
                                    this.cmpReload();
                                }
                            }, this);
                        }
                    },

                    {
                        id: 'delete',
                        text: _("Delete"),
                        disabled: true,
                        icon: _ico("minus-button"),
                        cls: 'x-btn-text-icon',
                        ref: "../../btnDelete",
                        scope: this,
                        handler: this.cmpDelete
                    }

                ]
            },
            {
                xtype: 'buttongroup',
                title: _("Management"),
                defaults: { scale: 'small' },
                items: [
                    {
                        id: 'createAttachment',
                        text: _("Create"),
                        disabled: true,
                        icon: _ico("plus-button"),
                        cls: 'x-btn-text-icon',
                        ref: "../../btnAttachmentCreate",
                        scope: this.Components,
                        handler: this.Components.create
                    }
                ]
            }
        ];

        this.columns = [
            {
                header: _("Shortcut"),
                dataIndex: 'shortcut',
                width: 140
            },
            {
                header: _("Description"),
                dataIndex: 'description',
                width: 200
            },

            {
                header: _("Circulation"),
                dataIndex: 'circulation',
                width: 80
            },

            {
                header: "",
                dataIndex: 'flagdoc',
                width: 60,
                tpl: new Ext.XTemplate('{flagdoc:this.formatFlag}', {
                    formatFlag: function(flag) {
                        var string = _("Not set");
                        switch (flag) {
                            case "bydate":
                                string = _("By date");
                                break;
                            case "enabled":
                                string = _("Enabled");
                                break;
                            case "disabled":
                                string = _("Disabled");
                                break;
                        };
                        return string;
                    }
                })
            },

            {
                header: _("Documents"),
                dataIndex: 'datedoc',
                width: 90,
                tpl: new Ext.XTemplate('{datedoc:this.formatDate}', {
                    formatDate: function(date) {
                        return _fmtDate(date, 'M j, H:i');
                    }
                })
            },

            {
                header: "",
                dataIndex: 'flagadv',
                width: 60,
                tpl: new Ext.XTemplate('{flagadv:this.formatFlag}', {
                    formatFlag: function(flag) {
                        var string = _("Not set");
                        switch (flag) {
                            case "bydate":
                                string = _("By date");
                                break;
                            case "enabled":
                                string = _("Enabled");
                                break;
                            case "disabled":
                                string = _("Disabled");
                                break;
                        };
                        return string;
                    }
                })
            },

            {
                header: _("Advertisement"),
                dataIndex: 'dateadv',
                width: 90,
                tpl: new Ext.XTemplate('{dateadv:this.formatDate}', {
                    formatDate: function(date) {
                        return _fmtDate(date, 'M j, H:i');
                    }
                })
            },
            {
                header: _("Print date"),
                dataIndex: 'dateprint',
                width: 90,
                tpl: new Ext.XTemplate('{dateprint:this.formatDate}', {
                    formatDate: function(date) {
                        return _fmtDate(date, 'M j, H:i');
                    }
                })
            },
            {
                header: _("Out date"),
                dataIndex: 'dateout',
                width: 90,
                tpl: new Ext.XTemplate('{dateout:this.formatDate}', {
                    formatDate: function(date) {
                        return _fmtDate(date, 'M j, H:i');
                    }
                })
            }

        ];

        Ext.apply(this, {
            border:false,
            dataUrl: _url('/calendar/list/')
        });

        Inprint.calendar.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.Grid.superclass.onRender.apply(this, arguments);
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

    cmpCreateWindow: function(form, title, btns) {
        return new Ext.Window({
            modal: true,
            layout: "fit",
            closeAction: "hide",
            width: 800,
            height: 420,
            title: title,
            items: form,
            buttons: btns
        });
    }

});
