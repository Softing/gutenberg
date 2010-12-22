Inprint.fascicle.planner.Summary = Ext.extend(Ext.grid.EditorGridPanel, {

    initComponent: function() {
        
        this.urls = {
            "list":       "/fascicle/summary/"
        }

        this.store = Inprint.factory.Store.group(this.urls.list, {
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
                    id: 'place_shortcut',
                    header: _('Place'),
                    dataIndex: 'place_shortcut'
                },
                {
                    id: 'module',
                    width:80,
                    header: _('Module'),
                    dataIndex: 'shortcut'
                },
                {
                    id: 'pages',
                    header: _('Pages'),
                    dataIndex: 'pages',
                    editor: new Ext.form.TextField({
                        allowBlank: true
                    })
                },
                {
                    id: 'holes',
                    width: 20,
                    header: _('HL'),
                    dataIndex: 'holes'
                },
                {
                    id: 'requests',
                    width: 20,
                    header: _('RQ'),
                    dataIndex: 'requests'
                },
                {
                    id: 'free',
                    width: 20,
                    header: _('FR'),
                    dataIndex: 'free'
                }  
            ]
        });
        
        this.view = new Ext.grid.GroupingView({
            hideGroupedColumn: true,
            groupTextTpl: '{text}'
        });
        
        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            autoExpandColumn: "pages",
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
