Inprint.cmp.Composer = Ext.extend(Ext.Window, {

    initComponent: function() {

        if (!this.urls) {
            this.urls = {
                "flashInit":     _url("/fascicle/composer/initialize/"),
                "flashSave":     _url("/fascicle/composer/save/"),
                "templatesList": "/fascicle/composer/templates/",
                "modulesList":   "/fascicle/composer/modules/",
                "modulesCreate": _url("/fascicle/modules/create/"),
                "modulesDelete": _url("/fascicle/modules/delete/")
            };
        }

        this.panels = {};

        this.selLength = this.selection.length;

        this.panels.modules = new Inprint.cmp.composer.Modules({
            parent: this
        });

        this.panels.templates = new Inprint.cmp.composer.Templates({
            parent: this
        });

        this.panels.flash   = new Inprint.cmp.composer.Flash({
            parent: this
        });

        Ext.apply(this, {

            border:false,

            modal:true,
            layout: "border",
            closeAction: "hide",
            title: _("Разметка полос"),

            width: 430 + (this.selLength*260),
            height:600,

            defaults: {
                collapsible: false,
                split: true
            },

            items: [
                {
                    border:false,
                    region: "center",
                    layout: "border",
                    defaults: {
                        collapsible: false,
                        split: true
                    },
                    items: [
                        this.panels.modules,
                        this.panels.templates
                    ]
                },
                this.panels.flash
            ],
            buttons: [
                {
                    text: _("Save"),
                    scope:this,
                    handler: this.cmpSave
                },
                {
                    text: _("Close"),
                    scope:this,
                    handler: function() {
                        this.hide();
                    }
                }
            ]

        });

        Inprint.cmp.Composer.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.Composer.superclass.onRender.apply(this, arguments);
        Inprint.cmp.composer.Interaction(this, this.panels);
    },

    setUrls: function (urls) {
        this.urls = urls;
    },

    cmpSave: function() {
        this.panels.flash.cmpSave();
    }

});
