Inprint.cmp.membersList.Window = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.panels = {};
        this.panels.grid = new Inprint.cmp.membersList.Grid()

        Ext.apply(this, {
            title: _("Employeers list"),
            layout: "fit",
            closeAction: "hide",
            width:800, height:400,
            items: this.panels.grid,
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
        Inprint.cmp.membersList.Window.superclass.initComponent.apply(this, arguments);
        Inprint.cmp.membersList.Interaction(this.panels);

        this.addEvents('select');
    },

    onRender: function() {
        Inprint.cmp.membersList.Window.superclass.onRender.apply(this, arguments);
    },

    cmpLoad: function(node) {

        if (!node)
            node = '00000000-0000-0000-0000-000000000000';

        this.panels.grid.getStore().load({
            params: {
                node:node
            }
        })
    }

});
