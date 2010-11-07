Inprint.cmp.memberRulesForm.Domain = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
        this.grid = new Inprint.cmp.memberRulesForm.Domain.Restrictions();

        Ext.apply(this, {
            border:false,
            layout: "fit",
            title: _("Domain"),
            items: this.grid
        });

        Inprint.cmp.memberRulesForm.Domain.superclass.initComponent.apply(this, arguments);
        Inprint.cmp.memberRulesForm.Domain.Interaction(this, this.panels);
    },

    onRender: function() {
        Inprint.cmp.memberRulesForm.Domain.superclass.onRender.apply(this, arguments);
        this.grid.getStore().on("load", function(){
            this.grid.cmpFill(this.memberId);
        }, this);
    },
    
    cmpReload: function() {
        this.grid.cmpReload();
    },
    
    cmpSave: function() {
        this.grid.cmpSave();
    }

});
