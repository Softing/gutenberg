Inprint.fascicle.planner.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
        this.panels = {
            pages: new Inprint.fascicle.planner.Pages({
                parent: this,
                oid: this.oid
            }),
            documents: new Inprint.fascicle.planner.Documents({
                parent: this,
                oid: this.oid
            })
        }
        
        Ext.apply(this, {
            layout: "border",
            autoScroll:true,
            defaults: {
                collapsible: false,
                split: true
            },
            
            items: [
                {
                    border:false,
                    region: "center",
                    layout: "border",
                    margins: "3 0 3 3",
                    defaults: {
                        collapsible: false,
                        split: true
                    },
                    items: [
                        {
                            region: "center",
                            layout: "fit",
                            items: this.panels["pages"]
                        },
                        {
                            region:"south",
                            height: 400,
                            minSize: 100,
                            maxSize: 800,
                            layout:"fit",
                            collapseMode: 'mini',
                            items: this.panels["documents"]
                        }
                    ]
                },
                {
                    region:"east",
                    margins: "3 3 3 0",
                    width: 280,
                    minSize: 50,
                    maxSize: 800,
                    layout:"fit",
                    collapseMode: 'mini',
                    items: new Ext.TabPanel({
                        activeTab: 0,
                        defaults:{autoHeight: true},
                        items:[
                            new Ext.Panel({ title: "Сводка", border:false }),
                            new Ext.Panel({ title: "Конфигурация полосы", border:false })
                        ]
                    })
                }
            ]
        });
        
        Inprint.fascicle.planner.Panel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.planner.Panel.superclass.onRender.apply(this, arguments);
    }
});

Inprint.registry.register("fascicle-planner", {
    icon: "clock",
    text: _("Planning"),
    xobject: Inprint.fascicle.planner.Panel
});