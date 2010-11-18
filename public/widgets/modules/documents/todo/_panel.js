Inprint.documents.todo.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};

        this.panels.grid    = new Inprint.documents.Grid({
            gridmode: 'todo',
            stateful: true,
            stateId: 'documents.grid.todo'
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

        Inprint.documents.todo.Panel.superclass.initComponent.apply(this, arguments);

        Inprint.documents.todo.Interaction(this.panels);

    },

    cmpReload: function() {
        this.panels.grid.cmpReload();
    },

    onRender: function() {
        Inprint.documents.todo.Panel.superclass.onRender.apply(this, arguments);
    }
});

Inprint.registry.register("documents-todo", {
    icon: "document-share",
    text:  _("Todo"),
    xobject: Inprint.documents.todo.Panel
});