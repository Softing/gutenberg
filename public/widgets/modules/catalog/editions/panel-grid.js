Inprint.catalog.editions.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};

        this.store = Inprint.factory.Store.json("/catalog/stages/list/");
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            this.selectionModel,
            {   id:"color",
                width: 30,
                dataIndex: "readiness_color",
                header : '<img src="' + _ico("color") + '">',
                renderer: function(val) {
                    return "<div style=\"background:#" + val + ";padding:2px 3px;font-size:10px;-webkit-border-radius:2px;-moz-border-radius:3px;\">&nbsp;</div>"
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
            {   id:"readiness",
                header: _("Readiness"),
                width: 160,
                dataIndex: "readiness_shortcut"
            },
            {   id:"title",
                header: _("Title"),
                width: 160,
                dataIndex: "title"
            },
            {   id:"employee",
                header: _("Employees"),
                dataIndex: "description",
                renderer: function (v, p, r) {
                    if (r.data.members) {
                        var data = [];
                        Ext.each(r.data.members, function(v){
                            switch(v.type) {
                                case "group":
                                    data.push("<b>"+ v.catalog_shortcut +'/'+ v.title +"</b>");
                                    break;
                                case "member":
                                    data.push(v.catalog_shortcut+'/'+v.title);
                                    break;
                            }
                        });
                        return data.join(', ');
                    }
                    return '';
                }
            }
        ];
        
        this.tbar = [
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
                    {   disabled:true,
                        icon: _ico("users"),
                        cls: "x-btn-text-icon",
                        text: _("Select employees"),
                        ref: "../../btnManagePrincipals"
                    }
                ]
            }
        ];

        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "employee"
        });

        Inprint.catalog.editions.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.catalog.editions.Grid.superclass.onRender.apply(this, arguments);
    }

});
