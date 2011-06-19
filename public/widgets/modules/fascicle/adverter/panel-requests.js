Inprint.fascicle.adverter.Requests = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            "create": _url("/fascicle/requests/create/"),
            "read":   _url("/fascicle/requests/read/"),
            "update": _url("/fascicle/requests/update/"),
            "delete": _url("/fascicle/requests/delete/"),
            "move":   _url("/fascicle/requests/move/")
        };

        this.store = Inprint.factory.Store.json("/fascicle/requests/list/", {
            remoteSort:true,
            baseParams: {
                flt_fascicle: this.oid
            }
        });

        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        var  columns  = Inprint.grid.columns.Request();
        this.colModel = new Ext.grid.ColumnModel({
            defaults: {
                sortable: true,
                menuDisabled:true
            },
            columns: [
                this.selectionModel,
                columns.serial,
                columns.advertiser,
                columns.manager,
                columns.title,
                columns.position,
                columns.template,
                columns.module,
                columns.pages,
                columns.status,
                columns.payment,
                columns.readiness,
                columns.modified
            ]
        });

        this.tbar = [
            Inprint.getButton("create.item"),
            Inprint.getButton("update.item"),
            '-',
            Inprint.getButton("layout.item"),
            Inprint.getButton("placing.item"),
            '-',
            Inprint.getButton("delete.item")
        ];

        Ext.apply(this, {
            border: false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "title"
        });

        Inprint.fascicle.adverter.Requests.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.adverter.Requests.superclass.onRender.apply(this, arguments);
    }

/*
    cmpCreate: function() {

        var pages     = this.parent.panels.pages;
        var fascicle  = this.oid;
        var selection = pages.cmpGetSelected();

        if (selection.length > 2) {
            return;
        }

        var wndw = new Inprint.cmp.Adverta({
            mode: "create",
            fascicle: this.parent.fascicle,
            selection: selection
        });

        wndw.on("actioncomplete", function() {
            this.parent.cmpReload();
        }, this);

        wndw.show();
    },

    cmpUpdateProxy: function () {
        Ext.Ajax.request({
            url: this.urls.read,
            params: {
                fascicle: this.oid,
                request: this.getValue("id")
            },
            scope: this,
            success: function(responce) {
                var record = Ext.util.JSON.decode(responce.responseText);
                this.cmpUpdate(record);
            }
        });
    },

    cmpUpdate: function(record) {

        if (!record.data.id) {
            return;
        }

        if (record.data.pages.length > 2) {
            return;
        }

        var wndw = new Inprint.cmp.Adverta({
            mode: "update",
            record: record.data,
            fascicle: this.oid,
            selection: record.data.pages
        });

        wndw.on("actioncomplete", function() {
            this.parent.cmpReload();
        }, this);

        wndw.show();

        wndw.cmpFill(record);
    },

    cmpMove: function(inc) {

        var wndw = this.components.move;

        if (!wndw) {

            wndw = new Ext.Window({
                title: 'Перемещение заявки',
                width:250,
                height:140,
                modal:true,
                draggable:true,
                layout: "fit",
                closeAction: "hide",
                items: {
                    xtype: "form",
                    border: false,
                    url: this.urls.move,
                    labelWidth: 60,
                    defaultType: 'checkbox',
                    defaults: { anchor: '100%', hideLabel:true },
                    bodyStyle: 'padding:10px;',
                    listeners: {
                        scope:this,
                        actioncomplete: function() {
                            wndw.hide();
                            this.parent.cmpReload();
                        }
                    },
                    items: [
                        {
                            xtype: 'checkbox',
                            name: 'move-request',
                            checked:false,
                            inputValue: 'true',
                            fieldLabel: '',
                            labelSeparator: ':',
                            boxLabel: 'Переместить заявку'
                        },
                        {
                            xtype: 'checkbox',
                            name: 'move-module',
                            checked:false,
                            inputValue: 'true',
                            fieldLabel: '',
                            labelSeparator: '',
                            boxLabel: 'Переместить модуль'
                        }
                    ]
                },
                buttons: [
                    _BTN_WNDW_OK,
                    _BTN_WNDW_CANCEL
                ]
            });

            this.components.move = wndw;
        }

        var form = wndw.findByType("form")[0].getForm();
        form.reset();
        form.baseParams = {
            fascicle: this.oid,
            request: this.getValue("id"),
            page: this.parent.panels.pages.cmpGetSelected()
        };
        wndw.show();
    },

    cmpDelete: function() {

        var wndw = this.components["delete"];

        if (!wndw) {

            wndw = new Ext.Window({
                title: 'Удаление заявки',
                width:250,
                height:140,
                modal:true,
                draggable:true,
                layout: "fit",
                closeAction: "hide",
                items: {
                    xtype: "form",
                    border: false,
                    url: this.urls["delete"],
                    labelWidth: 60,
                    defaultType: 'checkbox',
                    defaults: { anchor: '100%', hideLabel:true },
                    bodyStyle: 'padding:10px;',
                    listeners: {
                        scope:this,
                        actioncomplete: function() {
                            wndw.hide();
                            this.parent.cmpReload();
                        }
                    },
                    items: [
                        {
                            xtype: 'checkbox',
                            name: 'delete-request',
                            checked:false,
                            inputValue: 'true',
                            fieldLabel: '',
                            labelSeparator: ':',
                            boxLabel: 'Удалить заявку'
                        },
                        {
                            xtype: 'checkbox',
                            name: 'delete-module',
                            checked:false,
                            inputValue: 'true',
                            fieldLabel: '',
                            labelSeparator: '',
                            boxLabel: 'Удалить модуль'
                        }
                    ]
                },
                buttons: [
                    _BTN_WNDW_OK,
                    _BTN_WNDW_CANCEL
                ]
            });

            this.components["delete"] = wndw;
        }

        var form = wndw.findByType("form")[0].getForm();
        form.reset();
        form.baseParams = {
            fascicle: this.oid,
            request:  this.getValues("id")
        };
        wndw.show();
    }
*/

});
