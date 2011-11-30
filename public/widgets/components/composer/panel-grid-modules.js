Inprint.cmp.composer.Modules = Ext.extend(Ext.ux.tree.TreeGrid, {

    initComponent: function() {

        this.params = {};
        this.components = {};

        this.urls = {
            "list":   this.parent.urls.modulesList,
            "create": this.parent.urls.modulesCreate,
            "delete": this.parent.urls.modulesDelete
        };

        this.columns = [
            {
                id:"title",
                width: 90,
                header: _("Title"),
                dataIndex: "title"
            },
            {
                id:"place_title",
                width: 100,
                header: _("Place"),
                dataIndex: "place_title",
                tpl : new Ext.XTemplate('{format:this.formatString}', {
                    formatString : function(v, record) {
                        var amount = record.amount || 1;
                        var place  = record.place_title || "";
                        return String.format("{0} / {1}", amount, place);
                    }
                })
            },
            {
                id:"request",
                width: 200,
                header: _("Request"),
                dataIndex: "request_shortcut"
            }
        ];

        this.loader  = new Ext.tree.TreeLoader({
            dataUrl: this.urls.list,
            baseParams: {
                page: this.parent.selection
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
