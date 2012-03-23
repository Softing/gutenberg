Inprint.registry.register("calendar-issues", {
    icon: "blue-folders",
    text:  _("Working issues"),
    xobject: Inprint.calendar.issues.Main
});

Inprint.registry.register("calendar-archive", {
    icon: "calendar-search-result",
    text:  _("Archive of issues"),
    xobject: Inprint.calendar.archive.Main
});

Inprint.registry.register("calendar-templates", {
    icon: "puzzle",
    text:  _("Templates of issues"),
    xobject: Inprint.calendar.templates.Main
});
