Inprint.documents.Actions = function(parent, panels) {

    return {
        
        // Create new document
        Create: function() {
            var panel = new Inprint.cmp.CreateDocument();
            panel.show();
            panel.on("complete", function() { this.cmpReload(); }, this);
        },
        
        // Update document's short profile
        Update: function() {
            var panel = new Inprint.cmp.UpdateDocument({
                document: this.getValue("id")
            });
            panel.show();
            panel.on("complete", function() {
                this.cmpReload();
            }, this);
        },
        
        // Capture document from another user
        Capture: function() {
            Ext.MessageBox.confirm(
                _("Document capture"),
                _("You really want to do this?"),
                function(btn) {
                    if (btn == "yes") {
                        Ext.Ajax.request({
                            url: this.urls.capture,
                            scope:this,
                            success: this.cmpReload,
                            params: { id: this.getValues("id") }
                        });
                    }
                }, this).setIcon(Ext.MessageBox.WARNING);
        },
        
        // Move document(s) to another user
        Transfer: function() {
            var panel = new Inprint.cmp.ExcahngeBrowser().show();
            panel.on("complete", function(id){
                Ext.Ajax.request({
                    url: this.urls.transfer,
                    scope:this,
                    success: this.cmpReload,
                    params: { id: this.getValues("id"), transfer: id }
                });
            }, this);
        },
        
        // Move document(s) to briefcase
        Briefcase: function() {
            Ext.MessageBox.confirm(
                _("Moving to the briefcase"),
                _("You really want to do this?"),
                function(btn) {
                    if (btn == "yes") {
                        Ext.Ajax.request({
                            url: this.urls.briefcase,
                            scope:this,
                            success: this.cmpReload,
                            params: {
                                id: this.getValues("id")
                            }
                        });
                    }
                }, this).setIcon(Ext.MessageBox.WARNING);
        },
        
        // Move document(s) to another fascicle
        Move: function() {
            var cmp = new Inprint.cmp.MoveDocument();
            cmp.setId(this.getValues("id"));
            cmp.show();
            cmp.on("actioncomplete", function() {
                this.cmpReload();
            }, this);
        },
        
        // Copy document(s) to another fascicle(s)
        Copy: function() {
            var cmp = new Inprint.cmp.CopyDocument();
            cmp.setId(this.getValues("id"));
            cmp.show();
            cmp.on("actioncomplete", function() {
                this.cmpReload();
            }, this);
        },
        
        // Duplicate document(s) to another fascicle(s)
        Duplicate: function() {
            var cmp = new Inprint.cmp.DuplicateDocument();
            cmp.setId(this.getValues("id"));
            cmp.show();
            cmp.on("actioncomplete", function() {
                this.cmpReload();
            }, this);
        },
        
        // Move document(s) to Recycle Bin
        Recycle: function() {
            Ext.MessageBox.confirm(
                _("Moving to the recycle bin"),
                _("You really want to do this?"),
                function(btn) {
                    if (btn == "yes") {
                        Ext.Ajax.request({
                            url: _url("/documents/recycle/"),
                            scope:this,
                            success: this.cmpReload,
                            params: { id: this.getValues("id") }
                        });
                    }
                }, this).setIcon(Ext.MessageBox.WARNING);
        },
        
        // Restore documents from Recycle Bin
        Restore: function() {
            Ext.MessageBox.confirm(
                _("Document restoration"),
                _("You really want to do this?"),
                function(btn) {
                    if (btn == "yes") {
                        Ext.Ajax.request({
                            url: _url("/documents/restore/"),
                            scope:this,
                            success: this.cmpReload,
                            params: { id: this.getValues("id") }
                        });
                    }
                }, this).setIcon(Ext.MessageBox.WARNING);
        },
        
        // Delete document from DB and Filesystem
        Delete: function() {
            Ext.MessageBox.confirm(
                _("Irreversible removal"),
                _("You can't cancel this action!"),
                function(btn) {
                    if (btn == "yes") {
                        Ext.Ajax.request({
                            url: _url("/documents/delete/"),
                            scope:this,
                            success: this.cmpReload,
                            params: { id: this.getValues("id") }
                        });
                    }
                }, this).setIcon(Ext.MessageBox.WARNING);
        }
    }
};
