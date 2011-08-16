Inprint.calendar.templates.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.url  = _source("fascicle.list");
        this.tbar = Inprint.calendar.templates.Toolbar(this);

        this.store = Inprint.createJsonStore()
            .setSource("template.list")
            .addField("edition")
            .addField("edition_shortcut")
            .addField("shortcut")
            .addField("description")
            .addField("created")
            .addField("updated")
            .create();

        this.columns = [
            Inprint.getColumn("edition"),
            Inprint.getColumn("shortcut"),
            Inprint.getColumn("description"),
            Inprint.getColumn("created"),
            Inprint.getColumn("updated"),
        ];

        Ext.apply(this, {
            border: false,
            disabled: true
        });

        Inprint.calendar.templates.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.templates.Grid.superclass.onRender.apply(this, arguments);
    },

    cmpCreateWindow: function(width, height, form, title, btns) {
        return new Ext.Window({
            modal: true,
            layout: "fit",
            closeAction: "hide",
            width: width,
            height: height,
            title: title,
            items: form,
            buttons: btns,
            plain: true,
            bodyStyle:'padding:5px 5px 5px 5px'
        });
    },

    /* -------------- */

    cmpCreateTemplate: function() {

        var form = new Inprint.calendar.templates.Create({
            parent: this,
            url: _source("fascicle.create")
        });

        form.cmpSetValue("edition", this.currentEdition);

        var wndw = this.cmpCreateWindow(
            400, 200,
            form, _("New issue"),
            [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
        ).show();

        form.on('actioncomplete', function(form, action) {
            if (action.type == "submit") {
                wndw.close();
                this.cmpReloadWithMenu();
            }
        }, this);

    }

});
