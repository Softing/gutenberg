Inprint.cmp.adverta.GridTemplates = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.urls = {
            "list": "/fascicle/composer/templates/"
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
                fascicle:this.fascicle,
                page: pages
            }
        });

        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

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

            enableDrag: true,
            ddGroup: 'TreeDD',

            height:200,
            layout:"fit",
            region: "south",

            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel
        });

        Inprint.cmp.adverta.GridTemplates.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.adverta.GridTemplates.superclass.onRender.apply(this, arguments);

        this.getStore().load();

    }
});
