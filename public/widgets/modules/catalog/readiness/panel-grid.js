Inprint.catalog.readiness.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            create:  _url("/catalog/readiness/create/"),
            remove:  _url("/catalog/readiness/delete/")
        };

        this.store = Inprint.factory.Store.json("/catalog/readiness/list/");
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        Ext.apply(this, {
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "description",

            columns: [
                this.selectionModel,
                {
                    id:"color",
                    header: _("Color"),
                    width: 40,
                    sortable: true,
                    dataIndex: "color",
                    renderer: function(value){
                        return '<div style="background:#'+ value +'">&nbsp;</div>';
                    }
                },
                {
                    id:"percent",
                    header: _("Percent"),
                    width: 60,
                    sortable: true,
                    dataIndex: "percent"
                },
                {
                    id:"shortcut",
                    header: _("Shortcut"),
                    width: 120,
                    sortable: true,
                    dataIndex: "shortcut"
                },
                {
                    id:"title",
                    header: _("Title"),
                    width: 120,
                    sortable: true,
                    dataIndex: "title"
                },
                {
                    id:"description",
                    header: _("Description"),
                    sortable: true,
                    dataIndex: "description"
                }
            ],

            tbar: [
                {
                    icon: _ico("plus-button"),
                    cls: "x-btn-text-icon",
                    text: _("Add"),
                    disabled:true,
                    ref: "../btnAdd",
                    scope:this,
                    handler: this.cmpCreate
                },
                '-',
                {
                    icon: _ico("minus-button"),
                    cls: "x-btn-text-icon",
                    text: _("Remove"),
                    disabled:true,
                    ref: "../btnRemove",
                    scope:this,
                    handler: this.cmpRemove
                }
            ]
        });

        Inprint.catalog.readiness.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.catalog.readiness.Grid.superclass.onRender.apply(this, arguments);
        //this.store.load();
    },

    cmpCreate: function() {

        var win = this.components["create-window"];
        if (!win) {

            var form = new Ext.FormPanel({
                url: this.urls.create,
                frame:false,
                border:false,
                labelWidth: 75,
                defaults: {
                    anchor: "100%",
                    allowBlank:false
                },
                bodyStyle: "padding:5px 5px",
                items: [
                    _FLD_TITLE,
                    _FLD_SHORTCUT,
                    _FLD_DESCRIPTION,
                    _FLD_COLOR,
                    _FLD_PERCENT,
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_SAVE,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Edition addition"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:350,
                items: form
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit")
                    win.hide();
                this.getStore().load();
            }, this);

            this.components["create-window"] = win;
        }

        var form = win.items.first().getForm();
        form.reset();

        win.show(this);

    },

    cmpRemove: function() {
        Ext.MessageBox.confirm(
            _("Warning"),
            _("You really wish to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls.remove,
                        scope:this,
                        success: this.cmpReload,
                        params: { id: this.getValues("id") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }

});
