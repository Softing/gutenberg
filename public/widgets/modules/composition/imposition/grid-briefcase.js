/*
 * Inprint Content 4.0
 * Copyright(c) 2001-2009, Softing, LLC.
 * licensing@softing.ru
 *
 * http://softing.ru/license
 */

Inprint.composition.Briefcase = Ext.extend(Ext.grid.GridPanel, {
    
    initComponent: function() {
        
        this.url = {
            move:    '/composite2/briefcase/move/',
            load:    '/composite2/briefcase/list/'
        };
        
        Ext.apply(this, {
            
            stripeRows: true,
            stateful: false,
            loadMask: false,
            autoExpandColumn: 'nowrap',
            clicksToEdit:1,
            view: new Ext.grid.GroupingView({
                forceFit:true,
                hideGroupedColumn:true,
                showGroupName:false
            }),

            sm: new Ext.grid.CheckboxSelectionModel(),
            
            store: new Ext.data.GroupingStore({
                baseParams: {
                    fascicle: this.fascicle
                },
                autoLoad:true,
                groupField:'group',
                proxy: new Ext.data.HttpProxy({ url: this.url.load }),
                reader: new Ext.data.ArrayReader({
                    id: 'uuid',
                    fields: [
                        'uuid','group', 'department', 'department_name', 'title', 'section', 'section_name', 'rubric',
                        'rubric_name', 'pages', 'page_str', 'exist_section', 'exist_rubric'
                    ]
                }),
                remoteGroup:true,
                remoteSort:true
            }),
            
            cm: new Ext.grid.ColumnModel([
                new Ext.grid.CheckboxSelectionModel(),
                {
                    id: 'nowrap',
                    header: Inprint.str.name,
                    dataIndex: 'title',
                    renderer: function (v) {
                        return '<span style="color:#000066">'+v+'</span>';
                    }
                },{
                    header: 'Отдел',
                    width: 50,
                    dataIndex: 'department_name'
                },
                
                {
                    header: 'Раздел',
                    width: 50,
                    dataIndex: 'section_name',
                    renderer: function(v,p,r) {
                        if (r.data.exist_section) {
                            return v;
                        } else {
                            return '<span style="color:red">'+ v +'</span>';
                        }
                    }
                },
                
                {
                    header: Inprint.str.rubric,
                    width: 50,
                    dataIndex: 'rubric_name',
                    renderer: function(v,p,r) {
                        if (r.data.exist_rubric) {
                            return v;
                        } else {
                            return '<span style="color:red">'+ v +'</span>';
                        }
                    }
                },
                
                {
                    header: 'group',
                    dataIndex: 'group',
                    groupRenderer: function(v, unused,record)
                    {
                        if (v == 'no_fascicle')
                        {
                            return 'Раздел не указан';
                        }
                        if (v == 'no_rubric')
                        {
                            return 'Рубрика не указана';
                        }
                        return v;
                    }
                }
            ])
        });
        
        Inprint.composition.Briefcase.superclass.initComponent.apply(this, arguments);
        
    },
    
    onRender: function() {
        Inprint.composition.Briefcase.superclass.onRender.apply(this, arguments);
    },
    
    cmpGetValues: function () {
        return Inprint.grid.getValues(this, 'uuid');
    }
    
});
