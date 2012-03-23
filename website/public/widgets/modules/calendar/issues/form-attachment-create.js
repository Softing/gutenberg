//Inprint.calendar.issues.CreateFascicleFormAttachmentForm = Ext.extend( Ext.form.FormPanel,
//{
//
//    initComponent: function()
//    {
//
//        this.items = [
//
//            _FLD_HDN_PARENT,
//
//            {
//                xtype: "treecombo",
//                hiddenName: "edition",
//                fieldLabel: _("Edition"),
//                emptyText: _("Edition") + "...",
//                minListWidth: 300,
//                url: _url('/common/tree/editions/'),
//                baseParams: {
//                    term: 'editions.attachment.manage:*'
//                },
//                rootVisible:false,
//                root: {
//                    id:'all',
//                    nodeType: 'async',
//                    expanded: true,
//                    draggable: false,
//                    icon: _ico("book"),
//                    text: _("All editions")
//                }
//            },
//
//            Inprint.factory.Combo.create(
//                    "/calendar/combos/templates/", {
//                        fieldLabel: _("Template"),
//                        name: "source",
//                        listeners: {
//                            beforequery: function(qe) {
//                                delete qe.combo.lastQuery;
//                            }
//                        }
//                }),
//
//            {
//                xtype: "numberfield",
//                name: "circulation",
//                fieldLabel: _("Circulation"),
//                value: 0
//            }
//
//        ];
//
//        Ext.apply(this,  {
//            baseCls: 'x-plain',
//            defaults:{ anchor:'100%' }
//        });
//
//        Inprint.calendar.issues.CreateFascicleFormAttachmentForm.superclass.initComponent.apply(this, arguments);
//        this.getForm().url = _source("attachment.create");
//    },
//
//    onRender: function() {
//        Inprint.calendar.issues.CreateFascicleFormAttachmentForm.superclass.onRender.apply(this, arguments);
//    },
//
//    setParent: function(id) {
//        this.cmpSetValue("parent", id);
//    }
//
//});
