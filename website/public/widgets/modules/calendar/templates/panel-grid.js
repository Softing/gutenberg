Inprint.calendar.templates.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.url  = _source("fascicle.list");

        this.store = Inprint.createJsonStore()
            .setSource("template.list")
            .addField("id")
            .addField("fastype")
            .addField("edition")
            .addField("edition_shortcut")
            .addField("shortcut")
            .addField("description")
            .addField("created")
            .addField("updated")
            .create();

        this.columns = [
            Inprint.getColumn("edition"),
            Inprint.getColumn("shortcut"),
            Inprint.getColumn("description"),
            Inprint.getColumn("created"),
            Inprint.getColumn("updated"),
        ];

        Ext.apply(this, {
            border: false,
            disabled: true
        });

        Inprint.calendar.templates.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.templates.Grid.superclass.onRender.apply(this, arguments);
    }

});
