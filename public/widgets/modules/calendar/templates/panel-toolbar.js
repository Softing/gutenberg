Inprint.calendar.templates.Toolbar = function (scope) {

    return [
        {
            xtype: 'buttongroup',
            title: _('Create'),
            columns: 2,
            defaults: {
                scale: 'small'
            },
            items: [
                {
                    id: 'create',
                    disabled: true,
                    text: _("Template"),
                    ref: "../../btnCreate",
                    cls: 'x-btn-text-icon',
                    icon: _ico("puzzle"),
                    scope: scope,
                    handler: scope.cmpCreateFascicle
                }
            ]
        }

    ]};
