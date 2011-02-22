Inprint.system.settings.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {
        Ext.apply(this, {
            autoScroll: true,
            bodyCssClass: "inprint-system-settings-panel"
        });
        Inprint.system.settings.Panel.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.system.settings.Panel.superclass.onRender.apply(this, arguments);
        this.cmpReload();
    },

    cmpReload: function() {

        this.body.mask(_("Loading") + "...");

        Ext.Ajax.request({
            url: _url("/system/settings/get/"),
            scope: this,
            callback: function(responce) {
                this.body.unmask();
            },
            success: function(responce) {

                var data = Ext.decode(responce.responseText);

                var tpl = new Ext.XTemplate(
                        '<tpl for=".">',
                        '<div><h1>{[this.tr(values["title"])]}</h1>',
                        '<table><tpl for="params">',
                        '<tr><td>{[this.tr(values["name"])]}</td><td>{[this.tr(values["value"])]}</td></tr>',
                        '</tpl></table>',
                        '</div></tpl>', {

                    tr: function(str) {
                        return _(str);
                    }

                });

                if (data.data) {
                    this.body.update("");
                    tpl.append(this.body, data.data);
                }

            }
        });
    }

});
