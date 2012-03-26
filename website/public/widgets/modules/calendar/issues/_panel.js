"use strict";

Inprint.calendar.issues.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.access = {};

        this.panels = {};
        this.panels.issues = new Inprint.calendar.issues.Issues();
        this.panels.attachments = new Inprint.calendar.issues.Attachments();

        Ext.apply(this, {

            layout: "border",

            items: [
                this.panels.issues,
                this.panels.attachments
            ]
        });

        Inprint.calendar.issues.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.issues.Main.superclass.onRender.apply(this, arguments);
        Inprint.calendar.issues.Interaction(this, this.panels);
    },

    cmpReload: function() {
        this.panels.issues.cmpReload();
    }

});
