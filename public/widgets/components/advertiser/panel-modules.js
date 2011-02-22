Inprint.cmp.adverta.Modules = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};

        this.panels.modules = new Inprint.cmp.adverta.GridModules({
            parent: this.parent
        });

        this.panels.templates = new Inprint.cmp.adverta.GridTemplates({
            parent: this.parent
        });

        Ext.apply(this, {
            border:false,
            flex:2,
            margins: "0 3 0 3",
            layout: "border",
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                this.panels.modules,
                this.panels.templates
            ]
        });

        Inprint.cmp.adverta.Modules.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.adverta.Modules.superclass.onRender.apply(this, arguments);
    }

});
