Inprint.employee.logs.Panel = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = Inprint.factory.Store.json("/system/events/list/");

        Ext.apply(this, {
            stripeRows: true,
            autoExpandColumn: 'message',
            columns: [
                {   id:'date',
                    header: _("Record date"),
                    width: 140,
                    sortable: true,
                    renderer: Ext.util.Format.dateRenderer('<b>D j M Y</b> H:i'),
                    dataIndex: 'created'
                },
                {   id:'initiator',
                    header: _("Employee"),
                    width: 160,
                    dataIndex: 'initiator_shortcut',
                    renderer: function(value) {
                        if (value == null) return _("Not defined");
                        return value;
                    }
                },

                {   id:'type',
                    header: _("Type"),
                    width: 140,
                    sortable: true,
                    dataIndex: 'entity_type',
                    renderer: function(value) {
                        return _(value);
                    }
                },

                {   id:'action',
                    header: _("Action"),
                    width: 140,
                    sortable: true,
                    dataIndex: 'message_type',
                    renderer: function(value) {
                        return _(value);
                    }
                },

                {   id:'message',
                    header: _("Event"),
                    width: 75,
                    sortable: true,
                    dataIndex: 'message'
                }
            ],

            bbar: new Ext.PagingToolbar({
                pageSize: 100,
                store: this.store
            })
        });

        Inprint.employee.logs.Panel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.employee.logs.Panel.superclass.onRender.apply(this, arguments);
        this.store.load();
    },

    reload: function() {
        this.store.reload();
    }

});

Inprint.registry.register("employee-logs", {
    icon: "card-address",
    text: _("Logs"),
    xobject: Inprint.employee.logs.Panel
});