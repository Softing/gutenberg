Inprint.cmp.adverta.GridModules = Ext.extend(Ext.ux.tree.TreeGrid, {

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
                width: 120,
                header: _("Title"),
                dataIndex: "title"
            },
            {
                id:"place_title",
                width: 90,
                header: _("Place"),
                dataIndex: "place_title",
                tpl : new Ext.XTemplate('{format:this.formatString}', {
                    formatString : function(v, record) {
                        var amount = record.amount;
                        var place  = record.place_title;
                        if (amount && place) {
                            return String.format("{0} / {1}", amount, place);
                        }
                        return "";
                    }
                })
            }
        ];

        this.loader  = new Ext.tree.TreeLoader({
            dataUrl: this.urls.list,
            baseParams: {
                page: this.parent.selection,
                filter: "unmapped, unrequested"
            }
        });

        Ext.apply(this, {

            layout:"fit",
            region: "center",
            title: _("Modules"),

            enableSort : false,

            enableDrop: true,
            ddGroup: 'TreeDD',

            dropConfig: {
                dropAllowed : true,
                notifyDrop : function (source, e, data) {
                    this.tree.fireEvent("templateDroped", source.dragData.node.id);
                    this.cancelExpand();
                    return true;
                },

                onContainerOver: function(source, e, data) {
                    return "x-tree-drop-ok-append";
                }
            }
        });

        Inprint.cmp.adverta.GridModules.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.adverta.GridModules.superclass.onRender.apply(this, arguments);
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
                            id: this.cmpGetSelectedNode().attributes.module,
                            fascicle: this.parent.fascicle
                        }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }

});
