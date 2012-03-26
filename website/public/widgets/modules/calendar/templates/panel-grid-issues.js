"use strict";

Inprint.calendar.templates.Issues = Ext.extend(Inprint.grid.GridPanel, {

    initComponent: function() {

        this.access = {};

        this.tbar = [

            Inprint.fx.btn.Create("../btnCreate", Inprint.calendar.CreateTemplateAction.createDelegate(this)),
            Inprint.fx.btn.Update("../btnUpdate", Inprint.calendar.UpdateTemplateAction.createDelegate(this)),
            Inprint.fx.btn.Delete("../btnDelete", Inprint.calendar.DeleteTemplateAction.createDelegate(this)),

            "-",
            Inprint.fx.btn.Button("../btnOpenComposer", "layout-design", "Open Composer", "", Inprint.calendar.TemplateComposerAction.createDelegate(this)),

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
                    scope:this,
                    select: function(combo, record) {
                        this.cmpLoad({ edition: record.id });
                        this.enable();
                    }
                }
            }

        ];

        this.store = Inprint.createJsonStore()
            .setSource("template.list")
            .setAutoLoad(true)
            .setParams({ edition: "00000000-0000-0000-0000-000000000000", fastype: "template", archive: false })
                .addField("id")
                .addField("fastype")
                .addField("edition")
                .addField("edition_shortcut")
                .addField("shortcut")
                .addField("description")
                .addField("created")
                .addField("updated")
                    .create();

        this.columns = [
            Inprint.calendar.ux.columns.icon,
            Inprint.calendar.ux.columns.edition,
            Inprint.calendar.ux.columns.shortcut,
            Inprint.calendar.ux.columns.created,
            Inprint.calendar.ux.columns.updated
        ];

        Ext.apply(this, {
            layout:"fit",
            region: "center",
            split:true
        });

        Inprint.calendar.templates.Issues.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.templates.Issues.superclass.onRender.apply(this, arguments);
    }

});
