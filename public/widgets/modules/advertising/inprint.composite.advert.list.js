///*
// * Inprint Content 4.0
// * Copyright(c) 2001-2009, Softing, LLC.
// * licensing@softing.ru
// *
// * http://softing.ru/license
// */
//
//Inprint.Composite2.Advert.List = function(parent, access)
//{
//    return {
//
//        init: function( node )
//        {
//
//            this.fascicle = node.oid   || node.id;
//            this.fastitle = node.title || node.text;
//
//            this.dialog = {};
//
//            this.url = {
//                add:    '/advert/advertiser/add/',
//                load:   '/advert/advertiser/list/'
//            };
//
//            this.store = new Ext.data.Store({
//                baseParams: {
//                    edition: Inprint.session.edition,
//                    fascicle: this.fascicle
//                },
//                autoLoad:true,
//                proxy: new Ext.data.HttpProxy({
//                    url: this.url.load
//                }),
//                reader: new Ext.data.JsonReader({
//                    id: 'uuid',
//                    fields: [ 'uuid', 'title', 'stitle' ]
//                })
//            });
//
//            this.grid = new Ext.grid.GridPanel({
//                loadMask: true,
//                stripeRows: true,
//                hideHeaders:true,
//                viewConfig: {
//                    forceFit: true
//                },
//                sm: new Ext.grid.RowSelectionModel(),
//                cm: new Ext.grid.ColumnModel([
//                    {
//                        header: 'Рекламодатель',
//                        dataIndex: 'stitle'
//                    }
//                ]),
//                store: this.store,
//                tbar: [
//                    {
//                        id:'add',
//                        icon: _icon("plus-button"),
//                        cls: 'x-btn-icon',
//                        scope:this,
//                        handler : this.add
//                    },
//                    '->',
//                    new Inprint.combo.search({
//                        width:110,
//                        emptyText: 'Поиск...',
//                        store: this.store
//                    })
//                ],
//
//                listeners: {
//                    scope: this,
//                    rowclick: function(grid,rowIndex,colIndex,e)
//                    {
//                        var record = grid.getStore().getAt(rowIndex).data;
//
//                        var panel = parent.panels.form.object;
//                        var form  = panel.getForm();
//
//                        form.url = '/advert/request/add/';
//                        delete form.baseParams.uuid;
//                        panel.buttons[0].setText('Добавить заявку' );
//
//                        form.findField('advertiser').setValue( record.uuid );
//                        form.findField('advertiser').setRawValue( record.title );
//
//                    }
//                }
//            });
//
//            this.object = this.grid;
//            return this;
//        },
//
//        add: function()
//        {
//
//            if ( !this.dialog.add )
//            {
//                this.dialog.add = new Ext.Window(
//                    parent.window('Добавить', this, {
//                        title: 'Добавление рекламодателя',
//                        items: new Ext.FormPanel(
//                            parent.form(this, {
//                                url: this.url.add,
//                                defaultType: 'textfield',
//                                items: [
//                                    {
//                                        name: 'title',
//                                        fieldLabel: 'Название',
//                                        allowBlank:false
//                                    }
//                                ]
//                            })
//                        )
//                    })
//                );
//            }
//
//            this.dialog.add.show();
//            this.dialog.current = this.dialog.add;
//            var form = this.dialog.current.items.itemAt(0).getForm();
//            form.baseParams.fascicle = this.fascicle;
//            form.baseParams.edition = Inprint.session.edition;
//            form.reset();
//        },
//
//        refresh: function() {
//            this.grid.store.reload();
//        }
//
//    };
//};