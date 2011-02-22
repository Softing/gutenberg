Inprint.edition.calendar.Grid = Ext.extend(Ext.ux.tree.TreeGrid, {

    initComponent: function() {

        this.url = {
            'load':    _url('/calendar/list/'),
            'create':  _url('/calendar/create/'),
            'read':    _url('/calendar/read/'),
            'update':  _url('/calendar/update/'),
            'delete':  _url('/calendar/delete/'),
            'enable':  _url('/calendar/enable/'),
            'disable': _url('/calendar/disable/')
        };

        this.Components = new Inprint.edition.calendar.Controls({ scope: this, url: this.url });

        Ext.apply(this, {

            border:false,

            columns: [
                {
                    header: _("Shortcut"),
                    dataIndex: 'shortcut',
                    width: 240
                },
                {
                    header: _("Title"),
                    dataIndex: 'title',
                    width: 240
                },
                {
                    header: _("Description"),
                    dataIndex: 'description',
                    width: 240
                }

            ],

            dataUrl: _url('/calendar/list/')

        });

        this.tbar = [
            {
                xtype: 'buttongroup',
                title: _("Issues"),
                defaults: { scale: 'small' },
                items: [
                    {
                        id: 'create',
                        text: _("Create"),
                        disabled: true,
                        icon: _ico("plus-button"),
                        cls: 'x-btn-text-icon',
                        ref: "../../btnCreate",
                        scope: this.Components,
                        handler: this.Components["create"]
                    },
                    {
                        id: 'update',
                        text: _("Edit"),
                        disabled: true,
                        icon: _ico("pencil"),
                        cls: 'x-btn-text-icon',
                        ref: "../../btnUpdate",
                        scope: this.Components,
                        handler: this.Components["update"]
                    },
                    {
                        id: 'delete',
                        text: _("Delete"),
                        disabled: true,
                        icon: _ico("minus-button"),
                        cls: 'x-btn-text-icon',
                        ref: "../../btnDelete",
                        scope: this.Components,
                        handler: this.Components["delete"]
                    }
                ]
            },
            {
                xtype: 'buttongroup',
                title: _("Attachments"),
                defaults: { scale: 'small' },
                items: [
                    {
                        id: 'createAttachment',
                        text: _("Create"),
                        disabled: true,
                        icon: _ico("plus-button"),
                        cls: 'x-btn-text-icon',
                        ref: "../../btnAttachmentCreate",
                        scope: this.Components,
                        handler: this.Components["create"]
                    },
                    {
                        id: 'updateAttachment',
                        text: _("Edit"),
                        disabled: true,
                        icon: _ico("pencil"),
                        cls: 'x-btn-text-icon',
                        ref: "../../btnAttachmentUpdate",
                        scope: this.Components,
                        handler: this.Components["update"]
                    },
                    {
                        id: 'deleteAttachment',
                        text: _("Delete"),
                        disabled: true,
                        icon: _ico("minus-button"),
                        cls: 'x-btn-text-icon',
                        ref: "../../btnAttachmentDelete",
                        scope: this.Components,
                        handler: this.Components["delete"]
                    }
                ]
            }
        ];

        Inprint.edition.calendar.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.edition.calendar.Grid.superclass.onRender.apply(this, arguments);

        this.on("contextmenu", function(node) {

            var items = [];

            node.select();

            var edition = node.attributes.edition;
            var parent  = node.attributes.parent;

            if (edition == parent) {
                items.push({
                    icon: _ico("blueprint--plus"),
                    cls: 'x-btn-text-icon',
                    text    : _('Create attachment'),
                    scope:this,
                    handler : function() {
                        this.cmpCreateAttachment(node);
                    }
                });
            }

            if (edition != parent) {
                items.push({
                    icon: _ico("blueprint--pencil"),
                    cls: 'x-btn-text-icon',
                    text    : _('Edit attachment'),
                    scope:this,
                    handler : this.cmpUpdate
                });
                items.push({
                    icon: _ico("blueprint--minus"),
                    cls: 'x-btn-text-icon',
                    text    : _('Delete attachment'),
                    scope:this,
                    handler: this.cmpDelete
                });
            }

            items.push("-");

            items.push({
                icon: _ico("table"),
                cls: 'x-btn-text-icon',
                text    : _('View plan'),
                handler : function() {
                    Inprint.ObjectResolver.resolve({ aid:'fascicle-plan', oid: node.id, text: node.text });
                }
            });

            items.push({
                icon: _ico("clock"),
                cls: 'x-btn-text-icon',
                text    : _('View composer'),
                handler : function() {
                    Inprint.ObjectResolver.resolve({ aid:'fascicle-planner', oid: node.id, text: node.text });
                }
            });

            items.push('-', {
                icon: _ico("arrow-circle-double"),
                cls: "x-btn-text-icon",
                text: _("Reload"),
                scope: this,
                handler: this.cmpReload
            });

            new Ext.menu.Menu({ items : items }).show(node.ui.getAnchor());
        }, this);

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

    cmpUpdate: {},

    cmpCreateAttachment: {},

    cmpDelete: {},

    cmpCreateForm: {},

    cmpCreateWindow: {}

});
