Inprint.advertising.advertisers.Main = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = Inprint.factory.Store.json(
            _source("advertisers.list"),
            {
                autoLoad: true,
                totalProperty: 'total'
            });

        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        var xcolumns = Inprint.advertising.advertisers.Columns;
        this.columns = [
            this.selectionModel,
            xcolumns.serial,
            xcolumns.edition,
            xcolumns.shortcut,
            xcolumns.address,
            xcolumns.contact,
            xcolumns.inn,
            xcolumns.kpp,
            xcolumns.bank,
            xcolumns.rs,
            xcolumns.ks,
            xcolumns.bik
        ];

        this.tbar = [
            {
                icon: _ico("plus-button"),
                cls: "x-btn-text-icon",
                text: _("Add"),
                ref: "../btnCreate",
                scope:this,
                handler: Inprint.advertising.advertisers.actionCreate
            },
            {
                icon: _ico("pencil"),
                cls: "x-btn-text-icon",
                text: _("Update"),
                disabled:true,
                ref: "../btnUpdate",
                scope:this,
                handler: Inprint.advertising.advertisers.actionUpdate
            },
            '-',
            {
                icon: _ico("minus-button"),
                cls: "x-btn-text-icon",
                text: _("Remove"),
                disabled:true,
                ref: "../btnDelete",
                scope:this,
                handler: Inprint.advertising.advertisers.actionDelete
            }
        ];

        this.bbar = new Ext.PagingToolbar({
            pageSize: 100,
            store: this.store,
            displayInfo: true,
            plugins: new Ext.ux.SlidingPager()
        });

        Ext.apply(this, {
            border: false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "shortcut"
        });

        Inprint.advertising.advertisers.Main.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.advertising.advertisers.Main.superclass.onRender.apply(this, arguments);

        this.getSelectionModel().on("selectionchange", function(sm) {
            _disable(this.btnUpdate, this.btnDelete);
            if (sm.getCount() == 1) {
                _enable(this.btnUpdate, this.btnDelete);
            } else if (sm.getCount() > 1) {
                _enable(this.btnDelete);
            }
        }, this);
    }

});

Inprint.registry.register("advert-advertisers", {
    icon: "user-silhouette",
    text: _("Advertisers"),
    xobject: Inprint.advertising.advertisers.Main
});
