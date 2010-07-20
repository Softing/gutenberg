/*
 * Inprint Content 4.5
 * Copyright(c) 2001-2010, Softing, LLC.
 * licensing@softing.ru
 * 
 * http://softing.ru/license
 */

Inprint.ObjectResolver = function() {
    
    // Хранилище объектов
    var objectHash = {};
    var objectStore = [];
    
    return {
        
        resolve: function(item) {
            
            if (!Inprint.registry[item.aid]) {
                return;
            }
            
            item.icon        = Inprint.registry[item.aid].icon;
            item.modal       = Inprint.registry[item.aid].modal;
            item.text        = item.text        || Inprint.registry[item.aid].text;
            item.description = item.description || Inprint.registry[item.aid].description;
            
            item.icon = _ico(item.icon);
            
            var panelId = item.aid || Ext.id();
            
            if (Inprint.registry[item.aid].modal == false) {
                panelId = Ext.id();
            }
            
            if (item.oid) {
                panelId += "-" + item.oid;
            }
            
            var panel = objectHash[panelId];
            if (!panel) {
                panel = this.create(item, panelId);
            }
            
            this.show(panel);
        },
        
        // Создаем новую панель
        create: function(item, panelId){
            
            var config = {
                panelId: panelId,
                layout: "fit",
                border:false,
                title: _("Unnamed window"),
                icon: "/icon/layout.png"
            };
            
            if (item.icon) {
                config.icon = item.icon;
            }
            
            config.title = "<div style=\"padding-left:21px;background:url(" + config.icon + ") 0px -2px no-repeat;\">";
            config.title += item.text;
            config.title += "&nbsp;<a href=\"?aid="+ item.aid +"";
            
            if (item.oid) {
                config.title += "&oid=" + item.oid;
            }
            
            if (item.description) {
                config.title += "&description=" + item.description;
            }
            
            config.title += "\" onClick=\"return false;\">[#]</a>";
            
            if (item.description) {
                config.title += "&nbsp;-&nbsp;" + item.description;
            }
            
            config.title += "</div>";
            
            var tools = [];
            tools.push({
                id: "refresh",
                qtip: _("Refresh this panel"),
                scope: this,
                handler: function(event, toolEl, panel) {
                    this.reload(panel);
                }
            });
            tools.push({
                id: "close",
                qtip: _("Close this panel"),
                scope: this,
                handler: function(event, toolEl, panel) {
                    this.remove(panel);
                }
            });
            
            config.tools = tools;
            
            if (Inprint.registry[item.aid]["object"]) {
                config.items = new Inprint.registry[item.aid]["object"]();
            }
            else if (Inprint.registry[item.aid]["xobject"]) {
                config.items = { xtype: item.aid };
            } else {
                config.items = new Ext.Panel({
                    html:"<h1>" + _("Not implemented") + "</h1>"
                });
            }
            
            var panel = new Ext.Panel(config);
            
            // Регистрируем панель
            
            Inprint.layout.getPanel().add(panel);
            panel.taskBtn = Inprint.layout.getTaskbar().addButton({
                panel: panel,
                icon:  panel.icon,
                text:  item.text,
                description: item.description
            });
            panel.taskBtn.toggle();
            
            objectHash[panelId] = panel;
            objectStore.push(panel);
            
            return panel;
        
        },
        
        show: function(panel) {
            if (panel) {
                Inprint.layout.getPanel().layout.setActiveItem(panel);
                Inprint.layout.getPanel().doLayout();
                Inprint.layout.getViewport().doLayout();
            }
        },
        
        hide: function(panel) {
            if (panel) {
                Inprint.layout.getPanel().layout.setActiveItem(0);
            }
        },
        
        // Обновляем содержимое панели
        reload: function(panel) {
            if (panel.items.first()) {
                if (panel.items.first().cmpReload) {
                    panel.items.first().cmpReload();
                }
            }
        },
        
        remove: function(panel){
            
            if (panel.taskBtn) {
                Inprint.layout.getTaskbar().remove(panel.taskBtn);
            }
            
            for (var i = 0, len = objectStore.length; i < len; i++){
                
                if (objectStore[i] == panel) {
                    
                    objectHash[objectStore[i].panelId] = false;
                    objectStore.splice(i, 1);
                    
                    if (objectStore[ i ]) {
                        this.show(objectStore[ i ]);
                    }
                    else {
                        this.show(objectStore[ i - 1 ]);
                    }
                }
            }
            
            if (objectStore.length == 0) {
                Inprint.layout.getPanel().layout.setActiveItem(0);
            }
            
            Inprint.layout.getPanel().remove(panel);
            Inprint.layout.getPanel().doLayout();
        }
    }
}();
