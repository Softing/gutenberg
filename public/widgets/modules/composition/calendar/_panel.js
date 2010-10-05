Inprint.edition.calendar.Panel = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};

        this.access = {
            edit:true
        };

        this.url = {
            'load':   '/calendar/list/',
            'create': '/calendar/create/',
            'read':   '/calendar/read/',
            'update': '/calendar/update/',
            'delete': '/calendar/delete/'
        };

        var sm = new Ext.grid.CheckboxSelectionModel();
        var store = Inprint.factory.Store.json("/calendar/list/", {
            autoLoad:true
        });

        var cm = new Ext.grid.ColumnModel([
            sm,
            {
                dataIndex: 'enabled',
                width: 24,
                renderer: function(v,p,r) {
                    if (v == 1) {
                        return '<img src="'+ _ico("rocket-fly") +'"/>';
                    }
                    return '<img src="'+ _ico("book") +'"/>';
                }
            },
            {
                header: _("Edition"),
                dataIndex: 'edition_shortcut',
                width: 60
            },
            {
                header: _("Title"),
                dataIndex: 'title',
                width: 240,
                renderer: function(v,p,r) {
                    var id    = r.data.id;
                    var title = r.data.title;
                    var url = "/?part=composite2&page=plan&oid="+id+"&text="+title;
                    var jscript = "Inprint.objResolver('composite2', 'plan', {oid: '"+id+"', text: '"+title+"' });";
                    return '<a href="'+ url +'" onclick="'+jscript+';return false;">' + v + '</a>';
                }
            },
            {
                header: _("Opening date"),
                dataIndex: 'begindate',
                width: 140
            },
            {
                header: _("Closing date"),
                dataIndex: 'enddate',
                width: 140
            },

            {
                header: _("Readiness"),
                dataIndex: 'progress',
                width: 200,
                renderer: function(v, p, record){

                    var totaldays  = record.data.totaldays;
                    var passeddays = record.data.passeddays;

                    var progress = Math.round((totaldays/100)*passeddays);

                    if (progress > 100) progress = 100;

                    p.css += ' x-grid3-progresscol';

                    var bg1 = 'red';
                    var bg2 = 'green';

                    if (record.data.enabled === 0){
                        bg2 = 'silver';
                    }

                    return String.format(
                        '<div class="x-progress-wrap">'+
                            '<div class="x-progress-inner">'+
                                '<div style="width:{0}%;height:9px;background:{2} !important;"></div>'+
                                '<div style="width:{1}%;height:9px;background:{3} !important;"></div>'+
                            '</div>'+
                        '</div>',
                        0, progress, bg1, bg2);
                }
            }

        ]);

        var tbar = [
            {
                id: 'add',
                text: _("Add"),
                disabled: true,
                icon: _ico("plus-button"),
                cls: 'x-btn-text-icon',
                scope: this,
                handler: this.cmpAdd
            },
            {
                id: 'edit',
                text: _("Edit"),
                disabled: true,
                icon: _ico("pencil"),
                cls: 'x-btn-text-icon',
                scope: this,
                handler: this.cmpEdit
            },
            {
                id: 'delete',
                text: _("Delete"),
                disabled: true,
                icon: _ico("minus-button"),
                cls: 'x-btn-text-icon',
                scope: this,
                handler: this.cmpRemove
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
            },
            {
                id: 'enable',
                text: _("Enable"),
                disabled: true,
                icon: _ico("switch--plus"),
                cls: 'x-btn-text-icon'
            },
            {
                id: 'disable',
                text: _("Disable"),
                disabled: true,
                icon: _ico("switch--minus"),
                cls: 'x-btn-text-icon'
            },
            '-',
            Inprint.factory.Combo.create("/catalog/combos/editions/", {
                width: 150,
                disableCaching: true,
                listeners: {
                    scope:this,
                    select: function(combo, record) {
                        this.cmpLoad({
                            edition: record.data.id
                        });
                    }
                }
            }),
        ];

        Ext.apply(this, {
            loadMask: true,
            stripeRows: true,
            stateful: false,
            sm: sm,
            store: store,
            cm: cm,
            tbar: tbar
        });

        Inprint.edition.calendar.Panel.superclass.initComponent.apply(this, arguments);

        this.on("rowclick", function(grid, rowIndex, e) {
            if (this.getSelectionModel().getCount() == 0) {
               this.topToolbar.items.get('edit').disable();
               this.topToolbar.items.get('delete').disable();
            }

            if (this.getSelectionModel().getCount() == 1 && this.access.edit) {
              this.topToolbar.items.get('edit').enable();
              this.topToolbar.items.get('delete').enable();
            }

            if (this.getSelectionModel().getCount() > 1 && this.access.edit) {
              this.topToolbar.items.get('edit').disable();
              this.topToolbar.items.get('delete').enable();
            }
        }, this);

    },

    onRender: function() {

        Inprint.edition.calendar.Panel.superclass.onRender.apply(this, arguments);

        if (this.access.edit) {
            this.getTopToolbar().items.get('add').enable();
        }

    },

    cmpAdd: function() {

        var win = this.components["add-window"];
        if (!win) {

            win = new Ext.Window({
                title: _("Release addition"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:250,
                items: new Ext.FormPanel({
                    url: this.url.create,

                    frame:false,
                    border:false,

                    labelWidth: 120,
                    defaults: {
                        anchor: "100%"
                    },
                    bodyStyle: "padding:10px",

                    items: [
                        _FLD_NAME,
                        {
                            xtype: 'xdatefield',
                            name: 'begindate',
                            format:'F j, Y',
                            submitFormat:'Y-m-d',
                            allowBlank:false,
                            fieldLabel: _("Opening date"),
                            listeners: {
                                scope:this
                            }
                        },
                        {
                            xtype: 'xdatefield',
                            name: 'enddate',
                            format:'F j, Y',
                            submitFormat:'Y-m-d',
                            allowBlank:false,
                            fieldLabel: _("Closing date"),
                            listeners: {
                                scope:this,
                                change: function(field, value, old)
                                {
                                    var v = field.getValue();
                                    var f = field.ownerCt.getForm().findField('title');
                                    if (f.getValue().length === 0) {
                                        f.setValue(v.dateFormat('F j, Y'));
                                    }
                                }
                            }
                        },

                        Inprint.factory.Combo.create("/catalog/combos/editions/", {
                            width: 150,
                            disableCaching: true
                        }),

                        Inprint.factory.Combo.create("/catalog/combos/fascicles/", {
                            width: 150,
                            disableCaching: true,
                            fieldLabel: _("Copy from"),
                            hiddenName: 'copyfrom'
                        })
                    ],

                    buttons: [ _BTN_ADD, _BTN_CANCEL ],

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
                title: _("Release change"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:200,
                items: new Ext.FormPanel({
                    url: this.url.create,

                    frame:false,
                    border:false,

                    labelWidth: 120,
                    defaults: {
                        anchor: "100%"
                    },
                    bodyStyle: "padding:10px",

                    items: [
                        _FLD_HDN_ID,
                        _FLD_NAME,
                        {
                            xtype: 'xdatefield',
                            name: 'begindate',
                            format:'F j, Y',
                            submitFormat:'Y-m-d',
                            allowBlank:false,
                            fieldLabel: _("Opening date"),
                            listeners: {
                                scope:this
                            }
                        },
                        {
                            xtype: 'xdatefield',
                            name: 'enddate',
                            format:'F j, Y',
                            submitFormat:'Y-m-d',
                            allowBlank:false,
                            fieldLabel: _("Closing date")
                        }
                    ],

                    buttons: [ _BTN_SAVE, _BTN_CANCEL ],

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

        var record = this.getSelectionModel().getSelected();

        form.findField('id').setValue(record.data.id);
        form.findField('name').setValue(record.data.title);
        form.findField('begindate').setValue( _fmtDate( record.data.begindate, 'F j, Y' ) );
        form.findField('enddate').setValue( _fmtDate( record.data.enddate, 'F j, Y' ) );

        win.show(this);
        this.components["edit-window"] = win;

    },

    cmpEnable: function(btn) {

            var data = this.getValues();

            Ext.Ajax.request({
                url: this.url.remove,
                params: {
                    ids: data
                },
                scope: this,
                success: this.cmpReload,
                failure: this.failure
            });

    },

    cmpDisable: function(btn) {

        var data = this.getValues();

        Ext.Ajax.request({
            url: this.url.remove,
            params: {
                ids: data
            },
            scope: this,
            success: this.cmpReload,
            failure: this.failure
        });
    },

    cmpRemove: function(btn) {

        if (btn != 'yes' && btn != 'no') {
            Ext.MessageBox.confirm(
                _("Warning"),
                _("You really want to do it?"),
                this.cmpRemove, this);
            return;
        }

        if (btn == 'yes') {

            var data = this.getValues();

            Ext.Ajax.request({
                url: this.url.remove,
                params: {
                    id: data
                },
                scope: this,
                success: this.cmpReload,
                failure: this.failure
            });
        }
    }

});
