// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.ObjectResolver = function() {

    // Хранилище объектов
    var objectHash = {};
    var objectStore = [];

    return {

        resolve: function(item) {

            if (!Inprint.registry[item.aid]) {
                alert("Can't find Inprint.registry for item.aid");
                return;
            }

            if (Inprint.registry[item.aid].xaction) {
                Inprint.registry[item.aid].xaction();
                return;
            }

            item.icon        = Inprint.registry[item.aid].icon;
            item.modal       = Inprint.registry[item.aid].modal;
            item.text        = item.text        || Inprint.registry[item.aid].text;
            item.description = item.description || Inprint.registry[item.aid].description;

            item.icon = _ico(item.icon);

            var panelId = item.aid || Ext.id();

            if (Inprint.registry[item.aid].modal === false) {
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

            if (item.aid)  { config.aid = item.aid; }
            if (item.oid)  { config.oid = item.oid; }
            if (item.pid)  { config.pid = item.pid; }

            if (item.icon) { config.icon = item.icon; }

            config.title = this.makeTitle(config.aid, config.oid, config.pid, config.icon, item.text, item.description);

            // Create panel Tools
            var tools = [
                {
                    id: "refresh",
                    qtip: _("Reload this panel"),
                    scope: this,
                    handler: function(event, toolEl, panel) {
                        this.reload(panel);
                    }
                },
                {
                    id: "close",
                    qtip: _("Close this panel"),
                    scope: this,
                    handler: function(event, toolEl, panel) {
                        this.remove(panel);
                    }
                }
            ];

            config.tools = tools;
            var xobject = Inprint.registry[item.aid].xobject;
            if (xobject && typeof(xobject) == "function") {
                config.items = { xtype: config.aid, oid: config.oid, pid: config.pid };
            } else {
                config.items = new Ext.Panel({
                    html:"<h1>" + _("Not implemented") + "</h1>"
                });
            }

            var panel = new Ext.Panel(config);
            panel.items.first().parent = panel;

            // Register the panel

            Inprint.layout.getPanel().add(panel);
            panel.taskBtn = Inprint.layout.getTaskbar().addButton({
                panel: panel,
                icon:  panel.icon,
                text:  Ext.util.Format.ellipsis(_(item.text), 10),
                description: item.description
            });
            panel.taskBtn.toggle();

            objectHash[panelId] = panel;
            objectStore.push(panel);

            return panel;

        },

        makeTitle: function(aid, oid, pid, icon, text, description) {

            var title = "<div style=\"padding-left:21px;background:url(" + icon + ") 0px -1px no-repeat;\">";
            title += _(text) ;
            title += "&nbsp;<a href=\"?aid="+ aid +"";

            if (oid) title += "&oid=" + oid;
            if (pid) title += "&pid=" + pid;
            if (text) title += "&text=" + text;
            if (description) title += "&description=" + description;

            title += "\" onClick=\"return false;\">[#]</a>";
            if (description) {
                title += "&nbsp;-&nbsp;" + description;
            }
            title += "</div>";

            return title;
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
                    return;
                }
            }
            return;
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

            if (objectStore.length === 0) {
                Inprint.layout.getPanel().layout.setActiveItem(0);
            }

            Inprint.layout.getPanel().remove(panel, true);
            Inprint.layout.getPanel().doLayout();
        }
    };

}();
