//Inprint.calendar.issues.Toolbar = function (scope) {
//
//    return [
//        {
//            xtype: 'buttongroup',
//            title: _('Create'),
//            columns: 2,
//            defaults: {
//                scale: 'small'
//            },
//            items: [
//                Inprint.fx.Button(true, "Issue", "", "blue-folder", Inprint.calendar.actions.fascicleCreate.createDelegate(scope)).ref("../../btnCreate").render()
//            ]
//        },
//
//        {
//            xtype: 'buttongroup',
//            title: _('Production cycle'),
//            columns: 3,
//            defaults: {
//                scale: 'small'
//            },
//            items: [
//                Inprint.fx.Button(true, "Approval", "", "arrow-join", Inprint.calendar.actions.statusApproval.createDelegate(scope)).ref("../../btnDoApproval").render(),
//                Inprint.fx.Button(true, "Working", "", "arrow", Inprint.calendar.actions.statusWork.createDelegate(scope)).ref("../../btnDoWorking").render(),
//                Inprint.fx.Button(true, "Archive", "", "arrow-stop", Inprint.calendar.actions.archive.createDelegate(scope)).ref("../../btnDoArchive").render()
//            ]
//        },
//
//        {
//            xtype: 'buttongroup',
//            title: _('Tools'),
//            columns: 6,
//            defaults: { scale: 'small' },
//            items: [
//                Inprint.fx.Button(true, "Pause", "", "control-pause", Inprint.calendar.actions.disable.createDelegate(scope)).ref("../../btnDisable").render(),
//                Inprint.fx.Button(true, "Enable", "", "control", Inprint.calendar.actions.enable.createDelegate(scope)).ref("../../btnEnable").render(),
//                Inprint.fx.Button(true, "Format", "", "puzzle", Inprint.calendar.actions.format.createDelegate(scope)).ref("../../btnFormat").render()
//            ]
//        }
//
//    ]};
