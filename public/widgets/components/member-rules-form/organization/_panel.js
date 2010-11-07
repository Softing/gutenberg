Inprint.cmp.memberRulesForm.Organization = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};
        this.panels["tree"] = new Inprint.cmp.memberRulesForm.Organization.Tree();
        this.panels["grid"] = new Inprint.cmp.memberRulesForm.Organization.Restrictions();

        Ext.apply(this, {
            border:false,
            title: _("Organization"),
            layout: "border",
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                {
                    region: "center",
                    layout:"fit",
                    border:false,
                    margins: "3 3 3 0",
                    items: this.panels["grid"]
                },
                {
                    region:"west",
                    layout:"fit",
                    border:false,
                    margins: "3 0 3 3",
                    width: 200,
                    items: this.panels["tree"]
                }
            ]
        });
        Inprint.cmp.memberRulesForm.Organization.superclass.initComponent.apply(this, arguments);
        Inprint.cmp.memberRulesForm.Organization.Interaction(this, this.panels);
    },

    onRender: function() {
        Inprint.cmp.memberRulesForm.Organization.superclass.onRender.apply(this, arguments);
    },
    
    cmpReload: function() {
        this.panels["grid"].cmpReload();
    },
    
    cmpSave: function() {
        this.panels["grid"].cmpSave();
    }

});
