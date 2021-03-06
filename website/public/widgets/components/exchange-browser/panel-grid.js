Inprint.cmp.ExcahngeBrowser.Principals = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = Inprint.factory.Store.json("/common/transfer/list/");
        this.selectionModel = new Ext.grid.CheckboxSelectionModel({
            singleSelect:true
        });

        Ext.apply(this, {
            border: false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "description",
            columns: [
                this.selectionModel,
                {
                    id:"icon",
                    width: 28,
                    dataIndex: "type",
                    renderer: function(v) {
                        var icon;
                        switch (v) {
                            case "group":
                                icon = _ico("folder");
                            break;
                            case "member":
                                icon = _ico("user");
                            break;
                        }
                        return "<img src=\""+ icon +"\">";
                    }
                },
                {
                    id:"name",
                    header: _("Title"),
                    width: 160,
                    sortable: true,
                    dataIndex: "title",
                    renderer: function(v, p, record) {
                        var text;
                        switch (record.data.type) {
                            case "group":
                                text = "<b>" + v +"</b>";
                            break;
                            case "member":
                                text = v;
                            break;
                        }
                        return text;
                    }
                },
                {
                    id:"description",
                    header: _("Description"),
                    dataIndex: "description"
                }
            ],

            tbar: [
                '->',
                {
                    xtype:"searchfield",
                    width:200,
                    store: this.store
                }
            ]
        });

        Inprint.cmp.ExcahngeBrowser.Principals.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.ExcahngeBrowser.Principals.superclass.onRender.apply(this, arguments);
    }

});
