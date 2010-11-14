Inprint.cmp.PrincipalsBrowser = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.panels = {};
        this.panels.grid = new Inprint.cmp.PrincipalsBrowser.Grid()
        this.panels.tree = new Inprint.cmp.PrincipalsBrowser.Tree()

        Ext.apply(this, {
            title: _("Principals list"),
            modal: true,
            layout: "border",
            closeAction: "hide",
            width:800, height:400,
            items: [
                {
                    region: "center",
                    layout:"fit",
                    margins: "3 3 3 0",
                    border:false,
                    items: this.panels.grid
                },
                {
                    region:"west",
                    layout:"fit",
                    margins: "3 0 3 3",
                    width: 200,
                    minSize: 100,
                    maxSize: 600,
                    collapsible: false,
                    split: true,
                    items: this.panels.tree
                }
            ],
            buttons:[
                {
                    text: _("Select"),
                    scope:this,
                    handler: function() {
                        this.hide();
                        this.fireEvent('select', this.panels.grid.getValues("id"));
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
        Inprint.cmp.PrincipalsBrowser.superclass.initComponent.apply(this, arguments);
        Inprint.cmp.PrincipalsBrowser.Interaction(this.panels);

        this.addEvents('select');
    },

    onRender: function() {
        Inprint.cmp.PrincipalsBrowser.superclass.onRender.apply(this, arguments);
    }

});
