Inprint.documents.briefcase.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};

        this.panels.grid    = new Inprint.documents.Grid({
            gridmode: 'briefcase',
            stateful: true,
            stateId: 'documents.grid.briefcase'
        });

        Ext.apply(this, {

            border:true,

            layout: "border",

            defaults: {
                collapsible: false,
                split: true
            },

            items: [
                {   region: "center",
                    //margins: "3 0 3 3",
                    layout:"fit",
                    items: this.panels.grid
                }
            ]
        });

        Inprint.documents.briefcase.Panel.superclass.initComponent.apply(this, arguments);
        
    },

    onRender: function() {
        Inprint.documents.briefcase.Panel.superclass.onRender.apply(this, arguments);
        Inprint.documents.briefcase.Access(this, this.panels);
        Inprint.documents.briefcase.Interaction(this, this.panels);
    },
    
        cmpReload: function() {
        this.panels.grid.cmpReload();
    }
});

Inprint.registry.register("documents-briefcase", {
    icon: "briefcase",
    text:  _("Briefcase"),
    xobject: Inprint.documents.briefcase.Panel
});