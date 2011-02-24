Inprint.calendar.Controls = function (params) {

    var urls  = params.url;
    var cache = {};

    return {

        /* Basic Methods */

        "create": function() {

            var wndw = cache["create-window"];

            if (!wndw) {
                var form = this.hlpCreateForm("create", "fascicle", urls.create);
                wndw = this.hlpCreateWindow(_("Release addition"), [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ], form);
                cache["create-window"] = wndw;
            }

            var form = wndw.findByType("form")[0].getForm();
            form.reset();
            //form.findField("edition").setValue(this.currentEdition);

            wndw.show(this);
        },

        "update": function() {

            var wndw = cache["update-window"];

            if (!wndw) {
                var form = this.hlpCreateForm("update", "fascicle", urls.update);
                wndw = this.hlpCreateWindow(_("Release addition"), [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ], form);
                cache["update-window"] = wndw;
            }

            var form = wndw.findByType("form")[0].getForm();
            form.reset();

            form.load({
                url: urls.read,
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

        "delete": function(btn) {
            if (btn != 'yes' && btn != 'no') {
                Ext.MessageBox.confirm(
                    _("Warning"),
                    _("You really want to do it?"),
                    this.cmpDelete, this);
                return;
            }
            if (btn == 'yes') {
                Ext.Ajax.request({
                    url: urls["delete"],
                    params: {
                        id: this.cmpGetSelectedNode().id
                    },
                    scope: this,
                    success: this.cmpReload,
                    failure: this.failure
                });
            }
        },

        /* Additional Methods */

        "createAttachment": function(node) {

            var wndw = cache["create-attachment-window"];

            if (!wndw) {
                var form = this.hlpCreateForm("create", "attachment", urls.create);
                wndw = this.hlpCreateWindow(_("Release addition"), [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ], form);
                cache["create-attachment-window"] = wndw;
            }

            var form = wndw.findByType("form")[0].getForm();
            form.reset();

            form.findField("parent").setValue(node.id);
            form.findField("edition").getStore().baseParams = {
                parent: node.attributes.edition
            };

            wndw.show(this);
        },

        /* Helpers */

        "hlpCreateForm": function(mode, type, url) {

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
            };
        },

        "hlpCreateWindow": function(title, btns, form) {
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
    };

};
