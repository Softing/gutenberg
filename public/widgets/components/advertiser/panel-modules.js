Inprint.cmp.adverta.Modules = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
        this.panels = {};
        
        this.panels["modules"] = new Inprint.cmp.adverta.GridModules({
            parent: this.parent
        });
        
        this.panels["templates"] = new Inprint.cmp.adverta.GridTemplates({
            parent: this.parent
        });
        
        Ext.apply(this, {
            border:false,
            flex:2,
            margins: "0 3 0 3",
            layout: "border",
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                this.panels["modules"],
                this.panels["templates"]
            ]
        });

        Inprint.cmp.adverta.Modules.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.adverta.Modules.superclass.onRender.apply(this, arguments);
        
        var modules = this.panels["modules"];
        
        modules.on("rowcontextmenu", function(grid, rindex, e) {
            e.stopEvent();
            var items = [];
            items.push({
                icon: _ico("minus-button"),
                cls: "x-btn-text-icon",
                text: _("Remove"),
                ref: "../btnRemove",
                scope:this,
                handler: this.cmpDelete
            });
            var coords = e.getXY();
            new Ext.menu.Menu({ items : items }).showAt([coords[0], coords[1]]);
        }, modules);
        
        modules.on("afterrender", function() {
            
            new Ext.dd.DropTarget(modules.getView().scroller.dom, {
                
                ddGroup    : 'principals-selector',
                notifyDrop : function(ddSource, e, data){
                    
                    var ids = [];
                    
                    Ext.each(ddSource.dragData.selections, function(r) {
                        ids.push(r.data.id);
                    });
                    
                    Ext.Ajax.request({
                        url: _url("/fascicle/modules/create/"),
                        scope:this,
                        success: function() {
                            flash.cmpInit();
                            modules.cmpReload();
                        },
                        params: {
                            fascicle: parent.fascicle,
                            page: parent.selection,
                            module: ids
                        }
                    });
                    
                    return true;
                }
                
            });
            
        }, this);
        
    }
    
});
