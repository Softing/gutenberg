Inprint.fascicle.plan.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.fascicle = this.oid;

        this.panels = {
            pages: new Inprint.fascicle.planner.Pages({
                parent: this,
                oid: this.oid
            })
        };

        this.tbar = [
            "->",
            {
                text: _("Fascicle") + "/A4",
                icon: _ico("printer"),
                cls: 'x-btn-text-icon',
                scope:this,
                handler: function() {
                    window.location = "/fascicle/print/"+ this.oid +"/landscape/a4";
                }
            },
            {
                text: _("Fascicle") + "/A3",
                icon: _ico("printer"),
                cls: 'x-btn-text-icon',
                scope:this,
                handler: function() {
                    window.location = "/fascicle/print/"+ this.oid +"/landscape/a3";
                }
            },
            {
                text: _("Advertising"),
                icon: _ico("printer"),
                cls: 'x-btn-text-icon',
                scope:this,
                handler: function() {
                    window.location = "/reports/advertising/fascicle/"+ this.oid;
                }
            }
        ];

        Ext.apply(this, {
            layout: 'fit',
            autoScroll:true,
            items: this.panels.pages
        });

        Inprint.fascicle.plan.Panel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.plan.Panel.superclass.onRender.apply(this, arguments);

        this.cmpInitSession();

    },

    cmpInitSession: function () {
        this.body.mask("Обновление данных...");
        Ext.Ajax.request({
            url: _url("/fascicle/seance/"),
            scope: this,
            params: {
                fascicle: this.oid
            },
            callback: function() {
                this.body.unmask();
            },
            success: function(response) {

                var rsp = Ext.util.JSON.decode(response.responseText);

                var access      = rsp.data.access;
                var fascicle    = rsp.data.fascicle;
                var summary     = rsp.data.summary;

                var advertising = rsp.data.advertising;
                var composition = rsp.data.composition;
                var documents   = rsp.data.documents;
                var requests    = rsp.data.requests;

                var shortcut = rsp.data.fascicle.shortcut;
                var description = "";

                if (access.manager) {
                    description += '&nbsp;[<b>Работает '+ access.manager_shortcut +'</b>]';
                }

                description += '&nbsp;[Полос&nbsp;'+ summary.pc +'='+ summary.dc +'+'+ summary.ac;
                description += '&nbsp;|&nbsp;'+ summary.dav +'%/'+ summary.aav +'%]';
                var title = Inprint.ObjectResolver.makeTitle(this.parent.aid, this.parent.oid, null, this.parent.icon, shortcut, description);
                this.parent.setTitle(title);

                if (composition) { this.panels.pages       .getStore().loadData({ data: composition }); }

            }
        });
    },

    cmpReload: function() {
        this.cmpInitSession();
    }

});

Inprint.registry.register("fascicle-plan", {
    icon: "table",
    text: _("Fascicle plan"),
    xobject: Inprint.fascicle.plan.Panel
});
