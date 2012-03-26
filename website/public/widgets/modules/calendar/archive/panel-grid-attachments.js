"use strict";

Inprint.calendar.archive.Attachments = Ext.extend(Inprint.grid.GridPanel, {

    initComponent: function() {

        this.access = {};

        this.tbar = [
            Inprint.fx.btn.Button("../btnOpenPlan", "layout-hf-2", "Open Plan", "", Inprint.calendar.ViewPlanAction.createDelegate(this)),
            "-",
            Inprint.fx.btn.Copy("../btnCopy", Inprint.calendar.CopyAttachmentAction.createDelegate(this))
        ]

        this.store = Inprint.createJsonStore()
            .setSource("attachment.list")
            .setAutoLoad(false)
            .setParams({ edition: "00000000-0000-0000-0000-000000000000", fastype: "attachment", archive: true })
                .addField("id")
                .addField("fastype")
                .addField("enabled")
                .addField("edition")
                .addField("edition_shortcut")
                .addField("shortcut")
                .addField("description")
                .addField("adv_date")
                .addField("print_date")
                .addField("doc_date")
                .addField("release_date")
                .addField("num")
                .addField("anum")
                .addField("tmpl")
                .addField("tmpl_shortcut")
                .addField("circulation")
                .addField("created")
                .addField("updated")
                    .create();

        this.columns = [
            Inprint.calendar.ux.columns.icon,
            Inprint.calendar.ux.columns.status,
            Inprint.calendar.ux.columns.edition,
            Inprint.calendar.ux.columns.shortcut,

            Inprint.calendar.ux.columns.num,
            Inprint.calendar.ux.columns.template,
            Inprint.calendar.ux.columns.circulation,

            Inprint.calendar.ux.columns.docdate,
            Inprint.calendar.ux.columns.advdate,
            Inprint.calendar.ux.columns.releasedate,
            Inprint.calendar.ux.columns.printdate,

            Inprint.calendar.ux.columns.created,
            Inprint.calendar.ux.columns.updated
        ];

        Ext.apply(this, {
            layout:"fit",
            region:"south",
            split:true,
            //collapsible: true,
            //collapseMode: 'mini',
            height: 300,
            minSize: 100,
            maxSize: 600,

            disabled:true
        });

        Inprint.calendar.archive.Attachments.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.archive.Attachments.superclass.onRender.apply(this, arguments);
    }

});
