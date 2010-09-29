Inprint.documents.recycle.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};

        this.panels.grid    = new Inprint.documents.Grid({
            gridmode: 'recycle',
            stateful: true,
            stateId: 'documents.grid.recycle'
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

        Inprint.documents.recycle.Panel.superclass.initComponent.apply(this, arguments);

        Inprint.documents.recycle.Interaction(this.panels);

    },

    cmpReload: function() {
        this.panels.grid.cmpReload();
    },

    onRender: function() {
        Inprint.documents.recycle.Panel.superclass.onRender.apply(this, arguments);
    }
});
