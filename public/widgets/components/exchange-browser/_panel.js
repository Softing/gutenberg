Inprint.cmp.ExcahngeBrowser = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.panels = {};
        this.panels.editions = new Inprint.cmp.ExcahngeBrowser.TreeEditions();
        this.panels.stages = new Inprint.cmp.ExcahngeBrowser.TreeStages();
        this.panels.principals = new Inprint.cmp.ExcahngeBrowser.Principals();

        Ext.apply(this, {
            title: _("Transfer browser"),
            border:false,
            modal:true,
            layout: "hbox",
            width:800, height:400,
            layoutConfig: {
                align : 'stretch',
                pack  : 'start'
            },
            items: [
                {
                    flex:1,
                    layout:"fit",
                    margins: "0 0 0 0",
                    width: 100,
                    collapsible: false,
                    split: true,
                    items: this.panels.editions
                },
                {
                    flex:2,
                    layout:"fit",
                    margins: "0 3 0 3",
                    width: 160,
                    collapsible: false,
                    split: true,
                    items: this.panels.stages
                },
                {
                    flex:3,
                    layout:"fit",
                    margins: "0 0 0 0",
                    items: this.panels.principals
                }
            ],
            buttons:[
                {
                    text: _("Transfer"),
                    scope:this,
                    disabled:true,
                    handler: function() {
                        this.fireEvent('selected', this, this.panels.principals.getValue("id"));
                    }
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
        Inprint.cmp.ExcahngeBrowser.superclass.initComponent.apply(this, arguments);
        Inprint.cmp.ExcahngeBrowser.Interaction(this, this.panels);
        this.addEvents('selected');
    },

    onRender: function() {
        Inprint.cmp.ExcahngeBrowser.superclass.onRender.apply(this, arguments);
    }

});
