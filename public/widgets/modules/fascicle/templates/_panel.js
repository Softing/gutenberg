Inprint.fascicle.templates.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
        this.access = {};
        this.panels = {};
        
        this.fascicle = this.oid;
        
        this.panels["pages"]   = new Inprint.fascicle.templates.Pages({
            parent: this
        });
        
        Ext.apply(this, {
            layout: "fit",
            items: this.panels["pages"]
        });
        
        Inprint.fascicle.templates.Panel.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        
        Inprint.fascicle.templates.Panel.superclass.onRender.apply(this, arguments);
        
        Inprint.fascicle.templates.Access(this, this.panels);
        Inprint.fascicle.templates.Context(this, this.panels);
        Inprint.fascicle.templates.Interaction(this, this.panels);
    }

});

Inprint.registry.register("fascicle-templates", {
    icon: "tables-stacks",
    text: _("Fascicle pages"),
    xobject: Inprint.fascicle.templates.Panel
});