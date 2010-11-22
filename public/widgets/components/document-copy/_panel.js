Inprint.cmp.CopyDocument = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.panels = {};
        this.panels.grid = new Inprint.cmp.CopyDocument.Grid();

        Ext.apply(this, {
            title: _("Copy documents"),
            border:false,
            modal:true,
            layout: "fit",
            width:600, height:300,
            items: this.panels.grid,
            buttons:[
                {
                    text: _("Copy"),
                    scope:this,
                    disabled:true
                },
                {
                    text: _("Close"),
                    scope:this,
                    handler: function() {
                        this.hide();
                    }
                }
            ]
        });

        Inprint.cmp.CopyDocument.superclass.initComponent.apply(this, arguments);
        
    },

    onRender: function() {
        Inprint.cmp.CopyDocument.superclass.onRender.apply(this, arguments);
        Inprint.cmp.CopyDocument.Interaction(this, this.panels);
    },
    
    setId: function(data) {
        this.oid = data;
    }

});
