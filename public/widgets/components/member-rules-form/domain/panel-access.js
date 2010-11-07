Inprint.cmp.memberRulesForm.Domain.Restrictions = Ext.extend(Ext.grid.EditorGridPanel, {

    initComponent: function() {

        this.uid;
        this.record;

        this.components = {};

        this.urls = {
            "list":    "/catalog/rules/list/",
            "save":    _url("/catalog/rules/map/"),
            "fill":    _url("/catalog/rules/mapping/")
        };

        this.sm = new Ext.grid.CheckboxSelectionModel({
            checkOnly:true
        });

        this.store = Inprint.factory.Store.json(this.urls.list, {
            autoLoad: false,
            baseParams: {
                section: 'domain'
            }
        });

        this.columns = [
            this.sm,
            {
                id:"icon",
                width: 30,
                dataIndex: "icon",
                renderer: function (value, meta, record) {
                    return '<img src="'+ _ico(value) +'"/>';
                }
            },
            {
                id:"title",
                header: _("Rule"),
                width: 120,
                sortable: true,
                dataIndex: "title",
                renderer: function (value, meta, record) {
                    return _(value);
                }
            }
        ];

        Ext.apply(this, {
            disabled: false,
            stripeRows: true,
            columnLines: true,
            clicksToEdit: 1,
            autoExpandColumn: "title"
        });

        Inprint.cmp.memberRulesForm.Domain.Restrictions.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.memberRulesForm.Domain.Restrictions.superclass.onRender.apply(this, arguments);
        this.getStore().load();
    },

    cmpFill: function(member) {

        this.memberId = member;
        
        this.getSelectionModel().clearSelections();
        this.getStore().rejectChanges();

        this.body.mask(_("Loading"));

        Ext.Ajax.request({
            url: this.urls.fill,
            scope:this,
            params: {
                member: member,
                section: "domain"
            },
            callback: function() {
                this.body.unmask();
            },
            success: function(responce) {
                var result = Ext.util.JSON.decode(responce.responseText);
                var store = this.getStore();
                for (var i in result.data) {
                    var record = store.getById(i);
                    if (record) {
                        this.getSelectionModel().selectRecords([ record ], true);
                    }
                }
            }
        });
    },

    cmpSave: function() {
        var data = [];
        Ext.each(this.getSelectionModel().getSelections(), function(record) {
            data.push( record.get("id") + "::domain");
        });
        Ext.Ajax.request({
            scope:this,
            url: this.urls.save,
            params: {
                rules: data,
                section: "domain",
                member: this.memberId,
                binding: '00000000-0000-0000-0000-000000000000'
            },
            success: function() {
                this.cmpReload;
                new Ext.ux.Notification({
                    iconCls: 'event',
                    title: _("System event"),
                    html: _("Changes have been saved")
                }).show(document);
            }
        });
    }
    
});