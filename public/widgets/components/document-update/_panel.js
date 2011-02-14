Inprint.cmp.UpdateDocument = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.form = new Inprint.cmp.UpdateDocument.Form();

        Ext.apply(this, {
            title: _("Edit Document Properties"),
            modal:true,
            layout: "fit",
            width:400, height:460,
            items: this.form,
            buttons:[
                {
                    text: _("Save"),
                    scope:this,
                    handler: function() {
                        this.form.getForm().submit();
                    }
                },
                {
                    text: _("Cancel"),
                    scope:this,
                    handler: function() {
                        this.hide();
                    }
                }
            ]
        });

        Inprint.cmp.UpdateDocument.superclass.initComponent.apply(this, arguments);

        this.addEvents('complete');
    },

    onRender: function() {

        Inprint.cmp.UpdateDocument.superclass.onRender.apply(this, arguments);

        Inprint.cmp.UpdateDocument.Access(this, this.form);

        this.form.on("actioncomplete", function (form, action) {
            if (action.type == "submit") {
                this.hide();
                this.fireEvent("complete", this, this.form);
            }
        }, this);
    },

    onShow: function() {
        Ext.Ajax.request({
            url: "/documents/read/",
            scope:this,
            success: this.cmpFill,
            params: { id: this.document }
        });
    },

    cmpFill: function(result, request) {

        var json = Ext.util.JSON.decode(result.responseText);
        var form = this.form.getForm();

        this.form.edition  = json.data.edition;
        this.form.fascicle = json.data.fascicle;

        if (json.data.id) {
            form.findField("id").setValue(json.data.id);
        }

        if (json.data.title) {
            form.findField("title").setValue(json.data.title);
        }

        if (json.data.author) {
            form.findField("author").setValue(json.data.author);
        }

        if (json.data.size) {
            form.findField("size").setValue(json.data.size);
        }

        if (json.data.pdate) {
            form.findField("enddate").setValue(json.data.pdate);
        }

        if (json.data.maingroup && json.data.maingroup_shortcut) {
            form.findField("maingroup").setValue(json.data.maingroup, json.data.maingroup_shortcut);
        }
        if (json.data.manager && json.data.manager_shortcut) {
            form.findField("manager").setValue(json.data.manager, json.data.manager_shortcut);
        }

        if (json.data.headline && json.data.headline_shortcut) {
            form.findField("headline").setValue(json.data.headline, json.data.headline_shortcut);
            form.findField("rubric").enable();
            if (json.data.rubric && json.data.rubric_shortcut) {
                form.findField("rubric").setValue(json.data.rubric, json.data.rubric_shortcut);
                form.findField("rubric").getStore().baseParams["flt_headline"] = json.data.headline;
            }
        }

    }


});
