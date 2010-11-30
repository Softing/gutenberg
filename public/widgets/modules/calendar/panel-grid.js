Inprint.edition.calendar.Grid = Ext.extend(Ext.grid.GridPanel, {

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

        this.sm = new Ext.grid.CheckboxSelectionModel();
        
        this.store = Inprint.factory.Store.json("/calendar/list/");

        this.cm = new Ext.grid.ColumnModel([
            this.sm,
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
                    var url = "/?aid=fascicle-plan&oid="+id+"&text="+title;
                    var jscript = "Inprint.ObjectResolver.resolve({aid:'fascicle-plan', oid: '"+id+"', text: '"+title+"' });";
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
            },
            {
                id: 'enable',
                text: _("Enable"),
                disabled: true,
                icon: _ico("switch--plus"),
                cls: 'x-btn-text-icon',
                ref: "../btnEnable",
                scope: this,
                handler: this.cmpEnable
            },
            {
                id: 'disable',
                text: _("Disable"),
                disabled: true,
                icon: _ico("switch--minus"),
                cls: 'x-btn-text-icon',
                ref: "../btnDisable",
                scope: this,
                handler: this.cmpDisable
            }
        ];

        Ext.apply(this, {
            border: false,
            loadMask: true,
            stripeRows: true,
            stateful: false
        });

        Inprint.edition.calendar.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.edition.calendar.Grid.superclass.onRender.apply(this, arguments);
        
        this.on("rowcontextmenu", function(thisGrid, rowIndex, evtObj) {
            
            thisGrid.selModel.selectRow(rowIndex);
            evtObj.stopEvent();
            
            var rowCtxMenuItems = [];
            
            var record = thisGrid.getStore().getAt(rowIndex);
            
            rowCtxMenuItems.push({
                text    : _('View plan'),
                handler : function() {
                    Inprint.ObjectResolver.resolve({ aid:'fascicle-plan', oid: record.get("id"), text: record.get("shortcut") });
                }
            });
            
            rowCtxMenuItems.push({
                text    : _('View composer'),
                handler : function() {
                    //Inprint.ObjectResolver.resolve({aid:'fascile-plan', oid: 'a2c28625-fdd5-448f-a324-0b38bdaf7bac', text: '01-2011' });
                }
            });
            
            if (! thisGrid.rowCtxMenu) {
                thisGrid.rowCtxMenu = new Ext.menu.Menu({
                    items : rowCtxMenuItems
                });
            }
     
            thisGrid.rowCtxMenu.showAt(evtObj.getXY());
        });
        
    },

    cmpCreate: function() {

        var win = this.components["create-window"];
        if (!win) {

            win = new Ext.Window({
                title: _("Release addition"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:250,
                items: new Ext.FormPanel({
                    
                    url: this.url["create"],

                    border:false,

                    labelWidth: 120,
                    defaults: {
                        anchor: "100%"
                    },
                    bodyStyle: "padding:10px",

                    items: [
                        _FLD_HDN_EDITION,
                        _FLD_TITLE,
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
                        Inprint.factory.Combo.create(
                            "/catalog/combos/fascicles/",
                            {
                                width: 150,
                                fieldLabel: _("Copy from"),
                                hiddenName: 'copyfrom'
                            }, {
                                baseParams: {
                                    term: "editions.calendar.view"
                                }
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
        form.findField("edition").setValue(this.currentEdition);

        win.show(this);
        this.components["create-window"] = win;
    },

    cmpUpdate: function() {
        var win = this.components["update-window"];
        if (!win) {

            win = new Ext.Window({
                title: _("Release change"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:200,
                items: new Ext.FormPanel({
                    
                    url: this.url["update"],

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
        this.components["update-window"] = win;

    },

    cmpEnable: function(btn) {
        Ext.Ajax.request({
            url: this.url["enable"],
            params: {
                ids: this.getValues("id")
            },
            scope: this,
            success: this.cmpReload,
            failure: this.failure
        });
    },

    cmpDisable: function(btn) {
        Ext.Ajax.request({
            url: this.url["disable"],
            params: {
                ids: this.getValues("id")
            },
            scope: this,
            success: this.cmpReload,
            failure: this.failure
        });
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
                    id: this.getValues("id")
                },
                scope: this,
                success: this.cmpReload,
                failure: this.failure
            });
        }
    }

});
