Inprint.cmp.composer.GridTemplates = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {
        
        this.urls = {
            "list": "/fascicle/pages/templates/"
        }
        
        var selection = this.parent.selection;
        var selLength = this.parent.selLength;
        
        var pages = [];
        for (var c = 1; c < selection.length+1; c++) {
            var array = selection[c-1].split("::");
            pages.push(array[0]);
        }
        
        this.store = Inprint.factory.Store.json(this.urls["list"], {
            autoLoad:true,
            baseParams: {
                page: pages
            }
        });
        
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();
        
        this.columns = [
            this.selectionModel,
            {
                id:"title",
                header: _("Title"),
                width: 150,
                sortable: true,
                dataIndex: "title"
            },
            {
                id:"shortcut",
                header: _("Shortcut"),
                width: 150,
                sortable: true,
                dataIndex: "shortcut"
            },
            {
                id:"description",
                header: _("Description"),
                sortable: true,
                dataIndex: "description"
            },
            {
                id:"amount",
                header: _("Amount"),
                sortable: true,
                dataIndex: "amount"
            },
            {
                id:"area",
                header: _("Area"),
                sortable: true,
                dataIndex: "area"
            },
            {
                id:"x",
                header: _("X"),
                sortable: true,
                dataIndex: "x"
            },
            {
                id:"y",
                header: _("Y"),
                sortable: true,
                dataIndex: "y"
            },
            {
                id:"w",
                header: _("W"),
                sortable: true,
                dataIndex: "w"
            },
            {
                id:"h",
                header: _("H"),
                sortable: true,
                dataIndex: "h"
            }
        ];
        
        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel
            //autoExpandColumn: "description"
        });

        Inprint.cmp.composer.GridTemplates.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.composer.GridTemplates.superclass.onRender.apply(this, arguments);
    }
});
