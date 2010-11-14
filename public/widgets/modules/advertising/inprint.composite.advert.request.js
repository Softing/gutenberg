///*
// * Inprint Content 4.0
// * Copyright(c) 2001-2009, Softing, LLC.
// * licensing@softing.ru
// *
// * http://softing.ru/license
// */
//
//Inprint.Composite2.Advert.Request = function(parent, access)
//{
//    return {
//
//        init: function( node )
//        {
//
//            this.fascicle = node.oid   || node.id;
//            this.fastitle = node.title || node.text;
//
//            this.url = {
//                load:   '/advert/request/list/',
//                edit:   '/advert/request/edit/',
//                remove: '/advert/request/remove/'
//            };
//
//            var sm = new Ext.grid.CheckboxSelectionModel();
//
//            this.grid = new Ext.grid.GridPanel({
//                autoExpandColumn: 'advertiser',
//                loadMask: true,
//                stripeRows: true,
//                hideHeaders:false,
//                sm: new Ext.grid.RowSelectionModel(),
//                cm: new Ext.grid.ColumnModel([
//                    sm,
//                    {
//                        id:'seqnum',
//                        width:60,
//                        header: 'Полоса',
//                        dataIndex: 'seqnum'
//                    },
//                    {
//                        id:'advertiser',
//                        header: 'Рекламодатель',
//                        dataIndex: 'title'
//                    },
//                    {
//                        id:'place',
//                        header: 'Позиция',
//                        dataIndex: 'place_title'
//                    },
//                    {
//                        id:'size',
//                        header: 'Размер',
//                        dataIndex: 'size_title'
//                    },
//                    {
//                        id:'other',
//                        header: 'Другие признаки',
//                        dataIndex: 'other'
//                    },
//                    {
//                        id:'description',
//                        header: 'Примечание',
//                        dataIndex: 'description'
//                    }
//                ]),
//                view: new Ext.grid.GroupingView({
//                    forceFit: false,
//                    showGroupName: false
//                }),
//                store: new Ext.data.GroupingStore({
//                    autoLoad:true,
//                    groupField:'place_title',
//                    remoteGroup:true,
//                    remoteSort:true,
//                    //sortInfo:{field: 'group', direction: "ASC"},
//                    baseParams: {
//                        fascicle: this.fascicle
//                    },
//                    proxy: new Ext.data.HttpProxy({
//                        url: this.url.load
//                    }),
//                    reader: new Ext.data.JsonReader({
//                        id: 'uuid',
//                        fields: [ 'uuid', 'advertiser', 'title', 'stitle', 'page', 'seqnum', 'place', 'place_title', 'size', 'size_title', 'other', 'description' ]
//                    })
//                }),
//                tbar: [
//                    {
//                        id: 'remove',
//                        text:'Удалить',
//                        icon: _icon("minus-button"),
//                        cls: 'x-btn-text-icon',
//                        scope: this,
//                        handler: this.remove
//                    },
//                    '->',
//                    {
//                        //text: 'Печать',
//                        handler: false,
//                        icon: _icon("printer"),
//                        cls: 'x-btn-icon',
//                        scope:this,
//                        handler: function() {
//                            this.printPage({ mode:'landscape', size:'a4' });
//                        }
//                    },
//                    {
//                        id: 'refresh',
//                        cls: 'x-btn-icon',
//                        icon: _icon("arrow-circle-double-135"),
//                        scope: this,
//                        handler: this.refresh
//                    }
//                ],
//                listeners: {
//                    scope: this,
//                    rowclick: function(grid,rowIndex,colIndex,e)
//                    {
//                        var record = grid.getStore().getAt(rowIndex).data;
//
//                        var panel = parent.panels.form.object;
//                        var form  = panel.getForm();
//
//                        form.url = this.url.edit;
//                        form.baseParams.uuid = Inprint.grid.getValues(this.grid, 'uuid');
//                        panel.buttons[0].setText('Редактировать' );
//
//                        form.findField('advertiser').setValue( record.advertiser );
//                        form.findField('advertiser').setRawValue( record.title );
//
//                        form.findField('advpage').setValue( record.page );
//                        form.findField('advpage').setRawValue( record.seqnum );
//
//                        form.findField('fascicle').loadValue( record.fascicle );
//                        form.findField('advplace').loadValue( record.place );
//                        form.findField('advsize').loadValue( record.size );
//
//                    }
//                }
//            });
//
//            this.object = this.grid;
//            return this;
//        },
//
//        refresh: function() {
//            this.grid.store.reload();
//        },
//
//
//        remove: function(inc)
//        {
//
//            if (inc == 'no')
//            {
//                return;
//            }
//
//            else if ( inc == 'yes')
//            {
//                Ext.Ajax.request({
//                    url: this.url.remove,
//                    scope: this,
//                    params: {
//                        fascicle: this.fascicle,
//                        uuid: Inprint.grid.getValues(this.grid, 'uuid')
//                    },
//                    success: function(response, options)
//                    {
//                        this.refresh();
//                    },
//                    failure: Inprint.ajax.failure
//                });
//            }
//
//            else
//            {
//                Ext.MessageBox.confirm(
//                    'Подтверждение',
//                    'Вы действительно хотите удалить выбранные заявки?',
//                    this.remove,
//                    this
//                );
//            }
//
//        },
//
//        printPage: function( params )
//        {
//            window.location = '/advert/request/list-pdf/?fascicle='+ this.fascicle;
//        }
//
//    };
//};