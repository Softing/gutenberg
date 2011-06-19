Inprint.fascicle.adverter.Briefcase = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        var columns = new Inprint.documents.GridColumns();

        this.urls = {
            "list":       "/documents/list/"
        };

        this.store = Inprint.factory.Store.group(this.urls.list, {
            groupField:'headline_shortcut',
            remoteGroup:false,
            remoteSort:true,
            autoLoad:true,
            baseParams: {
                gridmode: "briefcase"
            }
        });

        this.sm = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            this.sm,
            columns.title,
            columns.edition,
            columns.workgroup,
            columns.headline,
            columns.rubric,
            columns.manager,
            columns.progress,
            columns.holder,
            columns.images,
            columns.size
        ];

        this.view = new Ext.grid.GroupingView({
            forceFit:true,
            groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'

        });

        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            autoExpandColumn: "title",
            sm: this.sm,
            tbar: this.tbar,
            columns: this.columns
        });

        Inprint.fascicle.adverter.Briefcase.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.adverter.Briefcase.superclass.onRender.apply(this, arguments);
    }
});
