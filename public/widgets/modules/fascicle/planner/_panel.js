Inprint.fascicle.planner.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

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