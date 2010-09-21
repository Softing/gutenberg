Inprint.membersBrowser.PrincipalsView = Ext.extend(Ext.DataView, {
    initComponent: function() {

        var store = Inprint.factory.Store.json("/principals/list/", {
            autoLoad:false
        });

        var groupicon  = _ico("folder");
        var membericon = _ico("user");

        var tpl = new Ext.XTemplate(
	    '<tpl for=".">',

                '<tpl if="type == \'group\'">',
                    '<div class="view-item" id="id-{id}" style="background:url('+groupicon+') no-repeat;padding-left:24px;height:20px;cursor:hand;">',
                        '<b>{shortcut}</b>',
                    '</div>',
                '</tpl>',

                '<tpl if="type == \'member\'">',
                    '<div class="view-item" id="id-{id}" style="background:url('+membericon+') no-repeat;padding-left:24px;height:20px;cursor:hand;">',
                        '{shortcut}',
                    '</div>',
                '</tpl>',


            '</tpl>',
            '<div class="x-clear"></div>'
	);

        Ext.apply(this, {
            border:false,
            store: store,
            tpl: tpl,
            //autoHeight:true,
            autoScroll:true,
            multiSelect: true,
            overClass:'x-view-over',
            itemSelector:'div.view-item',
            emptyText: _("No chains to display")
        });

        Inprint.membersBrowser.PrincipalsView.superclass.initComponent.apply(this, arguments);

    },
    onRender: function() {
        Inprint.membersBrowser.PrincipalsView.superclass.onRender.apply(this, arguments);
    }
});
