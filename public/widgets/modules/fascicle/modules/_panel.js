Inprint.fascicle.modules.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
        this.access = {};
        this.panels = {};
        
        this.fascicle = this.oid;
        
        this.panels["pages"]   = new Inprint.fascicle.modules.Pages({
            parent: this
        });
        
        Ext.apply(this, {
            layout: "fit",
            items: this.panels["pages"]
        });
        
        Inprint.fascicle.modules.Panel.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        
        Inprint.fascicle.modules.Panel.superclass.onRender.apply(this, arguments);
        
        Inprint.fascicle.modules.Access(this, this.panels);
        Inprint.fascicle.modules.Context(this, this.panels);
        Inprint.fascicle.modules.Interaction(this, this.panels);
    }

});

Inprint.registry.register("fascicle-modules", {
    icon: "table-split",
    text: _("Fascicle modules"),
    xobject: Inprint.fascicle.modules.Panel
});