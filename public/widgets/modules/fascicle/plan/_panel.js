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
                text: 'Печать А4',
                icon: _ico("printer"),
                cls: 'x-btn-text-icon',
                scope:this, 
                handler: function() {
                    window.location = '/fascicle/pages/print/?fascicle='+ this.fascicle +'&mode=landscape&size=a4';
                }
            },
            {
                text: 'Печать А3',
                icon: _ico("printer"),
                cls: 'x-btn-text-icon',
                scope:this, 
                handler: function() {
                    window.location = '/fascicle/pages/print/?fascicle='+ this.fascicle +'&mode=landscape&size=a3';
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
                
                var rsp = Ext.util.JSON.decode(response.responseText)
                
                this.version = rsp.fascicle.version;
                this.manager = rsp.fascicle.manager;
                
                var shortcut = rsp.fascicle.shortcut;
                var description = "";
                
                if (rsp.fascicle.manager) {
                    description += '&nbsp;[<b>Работает '+ rsp.fascicle.manager_shortcut +'</b>]';
                }
                
                description += '&nbsp;[Полос&nbsp;'+ rsp.fascicle.pc +'='+ rsp.fascicle.dc +'+'+ rsp.fascicle.ac;
                description += '&nbsp;|&nbsp;'+ rsp.fascicle.dav +'%/'+ rsp.fascicle.aav +'%]';
                
                var title = Inprint.ObjectResolver.makeTitle(this.parent.oid, this.parent.aid, this.parent.icon, shortcut, description);
                this.parent.setTitle(title)
                
                this.panels.pages.getStore().loadData({ data: rsp.pages });
                
                //this.panels["documents"].getStore().loadData({ data: rsp.documents });
                //this.panels["summary"].getStore().loadData({ data: rsp.summary });
                //Inprint.fascicle.planner.Access(this, this.panels, rsp.fascicle.access);
                //this.cmpCheckSession.defer( 50000, this);
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