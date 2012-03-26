Inprint.calendar.templates.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.access = {};

        this.panels = {};
        this.panels.templates = new Inprint.calendar.templates.Issues();

        Ext.apply(this, {
            layout: "border",
            items: this.panels.templates
        });

        Inprint.calendar.templates.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.templates.Main.superclass.onRender.apply(this, arguments);
        Inprint.calendar.templates.Interaction(this, this.panels);
    },

    cmpReload: function() {
        this.panels.templates.cmpReload();
    }

});
