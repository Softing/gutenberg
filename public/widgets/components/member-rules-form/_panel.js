Inprint.cmp.memberRulesForm.Window = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.panels = {};

        this.panels.domain = new Inprint.cmp.memberRulesForm.Domain({
            memberId: this.memberId
        });

        this.panels.editions = new Inprint.cmp.memberRulesForm.Editions({
            memberId: this.memberId
        });

        this.panels.organization = new Inprint.cmp.memberRulesForm.Organization({
            memberId: this.memberId
        });

        this.panels.tabs = new Ext.TabPanel({
            border:false,
            activeTab: 0,
            items:[
                this.panels.domain,
                this.panels.editions,
                this.panels.organization
            ],
            tbar: [{
                icon: _ico("disk-black"),
                cls: "x-btn-text-icon",
                text: _("Save"),
                ref: "../btnSave",
                scope:this,
                handler: function() {
                    this.panels.tabs.getActiveTab().cmpSave();
                }
            }]
        });

        this.tools = [{
            id: "refresh",
            scope:this,
            handler: function() {
                this.panels.tabs.getActiveTab().cmpReload();
            }
        }];

        Ext.apply(this, {
            title: _("Access rights management"),
            layout: "fit",
            modal:true,
            width:800, height:400,
            items: this.panels.tabs
        });

        Inprint.cmp.memberRulesForm.Window.superclass.initComponent.apply(this, arguments);
        Inprint.cmp.memberRulesForm.Interaction(this, this.panels);
    },

    onRender: function() {
        Inprint.cmp.memberRulesForm.Window.superclass.onRender.apply(this, arguments);
    }

});
