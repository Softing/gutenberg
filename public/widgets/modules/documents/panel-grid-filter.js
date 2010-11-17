Inprint.documents.GridFilter = Ext.extend(Ext.FormPanel, {

    initComponent: function() {

        this.border = false;
        this.layout = "column";

        var xc = Inprint.factory.Combo;

        this.items = [
            {
                width:180,
                xtype: 'textfield',
                emptyText: _("Title") + "...",
                name: "title"
            },
            {
                xtype: "treecombo",
                name: "edition",
                fieldLabel: _("Edition"),
                emptyText: _("Edition") + "...",
                minListWidth: 250,
                url: _url('/documents/trees/editions/'),
                baseParams: {
                    term: 'editions.documents.work'
                },
                rootVisible:true,
                root: {
                    id:'00000000-0000-0000-0000-000000000000',
                    nodeType: 'async',
                    expanded: true,
                    draggable: false,
                    icon: _ico("book"),
                    text: _("All editions")
                }
            },
            {
                xtype: "treecombo",
                name: "group",
                fieldLabel: _("Group"),
                emptyText: _("Group") + "...",
                minListWidth: 250,
                url: _url('/documents/trees/workgroups/'),
                baseParams: {
                    term: 'catalog.documents.view:*'
                },
                rootVisible:true,
                root: {
                    id:'00000000-0000-0000-0000-000000000000',
                    nodeType: 'async',
                    expanded: true,
                    draggable: false,
                    icon: _ico("folder-open"),
                    text: _("All departments")
                }
            },
            
            xc.getConfig("/documents/filters/fascicles/", {
                columnWidth:.125,
                cacheQuery: false,
                listeners: {
                    scope: this,
                    render: function(combo) {
                        this.getForm().findField("edition").on("select", function() {
                            combo.enable();
                            combo.reset();
                        }, this);
                    },
                    beforequery: function(qe) {
                        qe.combo.getStore().baseParams = this.getFilterParams();
                        delete qe.combo.lastQuery;
                    }
                }
            }),
            xc.getConfig("/documents/filters/headlines/", {
                disabled: true,
                columnWidth:.125,
                cacheQuery: false,
                listeners: {
                    scope: this,
                    render: function(combo) {
                        this.getForm().findField("edition").on("select", function() {
                            combo.disable();
                            combo.reset();
                        }, this);
                        this.getForm().findField("fascicle").on("select", function() {
                            combo.enable();
                            combo.reset();
                        }, this);
                    },
                    beforequery: function(qe) {
                        qe.combo.getStore().baseParams = this.getFilterParams();
                        delete qe.combo.lastQuery;
                    }
                }
            }),
            xc.getConfig("/documents/filters/rubrics/", {
                disabled: true,
                columnWidth:.125,
                cacheQuery: false,
                listeners: {
                    scope: this,
                    render: function(combo) {
                        this.getForm().findField("edition").on("select", function() {
                            combo.disable();
                            combo.reset();
                        }, this);
                        this.getForm().findField("fascicle").on("select", function() {
                            combo.disable();
                            combo.reset();
                        }, this);
                        this.getForm().findField("headline").on("select", function() {
                            combo.enable();
                            combo.reset();
                        }, this);
                    },
                    beforequery: function(qe) {
                        qe.combo.getStore().baseParams = this.getFilterParams();
                        delete qe.combo.lastQuery;
                    }
                }
            }),
            xc.getConfig("/documents/filters/managers/",  {
                editable:true,
                columnWidth:.125,
                cacheQuery: false,
                listeners: {
                    scope: this,
                    beforequery: function(qe) {
                        qe.combo.getStore().baseParams = this.getFilterParams();
                        delete qe.combo.lastQuery;
                    }
                }
            }),
            xc.getConfig("/documents/filters/progress/",  {
                columnWidth:.125,
                cacheQuery: false,
                listeners: {
                    scope: this,
                    beforequery: function(qe) {
                        qe.combo.getStore().baseParams = this.getFilterParams();
                        delete qe.combo.lastQuery;
                    }
                }
            }),
            xc.getConfig("/documents/filters/holders/",   {
                editable:true,
                columnWidth:.125,
                cacheQuery: false,
                listeners: {
                    scope: this,
                    beforequery: function(qe) {
                        qe.combo.getStore().baseParams = this.getFilterParams();
                        delete qe.combo.lastQuery;
                    }
                }
            }),

            {
                xtype: 'button',
                icon: _ico('magnifier'),
                cls: 'x-btn-icon',
                scope:this,
                handler: this.doSearch
            }

        ];

        Inprint.documents.GridFilter.superclass.initComponent.apply(this, arguments);

        this.addEvents('restore', 'filter');
    },

    onRender: function() {
        Inprint.documents.GridFilter.superclass.onRender.apply(this, arguments);
        var params = this.restoreFilterState();
        this.fireEvent('restore', this, params);
    },

    doSearch: function() {
        var form = this.getForm();
        var params = this.getFilterParams();
        this.saveFilterState();
        this.fireEvent('filter', this, params);
    },

    getFilterParams: function() {
        var form = this.getForm();
        var params = {};
        params["gridmode"]      = this.gridmode;
        params["flt_title"]     = form.findField("title").getValue();
        params["flt_edition"]   = form.findField("edition").hiddenField.value;
        params["flt_group"]     = form.findField("group").hiddenField.value;
        params["flt_fascicle"]  = form.findField("fascicle").hiddenField.value;
        params["flt_headline"]  = form.findField("headline").hiddenField.value;
        params["flt_rubric"]    = form.findField("rubric").hiddenField.value;
        params["flt_manager"]   = form.findField("manager").hiddenField.value;
        params["flt_progress"]  = form.findField("progress").hiddenField.value;
        params["flt_holder"]    = form.findField("holder").hiddenField.value;
        return params;
    },

    saveFilterState: function() {
        var form = this.getForm();
        var params = {};
        params["edition"]    = { id: form.findField("edition").hiddenField.value,  text: form.findField("edition").getRawValue()  };
        params["group"]     = { id: form.findField("group").hiddenField.value,    text: form.findField("group").getRawValue()    };
        params["fascicle"]  = { id: form.findField("fascicle").hiddenField.value, text: form.findField("fascicle").getRawValue() };
        Ext.state.Manager.set(this.stateId + "-filter", params);
    },

    restoreFilterState: function() {
        var form = this.getForm();
        var params = {};
        var state = Ext.state.Manager.get(this.stateId + "-filter", {});

        if (state["fascicle"] && state["fascicle"].id != "clear") {
            form.findField("headline").enable();
        }

        if (state["headline"] && state["headline"].id != "clear") {
            form.findField("rubric").enable();
        }
        
        for (var i in state) {
            if (state[i].id && state[i].id != "clear") {
                var field = form.findField(i);
                if (field) {
                    params["flt_"+i] = state[i].id;
                    field.on("render", function(combo){
                        combo.setValue(this.id, this.text);
                        //combo.hiddenField.value=this.id;
                    }, state[i]);
                }
            }
        }
        return params;
    }

});
