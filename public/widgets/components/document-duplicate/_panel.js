Inprint.cmp.DuplicateDocument = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.panels = {};
        this.panels.tree = new Inprint.cmp.DuplicateDocument.Tree();
        this.panels.grid = new Inprint.cmp.DuplicateDocument.Grid();

        Ext.apply(this, {
            title: _("Duplicate documents"),
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
                    text: _("Duplicate"),
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

        Inprint.cmp.DuplicateDocument.superclass.initComponent.apply(this, arguments);
        Inprint.cmp.DuplicateDocument.Interaction(this.panels);

    },

    onRender: function() {
        Inprint.cmp.DuplicateDocument.superclass.onRender.apply(this, arguments);
    }

});
