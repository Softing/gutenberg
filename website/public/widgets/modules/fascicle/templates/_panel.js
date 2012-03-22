Inprint.fascicle.template.composer.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.manager = null;
        this.version = null;

        this.access = {};

        this.fascicle = this.oid;

        this.panels = {
            pages: new Inprint.fascicle.template.composer.Pages({
                parent: this,
                oid: this.oid
            })
        };

        this.tbar = [
            {
                ref: "../btnPageCreate",
                disabled:true,
                text: "Добавить полосу",
                tooltip: 'Добавить новые полосы в этот выпуск',
                icon: _ico("plus-button"),
                cls: 'x-btn-text-icon',
                scope: this.panels.pages,
                handler: this.panels.pages.cmpPageCreate
            },
            {
                ref: "../btnPageUpdate",
                disabled:true,
                text:'Редактировать',
                icon: _ico("pencil"),
                cls: 'x-btn-text-icon',
                scope: this.panels.pages,
                handler: this.panels.pages.cmpPageUpdate
            },
            "-",
            {
                ref: "../btnPageMoveLeft",
                disabled:true,
                text:'Сместить влево',
                tooltip: 'Перенести отмеченные полосы',
                icon: _ico("arrow-stop-180"),
                cls: 'x-btn-text-icon',
                scope:this.panels.pages,
                handler: this.panels.pages.cmpPageMoveLeft
            },
            {
                ref: "../btnPageMoveRight",
                disabled:true,
                text:'Сместить вправо',
                tooltip: 'Перенести отмеченные полосы',
                icon: _ico("arrow-stop"),
                cls: 'x-btn-text-icon',
                scope:this.panels.pages,
                handler: this.panels.pages.cmpPageMoveRight
            },
            {
                ref: "../btnPageMove",
                disabled:true,
                text:'Перенести',
                tooltip: 'Перенести отмеченные полосы',
                icon: _ico("navigation-000-button"),
                cls: 'x-btn-text-icon',
                scope:this.panels.pages,
                handler: this.panels.pages.cmpPageMove
            },
            "-",
            {
                ref: "../btnPageDelete",
                disabled:true,
                text: 'Удалить',
                tooltip: 'Удалить полосы',
                icon: _ico("minus-button"),
                cls: 'x-btn-text-icon',
                scope:this.panels.pages,
                handler: this.panels.pages.cmpPageDelete
            }

        ];

        Ext.apply(this, {
            layout: "fit",
            autoScroll:true,
            defaults: {
                collapsible: false,
                split: true
            },
            items: this.panels.pages
        });

        Inprint.fascicle.template.composer.Panel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.template.composer.Panel.superclass.onRender.apply(this, arguments);

        Inprint.fascicle.template.composer.Context(this, this.panels);
        Inprint.fascicle.template.composer.Interaction(this, this.panels);

        this.cmpReload();

    },

    cmpReload: function() {

        this.body.mask(_("Loading..."));

        Ext.Ajax.request({

            scope: this,

            url: _url("/template/seance/"),

            params: {
                fascicle: this.oid
            },

            callback: function() {
                this.body.unmask();
            },

            success: function(response) {

                var rsp = Ext.util.JSON.decode(response.responseText);

                var shortcut    = _("Edit template");
                var description = rsp.fascicle.shortcut;

                var title = Inprint.ObjectResolver.makeTitle(
                    this.parent.aid,
                    this.parent.oid,
                    null,
                    this.parent.icon,
                    shortcut, description);

                this.access = rsp.access;

                this.parent.setTitle(title);

                this.panels.pages.getStore().loadData({ data: rsp.pages });

                Inprint.fascicle.template.composer.Access(this, this.panels, rsp.access);

            }
        });
    }

});

Inprint.registry.register("fascicle-template-composer", {
    icon: "puzzle--pencil",
    text: _("Composing template"),
    xobject: Inprint.fascicle.template.composer.Panel
});
