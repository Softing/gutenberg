Inprint.exchange.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};

        this.store = Inprint.factory.Store.json("/stages/list/");
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        Ext.apply(this, {
            title:_("Stages"),
            border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "employee",
            columns: [
                this.selectionModel,
                {   id:"color",
                    width: 60,
                    dataIndex: "color",
                    header : '<img src="' + _ico("color") + '">',
                    renderer: function(val) {
                        return "<div style=\"background:#" + val + ";padding:2px 3px;font-size:10px;-webkit-border-radius:2px;-moz-border-radius:3px;\">"+val+"</div>"
                    }
                },
                {   id:"weight",
                    width: 40,
                    dataIndex: "weight",
                    header : '<img src="' + _ico("edit-list-order") + '">',
                    renderer : function(v) {
                        return v + '%';
                    }

                },
                {   id:"name",
                    header: _("Name"),
                    width: 200,
                    dataIndex: "name"
                },
                {   id:"employee",
                    header: _("Employees"),
                    dataIndex: "description"
                }
            ],

            tbar: [
                {
                    xtype: 'buttongroup',
                    title: 'Цепочки',
                    defaults: {
                        scale: 'small'
                    },
                    items: [
                        {   icon: _ico("plus-button"),
                            cls: "x-btn-text-icon",
                            text: _("Add"),
                            disabled:true,
                            ref: "../../btnCreateChain"
                        },
                        {   icon: _ico("pencil"),
                            cls: "x-btn-text-icon",
                            text: _("Change"),
                            disabled:true,
                            ref: "../../btnChangeChain"
                        },
                        {   icon: _ico("minus-button"),
                            cls: "x-btn-text-icon",
                            text: _("Remove"),
                            disabled:true,
                            ref: "../../btnRemoveChain"
                        }
                    ]
                },
                {
                    xtype: 'buttongroup',
                    title: 'Ступеньки',
                    defaults: {
                        scale: 'small'
                    },
                    items: [
                        {   icon: _ico("plus-button"),
                            cls: "x-btn-text-icon",
                            text: _("Add"),
                            disabled:true,
                            ref: "../../btnCreateStage"
                        },
                        {   icon: _ico("pencil"),
                            cls: "x-btn-text-icon",
                            text: _("Change"),
                            disabled:true,
                            ref: "../../btnChangeStage"
                        },
                        {   icon: _ico("minus-button"),
                            cls: "x-btn-text-icon",
                            text: _("Remove"),
                            disabled:true,
                            ref: "../../btnRemoveStage"
                        }
                    ]
                },
                {
                    xtype: 'buttongroup',
                    title: 'Сотрудники',
                    defaults: {
                        scale: 'small'
                    },
                    items: [
                        {   icon: _ico("users"),
                            cls: "x-btn-text-icon",
                            text: _("Select employees"),
                            //disabled:true,
                            ref: "../../btnSelectMembers"
                        }
                    ]
                }
            ]
        });

        Inprint.exchange.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.exchange.Grid.superclass.onRender.apply(this, arguments);
    }

});
