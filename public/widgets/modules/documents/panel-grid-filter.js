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
            xc.getConfig("/documents/filters/editions/", {
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
            xc.getConfig("/documents/filters/groups/", {
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
            xc.getConfig("/documents/filters/fascicles/", {
                columnWidth:.125,
                cacheQuery: false,
                listeners: {
                    scope: this,
                    render: function(combo) {
                        this.getForm().findField("edition").on("select", function() {
                            combo.enable();
                            combo.reset();
                            //combo.getStore().baseParams["flt_edition"] = this.getForm().findField("edition").getValue();
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
                            //combo.getStore().baseParams["flt_fascicle"] = this.getForm().findField("fascicle").getValue();
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
                            //combo.getStore().baseParams["flt_headline"] = this.getForm().findField("headline").getValue();
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
                    //render: function(combo) {
                    //    this.getForm().findField("group").on("select", function() {
                    //        //combo.getStore().baseParams["flt_group"] = this.getForm().findField("group").getValue();
                    //        combo.getStore().baseParams = this.getFilterParams();
                    //    }, this);
                    //},
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
                    //render: function(combo) {
                    //    this.getForm().findField("edition").on("select", function() {
                    //        combo.getStore().baseParams["flt_edition"] = this.getForm().findField("edition").getValue();
                    //    }, this);
                    //},
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
                    //render: function(combo) {
                    //    this.getForm().findField("group").on("select", function() {
                    //        combo.getStore().baseParams["flt_group"] = this.getForm().findField("group").getValue();
                    //    }, this);
                    //},
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
        params["editon"]    = { id: form.findField("edition").hiddenField.value,  text: form.findField("edition").getRawValue()  };
        params["group"]     = { id: form.findField("group").hiddenField.value,    text: form.findField("group").getRawValue()    };
        params["fascicle"]  = { id: form.findField("fascicle").hiddenField.value, text: form.findField("fascicle").getRawValue() };
        //params["headline"]  = { id: form.findField("headline").hiddenField.value, text: form.findField("headline").getRawValue() };
        //params["rubric"]    = { id: form.findField("rubric").hiddenField.value,   text: form.findField("rubric").getRawValue()   };
        //params["manager"]   = { id: form.findField("manager").hiddenField.value,  text: form.findField("manager").getRawValue()  };
        //params["progress"]  = { id: form.findField("progress").hiddenField.value, text: form.findField("progress").getRawValue() };
        //params["holder"]    = { id: form.findField("holder").hiddenField.value,   text: form.findField("holder").getRawValue()   };
        Ext.state.Manager.set(this.stateId + "-filter", params);
    },

    restoreFilterState: function() {
        var params = {};
        var state = Ext.state.Manager.get(this.stateId + "-filter", {});

        if (state["fascicle"] && state["fascicle"].id != "clear") {
            this.getForm().findField("headline").enable();
        }

        if (state["headline"] && state["headline"].id != "clear") {
            this.getForm().findField("rubric").enable();
        }

        for (var i in state) {
            if (state[i].id && state[i].id != "clear") {
                var field = this.getForm().findField(i);
                if (field) {
                    params["flt_"+i] = state[i].id;
                    field.on("afterrender", function(combo){
                        combo.setValue(this.text);
                        combo.hiddenField.value=this.id;
                    }, state[i]);
                }
            }
        }
        return params;
    }

});
