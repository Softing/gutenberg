Inprint.cmp.Composer = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.panels = {};
        
        this.selLength = this.selection.length;
        
        this.panels["modules"] = new Inprint.cmp.composer.Modules({
            parent: this
        });
        this.panels["flash"]   = new Inprint.cmp.composer.Flash({
            parent: this
        });
        
        Ext.apply(this, {
            width: (this.selLength*300) + 400,
            height:450,
            modal:true,
            layout: "border",
            closeAction: "hide",
            title: _("Разметка полос"),
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                this.panels["modules"],
                this.panels["flash"]
            ],
            listeners: {
                scope:this,
                afterrender: function(panel) {
                    //panel.flashLeft = panel.findByType("flash")[0].swf;
                    //panel.flashRight = panel.findByType("flash")[0].swf;
                    //panel.grid  = panel.findByType("grid")[0];
                }
            },
            buttons:[
                {
                    text: _("Save"),
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

        Inprint.cmp.Composer.superclass.initComponent.apply(this, arguments);
        
    },

    onRender: function() {
        Inprint.cmp.Composer.superclass.onRender.apply(this, arguments);
        //Inprint.cmp.Composer.Interaction(this, this.panels);
    }

});