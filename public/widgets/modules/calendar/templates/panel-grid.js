Inprint.calendar.templates.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.url  = _source("fascicle.list");
        this.tbar = Inprint.calendar.templates.Toolbar(this);

        this.store = Inprint.createJsonStore()
            .setSource("template.list")
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

    /* -------------- */

    cmpCreateTemplate: function() {

        var form = new Inprint.calendar.templates.CreateForm();

        form.setEdition(this.currentEdition);

        form.on('actioncomplete', function(basicForm, action) {
            if (action.type == "submit") {
                this.cmpReload();
                Inprint.layout.getMenu().CmpQuery();
                form.findParentByType("window").close();
            }
        }, this);

        Inprint.createModalWindow(
            300, 170, _("New template"),
            form, [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
        ).show();

    },

    cmpUpdateTemplate: function() {

        var form = new Inprint.calendar.templates.UpdateForm();

        form.setId(this.getValue("id"));
        form.cmpFill(this.getValue("id"));

        form.on('actioncomplete', function(basicForm, action) {
            if (action.type == "submit") {
                this.cmpReload();
                Inprint.layout.getMenu().CmpQuery();
                form.findParentByType("window").close();
            }
        }, this);

        Inprint.createModalWindow(
            300, 170, _("Edit template"),
            form, [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
        ).show();

    },

    cmpRemoveTemplate: function() {

        Ext.MessageBox.show({
            scope: this,
            title: _("Important event"),
            msg: _("Delete the specified item?"),

            fn: function (btn) {
                if (btn == 'yes') {

                    Ext.Ajax.request({
                        url: _source("template.remove"),
                        params: { id: this.getValue("id") },
                        scope: this,
                        success: function() {
                            this.cmpReload();
                            Inprint.layout.getMenu().CmpQuery();
                        }
                    });

                }
            },

            buttons: Ext.Msg.YESNO,
            icon: Ext.MessageBox.WARNING
        });
    }

});
