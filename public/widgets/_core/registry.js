/*
 * Inprint Content 4.5
 * Copyright(c) 2001-2010, Softing, LLC.
 * licensing@softing.ru
 *
 * http://softing.ru/license
 */

Inprint.Registry = function() {

    var registr = {

        "core": {
            icon: "target",
            text: _("Inprint")
        },
        "core-help": {
            icon: "lifebuoy",
            text: _("Help"),
            tooltip: "Help center",
            object: Inprint.Help
        },
        "core-about": {
            icon: "information",
            text: _("About"),
            handler: Inprint.About
        },
        "core-logs": {
            icon: "lifebuoy",
            text: _("Logs"),
            xobject: Inprint.system.logs.Panel
        },

        "portal": {
            icon: "home",
            text: _("Portal"),
            handler: function() {
                Inprint.layout.getPanel().layout.setActiveItem(0);
            }
        },

        "document-profile": {
            icon: "document--pencil",
            text: _("Document profile")
        },

        "documents": {
            icon: "document-word",
            text: _("Documents")
        },

        "documents-create": {
            modal: false,
            icon: "plus-button",
            text:  _("Create document"),
            menutext:  _("Create"),
            handler: function() {
                new Inprint.cmp.CreateDocumentWindow().show();
            }
        },
        "documents-todo": {
            icon: "document-share",
            text:  _("Todo"),
            xobject: Inprint.documents.todo.Panel
        },
        "documents-all": {
            icon: "documents-stack",
            text:  _("All"),
            xobject: Inprint.documents.all.Panel
        },
        "documents-briefcase": {
            icon: "briefcase",
            text:  _("Briefcase"),
            xobject: Inprint.documents.briefcase.Panel
        },
        "documents-archive": {
            icon: "folders-stack",
            text:  _("Archive"),
            xobject: Inprint.documents.archive.Panel
        },
        "documents-recycle": {
            icon: "bin",
            text:  _("Recycle"),
            xobject: Inprint.documents.recycle.Panel
        },

        "composition": {
            icon: "newspapers",
            text:  _("Composition")
        },
        "composition-calendar": {
            icon: "calendar-day",
            text:  _("Calendar"),
            xobject: Inprint.edition.calendar.Panel
        },
        "composition-archive": {
            icon: "folders-stack",
            text:  _("Archive"),
            xobject: Inprint.edition.archive.Panel
        },

        "fascicle": {
            icon: "table",
            text: _("Unknown fascicle")
        },
        "fascicle-plan": {
            icon: "table",
            text: _("Plan"),
            xobject: Inprint.fascicle.plan.Panel
        },
        "fascicle-planner": {
            icon: "clock",
            text: _("Planning"),
            xobject: Inprint.fascicle.planner.Panel
        },
        "fascicle-advert": {
            icon: "currency",
            text: _("Advertising"),
            xobject: Inprint.fascicle.advert.Panel
        },
        "fascicle-catchword": {
            icon: "block",
            text: _("Rubrics"),
            xobject: Inprint.fascicle.catchword.Panel
        },

        "settings": {
            icon: "switch",
            text: _("Settings")
        },
        "settings-organization": {
            icon: "building",
            text: _("Organization"),
            xobject: Inprint.catalog.organization.Panel
        },
        "settings-editions": {
            icon: "books",
            text: _("Editions"),
            xobject: Inprint.catalog.editions.Panel
        },
        "settings-roles": {
            icon: "user-silhouette",
            text: _("Roles"),
            xobject: Inprint.catalog.roles.Panel
        },
        "settings-readiness": {
            icon: "category",
            text: _("Readiness"),
            xobject: Inprint.catalog.readiness.Panel
        },


        "employee": {
            icon: "dummy",
            text: _("Employee")
        },
        "employee-card": {
            icon: "card",
            text: _("Card"),
            handler: function () {
                new Inprint.cmp.memberProfileForm.Window().show().cmpFill("self");
            }
        },
        "employee-settings": {
            icon: "wrench",
            text: _("Settings"),
            handler: function () {
                new Inprint.cmp.memberSettingsForm.Window().show().cmpFill("self");
            }
        },
        "employee-access": {
            icon: "key",
            text: _("Access"),
            handler: function() {
                new Inprint.cmp.memberRules().show();
            }
        },
        "employee-logs": {
            icon: "card-address",
            text: _("Logs"),
            xobject: Inprint.employee.logs.Panel
        },
        "employee-logout": {
            icon: "door-open",
            text: _("Logout"),
            handler: Inprint.Logout
        }
    };

    for(var k in registr){
        if (registr[k]['xobject']) {
            Ext.reg(k, registr[k]['xobject']);
        }
    }

    return registr;
};
