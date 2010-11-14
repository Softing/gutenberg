/*
 * Inprint Content 4.0
 * Copyright(c) 2001-2009, Softing, LLC.
 * licensing@softing.ru
 *
 * http://softing.ru/license
 */

Inprint.composition.Advertising = Ext.extend(Ext.grid.EditorGridPanel, {
    
    initComponent: function() {
        
        this.editable = false;
        
        this.url = {
            save:       '/composite2/advert/save/',
            load:       '/composite2/advert/list/'
        };
        
        Ext.apply(this, {
            
            autoExpandColumn: 'page',
            loadMask: false,
            //clicksToEdit:1,
            view: new Ext.grid.GroupingView({
                forceFit: false,
                showGroupName: false
            }),
            stripeRows: true,
            stateful: false,
            
            store: new Ext.data.GroupingStore({
                autoLoad:false,
                baseParams: {
                    fascicle: this.fascicle
                },
                groupField:'place',
                proxy: new Ext.data.HttpProxy({
                    url: this.url.load
                }),
                reader: new Ext.data.JsonReader({
                    id: 'uuid',
                    fields: [ 'uuid','group', 'place', 'size', 'page', 'inplace', 'outplace', 'freeplace' ]
                }),
                sortInfo: {field: 'place', direction: 'ASC' }
            }),
            
            cm: new Ext.grid.ColumnModel(
            [
                {
                    id: 'size',
                    header: 'Размер',
                    width: 100,
                    dataIndex: 'size'
                },
                {
                    id: 'page',
                    header: Inprint.str.pages,
                    dataIndex: 'page',
                    clicksToEdit:1,
                    editor: new Ext.form.TextField({
                        allowBlank: true
                    })
                },
                {
                    id: 'inplace',
                    header: 'ЗА',
                    width: 30,
                    dataIndex: 'inplace',
                    menuDisabled:true
                },
                {
                    id: 'outplace',
                    header: 'РЗ',
                    width: 30,
                    dataIndex: 'outplace',
                    menuDisabled:true
                },

                {
                    id: 'freeplace',
                    header: 'CВ',
                    width: 30,
                    dataIndex: 'freeplace',
                    menuDisabled:true,
                    renderer: function (v,p,r) {
                        if ( r.data.inplace != r.data.outplace ) return '<span style="color:red">'+ v +'</span>';
                        return v;
                    }
                },
                {
                    id: 'place',
                    header: 'Позиция',
                    dataIndex: 'place',
                    hidden:true
                },
                {
                    id: 'group',
                    header: 'Позиция',
                    dataIndex: 'group',
                    hidden:true
                }
            ])
            
        });
        
        Inprint.composition.Advertising.superclass.initComponent.apply(this, arguments);
        
    },
    
    onRender: function() {
        
        Inprint.composition.Advertising.superclass.onRender.apply(this, arguments);
        
        this.on("beforeedit", function() {
            return this.editable
        }, this);
        
        this.parent.on('enableButtons', function(parent) {
            this.editable = true;
        }, this);
        
        this.parent.on('disableButtons', function(parent) {
            this.editable = false;
        }, this);
        
        this.getStore().on("load", function(){
            if (this.scrollState) {
                this.getView().restoreScroll(this.scrollState);
            }
        }, this);
        
    },
    
    cmpLoadData: function (data) {
        this.scrollState = this.getView().getScrollState();
        this.getStore().loadData(data);
    }
});
