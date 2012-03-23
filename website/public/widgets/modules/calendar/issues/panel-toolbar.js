Inprint.calendar.issues.Toolbar = function (scope) {
    return [

        {
            text: 'Выпуски',
            icon: _ico("blue-folders"),
            menu: {
                items: [
                    Inprint.fx.btn.Create(Inprint.calendar.actions.fascicleCreate.createDelegate(scope)),
                    Inprint.fx.btn.Edit(Inprint.calendar.actions.fascicleUpdate.createDelegate(scope)),
                    "-",
                    Inprint.fx.btn.Delete(Inprint.calendar.actions.remove.createDelegate(scope)),
                ]
            }
        },

        {
            text: 'Вкладки',
            icon: _ico("folders"),
            menu: {
                items: [
                    Inprint.fx.btn.Create(Inprint.calendar.actions.attachmentCreate.createDelegate(scope)),
                    Inprint.fx.btn.Edit(Inprint.calendar.actions.attachmentUpdate.createDelegate(scope)),
                    "-",
                    Inprint.fx.btn.Delete(Inprint.calendar.actions.remove.createDelegate(scope)),
                ]
            }
        },

        "-",

        Inprint.fx.Button(false, "Open Plan", "", "layout-hf-2", Inprint.calendar.actions.remove.createDelegate(scope)).render(),
        Inprint.fx.Button(false, "Open Composer", "", "layout-design", Inprint.calendar.actions.remove.createDelegate(scope)).render(),

        "-",
        Inprint.fx.Button(false, "Pause", "", "control-pause", Inprint.calendar.actions.disable.createDelegate(scope)).render(),
        Inprint.fx.Button(false, "Enable", "", "control", Inprint.calendar.actions.enable.createDelegate(scope)).render(),

        "-",
        Inprint.fx.btn.Copy(Inprint.calendar.actions.copy.createDelegate(scope)),
        Inprint.fx.Button(false, "Properties", "", "property", Inprint.calendar.actions.properties.createDelegate(scope)).render(),
        Inprint.fx.Button(false, "Move to Archive", "", "blue-folder-zipper", Inprint.calendar.actions.archive.createDelegate(scope)).render(),

        "-",
        Inprint.fx.Button(false, "Format", "", "cross-circle", Inprint.calendar.actions.format.createDelegate(scope)).render(),

        "->" ,
        {
            name: "edition",
            xtype: "treecombo",
            minListWidth: 300,
            rootVisible:true,
            fieldLabel: _("Edition"),
            emptyText: _("Edition") + "...",
            url: _url('/common/tree/editions/'),
            baseParams: { term: 'editions.documents.work:*' },
            root: {
                id: "00000000-0000-0000-0000-000000000000",
                expanded: true,
                draggable: false,
                icon: _ico("book"),
                text: _("All editions")
            },
            listeners: {
                select: function(combo, record) {
                    scope.cmpLoad({
                        archive: "false",
                        fastype: "issue",
                        edition: record.id
                    });
                    scope.enable();
                }
            }
        }

    ];
}
