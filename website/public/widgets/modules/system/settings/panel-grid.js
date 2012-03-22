Inprint.system.settings.Grid = Ext.extend(Ext.grid.PropertyGrid, {

    initComponent: function() {

        this.tbar = [
            {   icon: _ico("plus-button"),
                cls: "x-btn-text-icon",
                text: _("Save"),
                disabled:true,
                ref: "../btnSave"
            }
        ];

        Ext.apply(this, {
            border:false,
            propertyNames: {
                tested: 'QA',
                borderWidth: 'Border Width'
            },
            source: {
                '(name)': 'Properties Grid',
                grouping: false,
                autoFitColumns: true,
                productionQuality: false,
                created: new Date(Date.parse('10/15/2006')),
                tested: false,
                version: 0.01,
                borderWidth: 1
            },
            viewConfig : {
                forceFit: true
            }
        });

        Inprint.system.settings.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.system.settings.Grid.superclass.onRender.apply(this, arguments);
    }

});
