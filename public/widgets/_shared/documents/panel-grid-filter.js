// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.documents.GridFilter = Ext.extend(Ext.FormPanel, {

    initComponent: function() {

        this.border = false;
        this.layout = "column";

        var xc = Inprint.factory.Combo;

        var options = "mode::" + this.gridmode;

        this.items = [
            {
                width:140,
                xtype: 'textfield',
                emptyText: _("Title") + "...",
                name: "title"
            },
            {
                columnWidth: .125,
                xtype: "treecombo",
                name: "edition",
                fieldLabel: _("Edition"),
                emptyText: _("Edition") + "...",
                minListWidth: 300,
                url: _url('/common/tree/editions/'),
                baseParams: {
                    options: options,
                    term: 'editions.documents.work:*'
                },
                rootVisible:true,
                root: {
                    id:'all',
                    nodeType: 'async',
                    expanded: true,
                    draggable: false,
                    icon: _ico("book"),
                    text: _("All editions")
                }
            },
            {
                columnWidth:.125,
                xtype: "treecombo",
                name: "group",
                fieldLabel: _("Department"),
                emptyText: _("Department") + "...",
                minListWidth: 300,
                url: _url('/common/tree/workgroups/'),
                baseParams: {
                    options: options,
                    term: 'catalog.documents.view:*'
                },
                rootVisible:true,
                root: {
                    id:'all',
                    nodeType: 'async',
                    expanded: true,
                    draggable: false,
                    icon: _ico("xfn-friend"),
                    text: _("All departments")
                }
            },
            {
                columnWidth:.125,
                xtype: "treecombo",
                name: "fascicle",
                rootVisible:true,
                minListWidth: 300,
                fieldLabel: _("Fascicle"),
                emptyText: _("Fascicle") + "...",
                url: _url('/common/tree/fascicles/'),
                baseParams: {
                    options: options,
                    term: 'editions.documents.work:*',
                    briefcase: true
                },
                root: {
                    id:'all',
                    nodeType: 'async',
                    expanded: true,
                    draggable: false,
                    icon: _ico("blue-folder-open-document-text"),
                    text: _("All fascicles")
                }
            },
            xc.getConfig("/documents/filters/headlines/", {
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
            xc.getConfig("/documents/filters/rubrics/", {
                disabled: false,
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
            },
            {
                xtype: 'button',
                icon: _ico('cross'),
                cls: 'x-btn-icon',
                scope:this,
                handler: this.doClear
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

    doClear: function() {
        var form = this.getForm();

        form.reset();

        form.findField("edition").setValue("all", _("All editions"));
        form.findField("fascicle").setValue("all", _("All fascicles"));
        form.findField("group").setValue("all", _("All departments"));

        this.doSearch();

        //this.saveFilterState();
        //this.fireEvent('filter', this, {});
    },

    getFilterParams: function() {
        var form = this.getForm();
        var params = {};
        params.gridmode      = this.gridmode;
        params.flt_title     = form.findField("title").getValue();
        params.flt_edition   = form.findField("edition").hiddenField.value;
        params.flt_group     = form.findField("group").hiddenField.value;
        params.flt_fascicle  = form.findField("fascicle").hiddenField.value;
        params.flt_headline  = form.findField("headline").hiddenField.value;
        params.flt_rubric    = form.findField("rubric").hiddenField.value;
        params.flt_manager   = form.findField("manager").hiddenField.value;
        params.flt_progress  = form.findField("progress").hiddenField.value;
        params.flt_holder    = form.findField("holder").hiddenField.value;
        return params;
    },

    saveFilterState: function() {
        var state = {};
        var form = this.getForm();

        var edition           = form.findField("edition").hiddenField.value;
        var edition_shortcut  = form.findField("edition").getRawValue();
        var group             = form.findField("group").hiddenField.value;
        var group_shortcut    = form.findField("group").getRawValue();
        var fascicle          = form.findField("fascicle").hiddenField.value;
        var fascicle_shortcut = form.findField("fascicle").getRawValue();

        if (edition && edition_shortcut) {
            state.edition    = { id: edition, text: edition_shortcut  };
        }

        if (group && group_shortcut) {
            state.group    = { id: group, text: group_shortcut  };
        }

        if (fascicle && fascicle_shortcut) {
            state.fascicle = { id: fascicle, text: fascicle_shortcut  };
        }

        Ext.state.Manager.set(this.stateId + "-filter", state);
    },

    restoreFilterState: function() {

        var params = {};
        var form = this.getForm();

        var state = Ext.state.Manager.get(this.stateId + "-filter", {});

        if (state.fascicle && state.fascicle.id != "all") {
            form.findField("headline").enable();
        }

        if (state.headline && state.headline.id != "all") {
            form.findField("rubric").enable();
        }

        for (var i in state) {
            if (state[i].id && state[i].id != "all") {
                var field = form.findField(i);
                if (field) {
                    params["flt_"+i] = state[i].id;
                    field.on("render", function(combo){
                        combo.setValue(this.id, this.text);
                    }, state[i]);
                }
            }
        }
        return params;
    }

});
