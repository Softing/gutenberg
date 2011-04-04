Inprint.calendar.archive.Grid = Ext.extend(Ext.ux.tree.TreeGrid, {

    initComponent: function() {

        this.url = {
            'unarchive':  _url('/calendar/fascicle/unarchive/')
        };

        this.tbar = [
            {
                id: 'unarchive',
                disabled: true,
                text: _("Restore"),
                ref: "../btnUnarchive",
                icon: _ico("gear"),
                cls: 'x-btn-text-icon',
                scope: this,
                handler: this.cmpUnarchive
            }
        ];

        this.columns = [
            Inprint.calendar.GridColumns.shortcut,
            Inprint.calendar.GridColumns.num,
            Inprint.calendar.GridColumns.circulation,
            Inprint.calendar.GridColumns.docdate,
            Inprint.calendar.GridColumns.advdate,
            Inprint.calendar.GridColumns.printdate,
            Inprint.calendar.GridColumns.releasedate
        ];

        Ext.apply(this, {
            border:false,
            disabled:true,
            dataUrl: _url('/calendar/list/')
        });

        Inprint.calendar.archive.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.archive.Grid.superclass.onRender.apply(this, arguments);
    },

    cmpGetSelectedNode: function() {
        return this.getSelectionModel().getSelectedNode();
    },

    cmpLoad: function(params) {
        Ext.apply(this.getLoader().baseParams, params);
        this.getRootNode().reload();
    },

    cmpReload: function() {
        this.getRootNode().reload();
    },

    cmpReloadWithMenu: function() {
        this.getRootNode().reload();
        Inprint.layout.getMenu().CmpQuery();
    },

    /* -------------- */

    cmpUnarchive: function(btn) {

        if (btn != 'yes' && btn != 'no') {
            Ext.MessageBox.confirm(
                _("Important event"),
                _("Unarchive the specified release?"),
                this.cmpUnarchive, this);
            return;
        }

        if (btn == 'yes') {
            Ext.Ajax.request({
                url: this.url.unarchive,
                params: {
                    id: this.cmpGetSelectedNode().id
                },
                scope: this,
                success: this.cmpReloadWithMenu,
                failure: this.failure
            });
        }

    },


});
