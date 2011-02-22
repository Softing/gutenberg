Inprint.cmp.composer.Modules = Ext.extend(Ext.ux.tree.TreeGrid, {

    initComponent: function() {

        this.params = {};
        this.components = {};

        this.urls = {
            "list":        "/fascicle/composer/modules/",
            "create": _url("/fascicle/modules/create/"),
            "delete": _url("/fascicle/modules/delete/")
        };

        this.columns = [
            {
                id:"title",
                width: 130,
                header: _("Title"),
                dataIndex: "title"
            },
            {
                id:"place_title",
                width: 100,
                header: _("Place"),
                dataIndex: "place_title"
            },
            {
                id:"amount",
                width: 80,
                header: _("Amount"),
                dataIndex: "amount"
            }
        ];

        this.loader  = new Ext.tree.TreeLoader({
            dataUrl: this.urls.list,
            baseParams: {
                page: this.parent.selection
            }
        });

        Ext.apply(this, {

            title: _("Modules"),

            enableDragDrop: true,
            ddGroup: 'principals-selector',

            layout:"fit",
            region: "center"

        });

        Inprint.cmp.composer.Modules.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.composer.Modules.superclass.onRender.apply(this, arguments);
    },

    cmpGetSelectedNode: function() {
        return this.getSelectionModel().getSelectedNode();
    },

    cmpReload: function() {
        this.getRootNode().reload();
    },

    cmpDelete: function() {
        Ext.MessageBox.confirm(
            _("Warning"),
            _("You really wish to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls["delete"],
                        scope:this,
                        success: function() {
                            this.cmpReload();
                            this.parent.panels.flash.cmpInit();
                        },
                        params: {
                            id: this.cmpGetSelectedNode().attributes.module
                        }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }

});
