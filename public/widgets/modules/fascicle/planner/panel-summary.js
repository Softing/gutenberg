Inprint.fascicle.planner.Summary = Ext.extend(Ext.grid.EditorGridPanel, {

    initComponent: function() {
        
        this.urls = {
            "list":       "/fascicle/summary/"
        }

        this.store = Inprint.factory.Store.group(this.urls.list, {
            remoteSort: true,
            groupField:'place_shortcut',
            remoteGroup:false,
            remoteSort:false,
            baseParams: {
                fascicle: this.oid
            }
        });

        this.sm = new Ext.grid.CheckboxSelectionModel();
        
        this.colModel = new Ext.grid.ColumnModel({
            defaults: {
                sortable: false,
                menuDisabled: true
            },
            columns: [
                {
                    id: 'place',
                    hidden:true,
                    header: _('Place'),
                    dataIndex: 'place_shortcut'
                },
                {
                    id: 'pages',
                    header: _('Pages')
                },
                {
                    id: 'module',
                    header: _('Module'),
                    dataIndex: 'module_shortcut'
                },
                {
                    id: 'holes',
                    width: 10,
                    header: _('HL'),
                    dataIndex: 'holes'
                },
                {
                    id: 'requests',
                    width: 10,
                    header: _('RQ'),
                    dataIndex: 'requests'
                },
                {
                    id: 'free',
                    width: 10,
                    header: _('FR'),
                    dataIndex: 'free'
                }  
            ]
        });
        
        this.view = new Ext.grid.GroupingView({
            forceFit:true,
            hideGroupedColumn: true,
            groupTextTpl: '{text}'
        });
        
        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            autoExpandColumn: "title",
            sm: this.sm,
            tbar: this.tbar,
            columns: this.columns
        });
        
        Inprint.fascicle.planner.Summary.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.planner.Summary.superclass.onRender.apply(this, arguments);
    }
});
