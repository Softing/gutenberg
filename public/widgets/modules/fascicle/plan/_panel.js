Inprint.fascicle.plan.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        Inprint.fascicle.plan.Panel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.plan.Panel.superclass.onRender.apply(this, arguments);
    }
});

Inprint.registry.register("fascicle-plan", {
    icon: "table",
    text: _("Plan"),
    xobject: Inprint.fascicle.plan.Panel
});