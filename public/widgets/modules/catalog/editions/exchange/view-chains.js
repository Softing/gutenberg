Inprint.exchange.ChainsView = Ext.extend(Ext.DataView, {
    initComponent: function() {

        var store = Inprint.factory.Store.json("/chains/combo/", {
            autoLoad:true
        });

        var icon = _ico("universal");

        var tpl = new Ext.XTemplate(
	    '<tpl for=".">',
                '<div class="view-item" id="id-{id}" style="background:url('+icon+') no-repeat;padding-left:24px;height:20px;cursor:hand;">',
		    '{shortcut}',
                '</div>',
            '</tpl>',
            '<div class="x-clear"></div>'
	);

        Ext.apply(this, {
            border:false,
            store: store,
            tpl: tpl,
            autoHeight:true,
            singleSelect: true,
            overClass:'x-view-over',
            itemSelector:'div.view-item',
            emptyText: _("No chains to display")
        });

        Inprint.exchange.ChainsView.superclass.initComponent.apply(this, arguments);

    },
    onRender: function() {
        Inprint.exchange.ChainsView.superclass.onRender.apply(this, arguments);
    }
});
