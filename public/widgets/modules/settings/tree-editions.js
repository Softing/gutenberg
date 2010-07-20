Ext.namespace("Inprint.settings");

Inprint.settings.EditionsTree = Ext.extend(Ext.tree.TreePanel, {

    initComponent: function() {

        Ext.apply(this, {
            useArrows:true,
            autoScroll:true,
            animate:true,
            containerScroll:true,
            border:false,
            lines:true,
            useArrows: true,
            dataUrl: _url("/tree/editions/"),
            bodyStyle: "padding-top:5px;",
            root: {
                id:'root-node',
                root:true,
                icon: _ico("newspapers.png"),
                text: _("Editions")
            }
        });

        Inprint.settings.EditionsTree.superclass.initComponent.apply(this, arguments);

        this.on("beforeappend", function(tree, parent, node) {
            node.attributes.icon = _ico(node.attributes.icon);
            if (node.attributes.color) {
                node.text = "<span style=\"color:#"+ node.attributes.color +"\">" + node.attributes.text + "</span>";

            }
        });

    },

    onRender: function() {
        Inprint.settings.EditionsTree.superclass.onRender.apply(this, arguments);
        
        this.getLoader().on("load", function(loader, node) {
            node.item(0).select();
        })

    },

    cmpExpand: function(params) {
        Ext.apply(this.getLoader().baseParams, params);
        this.getRootNode().expand();
    }

});