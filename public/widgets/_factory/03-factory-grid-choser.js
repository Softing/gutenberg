/*
 * Inprint Content 4.0
 * Copyright(c) 2001-2009, Softing, LLC.
 * licensing@softing.ru
 *
 * http://softing.ru/license
 */

Inprint.factory.GridChoser = Ext.extend(Ext.grid.GridPanel, {

    storeId: null,
    params: {},
    urls: { load: null, fill: null, save: null },

    initComponent: function() {

        this.components = {};

        this.store = Inprint.factory.Store.json(this.storeId);
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "title",
            columns: [
                this.selectionModel,
                {
                    id:"title",
                    header: _("Items"),
                    sortable: false,
                    dataIndex: "title"
                }
            ],
            tbar: [
                {
                    icon: _ico("plus-circle.png"),
                    cls: "x-btn-text-icon",
                    text: _("Save"),
                    disabled:true,
                    ref: "../btnSave",
                    scope:this,
                    handler: this.cmpSave
                }
            ]
        });

        Inprint.factory.GridChoser.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.factory.GridChoser.superclass.onRender.apply(this, arguments);
        this.store.load();
    },

    cmpFill: function() {

        this.getSelectionModel().clearSelections();
        Ext.Ajax.request({
            url: this.urls.fill,
            scope: this,
            params: this.params,
            success: function(response) {

                var data = Ext.util.JSON.decode(response.responseText);

                var ds = this.getStore();
                var sm = this.getSelectionModel();

                var cache = {};
                for (var i = 0; i < data.length; i++) {
                    cache[ data[i] ] = true;
                }

                for (i = 0; i < ds.getCount(); i++) {
                    var record = ds.getAt(i);
                    if (cache[ record.data.id ]) {
                        sm.selectRow(i, true);
                    }
                }

            }
        });
    },

    cmpSave: function() {

        var data = this.getValues("id");
        Ext.Ajax.request({
            scope:this,
            url: this.urls.save,
            params: Ext.apply(this.params, {data:data}),
            success: function(response, options) {
                alert("success");
            }
        });
    }
});

//function(parent) {
//
//    var win = false;
//    var grid = false;
//
//    var msg1 = 'Загружаются данные...';
//    var msg2 = 'Операция не удалась';
//    var msg3 = 'Статус';
//    var msgSave = 'Данные успешно сохранены';
//
//    var id1, id2;
//
//    return {
//
//        show: function(config) {
//
//            this.config = config;
//            edition = Inprint.session.edition;
//
//            if (!win) {
//
//                this.toolbar = false;
//
//                win = new Ext.Window({
//                    width: 500,
//                    height: 400,
//                    tbar: this.toolbar,
//                    items: this.createGrid(),
//                    layout: 'fit',
//                    closeAction:'close',
//                    buttons: [
//                        {
//                            text: Inprint.str.save,
//                            scope: this,
//                            handler: this.submit
//                        },
//                        {
//                            text: Inprint.str.cancel,
//                            scope: this,
//                            handler: function() {
//                                win.hide()
//                            }
//                        }
//                    ],
//                    keys: [
//                        {
//                            key: 27,
//                            scope: this,
//                            fn: function() {
//                                win.hide()
//                            }
//                        }
//                    ]
//                });
//            }
//
//            win.show();
//
//            if (config.name)
//            {
//                win.setTitle('<' + config.name + '>');
//            }
//
//            if (config.fillUrl) {
//                this.fill();
//            }
//
//            if (Ext.getCmp(id1))
//            {
//                Inprint.SetComboValue(Ext.getCmp(id1), edition || Inprint.session.edition);
//            }
//
//        },
//
//        createGrid: function()
//        {
//
//            var sm = new Ext.grid.CheckboxSelectionModel({
//                singleSelect: false
//            });
//
//            var RadioBox = new Ext.grid.RadioColumn({
//                header: 'Основная',
//                stype:'row',
//                inputValue: 1,
//                dataIndex: 'ismain',
//                width: 75,
//                align: 'center',
//                sortable: true
//            });
//
//            grid = new Ext.grid.GridPanel({
//                store: new Ext.data.Store({
//                    baseParams: { edition: Inprint.session.edition }
//                    ,proxy: new Ext.data.HttpProxy({ url: this.config.loadUrl })
//                    ,reader: new Ext.data.JsonReader({ id: 'uuid', fields: [ 'uuid', 'ismain', 'title', 'description' ] })
//                    ,autoLoad:true
//                    ,listeners: {
//                        scope:this,
//                        load: function()
//                        {
//                            if (this.config.fillUrl) {
//                                this.fill();
//                            }
//                        }
//                    }
//                })
//                ,sm: sm
//                ,columns: [
//                    sm,
//                    RadioBox,
//                    {
//                        header: Inprint.str.department,
//                        width: 150,
//                        sortable: false,
//                        dataIndex: 'title'
//                    },
//                    {
//                        header: Inprint.str.description,
//                        width: 200,
//                        sortable: false,
//                        dataIndex: 'description'
//                    }
//                ],
//                plugins: RadioBox,
//                autoExpandColumn:2,
//                frame:false
//            });
//
//            return grid;
//        },
//

//
//        ajaxFail: function() {
//            Ext.MessageBox.alert(this.msg3, this.msg2);
//        }
//
//    }
//}
