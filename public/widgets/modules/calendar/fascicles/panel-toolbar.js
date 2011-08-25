Inprint.calendar.fascicles.Toolbar = function (scope) {

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
                    text: _("Issue"),
                    ref: "../../btnCreate",
                    cls: 'x-btn-text-icon',
                    icon: _ico("blue-folder"),
                    scope: scope,
                    handler: scope.cmpCreateFascicle
                }
            ]
        },

        {
            xtype: 'buttongroup',
            title: _('Production cycle'),
            columns: 3,
            defaults: {
                scale: 'small'
            },
            items: [
                {
                    id: 'doApproval',
                    disabled: true,
                    text: _("Approval"),
                    ref: "../../btnDoApproval",
                    cls: 'x-btn-text-icon',
                    icon: _ico("arrow-join"),
                    scope: scope,
                    handler: scope.cmpDoApproval
                },
                {
                    id: 'doWorking',
                    disabled: true,
                    text: _("Working"),
                    ref: "../../btnDoWorking",
                    cls: 'x-btn-text-icon',
                    icon: _ico("arrow"),
                    scope: scope,
                    handler: scope.cmpDoWorking
                },
                {
                    id: 'doArchive',
                    disabled: true,
                    text: _("Archive"),
                    ref: "../../btnDoArchive",
                    cls: 'x-btn-text-icon',
                    icon: _ico("arrow-stop"),
                    scope: scope,
                    handler: scope.cmpDoArchive
                }
            ]
        },

        {
            xtype: 'buttongroup',
            title: _('Tools'),
            columns: 6,
            defaults: {
                scale: 'small'
            },
            items: [
                //{
                //    id: "disable",
                //    disabled: true,
                //    ref: "../../btnDisable",
                //    icon: _ico("control-pause"),
                //    cls: 'x-btn-text-icon',
                //    text    : _('Pause'),
                //    scope: scope,
                //    handler : scope.cmpDisable
                //},
                //{
                //    id: "enable",
                //    disabled: true,
                //    ref: "../../btnEnable",
                //    icon: _ico("control"),
                //    cls: 'x-btn-text-icon',
                //    text    : _('Enable'),
                //    scope: scope,
                //    handler : scope.cmpEnable
                //},
                {
                    id: 'format',
                    disabled: true,
                    text: _("Format"),
                    ref: "../../btnFormat",
                    icon: _ico("puzzle"),
                    cls: 'x-btn-text-icon',
                    scope: scope,
                    handler: scope.cmpFormat
                }
                //{
                //    id: 'print',
                //    disabled: false,
                //    text: _("Production calendar"),
                //    ref: "../../btnPrintCalendar",
                //    icon: _ico("printer"),
                //    cls: 'x-btn-text-icon',
                //    scope: scope,
                //    handler: scope.cmpPrintCalendar
                //}
            ]
        }

    ]};
