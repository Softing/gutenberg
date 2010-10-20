Inprint.documents.GridFilter = Ext.extend(Ext.FormPanel, {

    initComponent: function() {

        this.stateHash = {};
        this.filterParams = {};

        this.border = false;
        this.layout = "column";

        var xc = Inprint.factory.Combo;

        this.items = [
            {
                width:180,
                xtype: 'textfield',
                emptyText: _("Title") + "...",
                listeners: {
                    scope: this,
                    blur: function(field) {
                        this.filterParams["flt_title"] = field.getValue();
                    }
                }
            },
            xc.getConfig("/documents/filters/editions/", {
                columnWidth:.125,
                cacheQuery: false,
                listeners: {
                    scope: this,
                    select: function(combo, record, indx) {
                        this.setFilterParam("edition", record.get("id"), record.get("title"));
                    },
                    beforequery: function(qe) {
                        delete qe.combo.lastQuery;
                    }
                }
            }, { baseParams: { gridmode: this.gridmode } }),
            xc.getConfig("/documents/filters/groups/", {
                columnWidth:.125,
                cacheQuery: false,
                listeners: {
                    scope: this,
                    select: function(combo, record, indx) {
                        this.setFilterParam("group", record.get("id"), record.get("title"));
                    },
                    beforequery: function(qe) {
                        delete qe.combo.lastQuery;
                    }
                }
            }, { baseParams: { gridmode: this.gridmode } }),
            xc.getConfig("/documents/filters/fascicles/", {
                columnWidth:.125,
                cacheQuery: false,
                listeners: {
                    scope: this,
                    select: function(combo, record, indx) {
                        this.setFilterParam("fascicle", record.get("id"), record.get("title"));
                        this.getForm().findField("headline").enable();
                    },
                    beforequery: function(qe) {
                        delete qe.combo.lastQuery;
                        qe.combo.getStore().baseParams["flt_edition"] = this.filterParams["flt_edition"];
                    }
                }
            }, { baseParams: { gridmode: this.gridmode } }),
            xc.getConfig("/documents/filters/headlines/", {
                disabled: true,
                columnWidth:.125,
                cacheQuery: false,
                listeners: {
                    scope: this,
                    select: function(combo, record, indx) {
                        this.setFilterParam("headline", record.get("id"), record.get("title"));
                        this.getForm().findField("rubric").enable();
                    },
                    beforequery: function(qe) {
                        delete qe.combo.lastQuery;
                        qe.combo.getStore().baseParams["flt_fascicle"] = this.filterParams["flt_fascicle"];
                    }
                }
            }, { baseParams: { gridmode: this.gridmode } }),
            xc.getConfig("/documents/filters/rubrics/", {
                disabled: true,
                columnWidth:.125,
                cacheQuery: false,
                listeners: {
                    scope: this,
                    select: function(combo, record, indx) {
                        this.setFilterParam("rubric", record.get("id"), record.get("title"));
                    },
                    beforequery: function(qe) {
                        delete qe.combo.lastQuery;
                        qe.combo.getStore().baseParams["flt_headline"] = this.filterParams["flt_headline"];
                    }
                }
            }, { baseParams: { gridmode: this.gridmode } }),
            xc.getConfig("/documents/filters/managers/",  {
                editable:true,
                columnWidth:.125,
                cacheQuery: false,
                listeners: {
                    scope: this,
                    select: function(combo, record, indx) {
                        this.setFilterParam("manager", record.get("id"), record.get("title"));
                    },
                    beforequery: function(qe) {
                        delete qe.combo.lastQuery;
                        qe.combo.getStore().baseParams["flt_group"] = this.filterParams["flt_group"];
                    }
                }
            }, { baseParams: { gridmode: this.gridmode } }),
            xc.getConfig("/documents/filters/progress/",  {
                columnWidth:.125,
                cacheQuery: false,
                listeners: {
                    scope: this,
                    select: function(combo, record, indx) {
                        this.setFilterParam("progress", record.get("id"), record.get("title"));
                    },
                    beforequery: function(qe) {
                        delete qe.combo.lastQuery;
                    }
                }
            }, { baseParams: { gridmode: this.gridmode } }),
            xc.getConfig("/documents/filters/holders/",   {
                editable:true,
                columnWidth:.125,
                cacheQuery: false,
                listeners: {
                    scope: this,
                    select: function(combo, record, indx) {
                        this.setFilterParam("holder", record.get("id"), record.get("title"));
                    },
                    beforequery: function(qe) {
                        delete qe.combo.lastQuery;
                        qe.combo.getStore().baseParams["flt_group"] = this.filterParams["flt_group"];
                    }
                }
            }, { baseParams: { gridmode: this.gridmode } }),
            {
                xtype: 'button',
                icon: _ico('magnifier'),
                cls: 'x-btn-icon',
                scope:this,
                handler: function() {
                    Ext.state.Manager.set(this.stateId + "-filter", this.stateHash);
                    this.fireEvent('filter', this, this.filterParams);
                }
            }
        ];

        Inprint.documents.GridFilter.superclass.initComponent.apply(this, arguments);

        this.addEvents('ready', 'filter');

    },

    onRender: function() {

        Inprint.documents.GridFilter.superclass.onRender.apply(this, arguments);

        this.stateHash = Ext.state.Manager.get(this.stateId + "-filter", {});
        for (var i in this.stateHash) {
            var field = this.getForm().findField(i);
            if (field) {
                field.setValue(this.stateHash[i].name);
                this.filterParams["flt_"+i] = this.stateHash[i].value;
            }
        }
        this.fireEvent('ready', this, this.filterParams);

    },

    setFilterParam: function(param, value, title) {
        this.filterParams["flt_"+param] = value;
        this.stateHash[param] = { name:  title, value: value };
    }

});
