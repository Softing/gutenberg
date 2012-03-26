"use strict";

Inprint.calendar.archive.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.access = {};

        this.panels = {};
        this.panels.issues = new Inprint.calendar.archive.Issues();
        this.panels.attachments = new Inprint.calendar.archive.Attachments();

        Ext.apply(this, {

            layout: "border",

            items: [
                this.panels.issues,
                this.panels.attachments
            ]
        });

        Inprint.calendar.archive.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.archive.Main.superclass.onRender.apply(this, arguments);
        Inprint.calendar.archive.Interaction(this, this.panels);
    },

    cmpReload: function() {
        this.panels.issues.cmpReload();
    }

});
