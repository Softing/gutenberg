Inprint.cmp.adverta.Templates = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.urls = {
            "list": "/fascicle/templates/modules/"
        };

        var selection = this.parent.selection;
        var selLength = this.parent.selLength;

        var pages = [];
        for (var c = 1; c < selection.length+1; c++) {
            var array = selection[c-1].split("::");
            pages.push(array[0]);
        }

        this.store = Inprint.factory.Store.json(this.urls.list, {
            baseParams: {
                fascicle: this.fascicle
            }
        });

        this.selectionModel = new Ext.grid.CheckboxSelectionModel({
            singleSelect:true
        });

        this.columns = [
            this.selectionModel,
            {
                id:"place_title",
                header: _("Place"),
                width: 100,
                sortable: true,
                dataIndex: "place_title"
            },
            {
                id:"title",
                header: _("Title"),
                width: 100,
                sortable: true,
                dataIndex: "title"
            }
        ];

        Ext.apply(this, {

            title: _("Templates"),

            flex:2,
            margins: "0 3 0 3",

            layout:"fit",
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel
        });

        Inprint.cmp.adverta.Templates.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {

        Inprint.cmp.adverta.Templates.superclass.onRender.apply(this, arguments);

        this.getStore().load();


    }
});
