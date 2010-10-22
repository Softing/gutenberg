Inprint.cmp.CopyDocument = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.panels = {};
        this.panels.tree = new Inprint.cmp.CopyDocument.Tree();
        this.panels.grid = new Inprint.cmp.CopyDocument.Grid();

        Ext.apply(this, {
            title: _("Copy documents"),
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
                    items: this.panels.tree
                },
                {
                    flex:2,
                    layout:"fit",
                    margins: "0 3 0 3",
                    collapsible: false,
                    split: true,
                    items: this.panels.grid
                }
            ],
            buttons:[
                {
                    text: _("Copy"),
                    scope:this,
                    disabled:true,
                    handler: function() {
                        //this.fireEvent('selected', this, this.panels.principals.getValue("id"));
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

        Inprint.cmp.CopyDocument.superclass.initComponent.apply(this, arguments);
        Inprint.cmp.CopyDocument.Interaction(this.panels);

    },

    onRender: function() {
        Inprint.cmp.CopyDocument.superclass.onRender.apply(this, arguments);
    }

});
