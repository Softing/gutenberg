Inprint.calendar.forms.CreateIssueForm = Ext.extend( Ext.form.FormPanel, {

    initComponent: function()
    {

        this.items = [

            {
                xtype: "titlefield",
                value: _("Basic parameters")
            },

            {
                xtype: "textfield",
                name: "shortcut",
                allowBlank:false,
                fieldLabel: _("Shortcut")
            },
            {
                xtype: "textfield",
                name: "description",
                fieldLabel: _("Description")
            },

            {
                allowBlank:false,
                xtype: "treecombo",
                name: "edition-shortcut",
                hiddenName: "edition",
                fieldLabel: _("Edition"),
                emptyText: _("Edition") + "...",
                minListWidth: 300,
                url: _url('/common/tree/editions/'),
                baseParams: {
                    term: 'editions.fascicle.manage:*'
                },
                root: {
                    id:'00000000-0000-0000-0000-000000000000',
                    nodeType: 'async',
                    expanded: true,
                    draggable: false,
                    icon: _ico("book"),
                    text: _("All editions")
                },
                listeners: {
                    scope: this,
                    render: function(field) {
                        var id = Inprint.session.options["default.edition"];
                        var title = Inprint.session.options["default.edition.name"] || _("Unknown edition");
                        if (id && title) {
                            field.setValue(id, title);
                        }
                    }
                }
            },

            Inprint.factory.Combo.create(
                "/calendar/combos/copyfrom/", {
                    fieldLabel: _("Copy from"),
                    name: "source",
                    listeners: {
                        render: function(combo) {
                            combo.setValue("00000000-0000-0000-0000-000000000000", _("Defaults"));
                        },
                        beforequery: function(qe) {
                            delete qe.combo.lastQuery;
                        }
                    }
            }),

            {
                xtype: "textfield",
                name: "num",
                fieldLabel: _("Number")
            },
            {
                xtype: "textfield",
                name: "anum",
                fieldLabel: _("Annual number")
            },

            {
                xtype: "numberfield",
                name: "circulation",
                fieldLabel: _("Circulation"),
                value: 0
            },


            {
                xtype: "titlefield",
                value: _("Deadline")
            },

            {
                format:'F j, Y',
                name: 'print_date',
                xtype: 'xdatefield',
                submitFormat:'Y-m-d',
                fieldLabel: _("Printing shop")
            },
            {
                xtype: 'xdatefield',
                name: 'release_date',
                format:'F j, Y',
                submitFormat:'Y-m-d',
                fieldLabel: _("Publication")
            },

            {
                labelWidth: 20,
                xtype: "xdatetime",
                name: "doc_date",
                format: "F j, Y",
                //submitFormat: "Y-m-d",
                fieldLabel: _("Documents")
            },
            {
                xtype: "checkbox",
                name: "doc_enabled",
                checked: true,
                fieldLabel: "",
                boxLabel: _("Enabled")
            },

            {
                xtype: "spacerfield"
            },

            {
                xtype: 'xdatetime',
                name: 'adv_date',
                format:'F j, Y',
                //submitFormat:'Y-m-d',
                fieldLabel: _("Advertisement")
            },
            {
                xtype: "checkbox",
                name: "adv_enabled",
                checked: true,
                fieldLabel: "",
                boxLabel: _("Enabled")
            }

        ];

        Ext.apply(this,  {
            baseCls: 'x-plain',
            defaults:{ anchor:'98%' }
        });

        Inprint.calendar.forms.CreateIssueForm.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {

        Inprint.calendar.forms.CreateIssueForm.superclass.onRender.apply(this, arguments);

        this.getForm().url = _source("issue.create");

        this.getForm().findField("print_date").on("select", function(field, date){
                this.getForm().findField("shortcut").setValue(
                    date.format("d/m/y")
                );
            }, this)
    }

});
