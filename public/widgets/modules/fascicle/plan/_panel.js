Inprint.fascicle.plan.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
        this.view = new Inprint.fascicle.plan.View({
            parent: this,
            fascicle: this.oid
        });
        
        this.tbar = [
            {
                text: 'Печать А3',
                icon: _ico("printer"),
                cls: 'x-btn-text-icon',
                scope:this, 
                handler: function() {
                    window.location = '/composite2/pdf/?fascicle='+ this.fascicle +'&mode=landscape&size=a3';
                }
            },
            {
                text: 'Печать А4',
                icon: _ico("printer"),
                cls: 'x-btn-text-icon',
                scope:this, 
                handler: function() {
                    window.location = '/composite2/pdf/?fascicle='+ this.fascicle +'&mode=landscape&size=a4';
                }
            }
        ];
        
        Ext.apply(this, {
            layout: 'fit',
            autoScroll:true,
            items: this.view
        });
        
        Inprint.fascicle.plan.Panel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.plan.Panel.superclass.onRender.apply(this, arguments);
    },
    
    cmpReload:  function() {
        this.view.cmpReload();
    }
    
    
});

Inprint.registry.register("fascicle-plan", {
    icon: "table",
    text: _("Plan"),
    xobject: Inprint.fascicle.plan.Panel
});