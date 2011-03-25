Ext.ns('Ext.ux','Ext.ux.form');

Ext.ux.form.TreeCombo = Ext.extend(Ext.form.TriggerField, {

    defaultAutoCreate : {tag: "input", type: "text", size: "24", autocomplete: "off"},
    triggerClass: 'x-form-tree-trigger',

    initComponent : function(){

        this.editable = false;

        this.isExpanded = false;
        if (!this.sepperator) {
            this.sepperator=','
        }

        Ext.ux.form.TreeCombo.superclass.initComponent.call(this);

        this.on('specialkey', function(f, e){
            if(e.getKey() == e.ENTER){
                this.onTriggerClick();
            }
        }, this);

    },

    onRender : function(ct, position){
        Ext.ux.form.TreeCombo.superclass.onRender.call(this, ct, position);
        this.hiddenField = this.el.insertSibling({tag:'input', type:'hidden', name: this.hiddenName,
                    id: (this.hiddenId || Ext.id())}, 'before', true);
    },

    onTriggerClick: function() {
        if (this.disabled == false) {
            if (this.isExpanded) {
                this.collapse();
            } else {
                this.expand();
            }
        }
    },

    // was called combobox was collapse
    collapse: function() {
        this.isExpanded=false;
        this.getTree().hide();
    },

    // was called combobox was expand
    expand: function () {
        this.isExpanded=true;
        this.getTree().show();
        this.getTree().getEl().alignTo(this.wrap, 'tl-bl?');
    },

    getName: function(){
        return this.hiddenName || this.name;
    },

    getValue: function() {
        return this.hiddenField.value;
    },

    setValue: function (id, v) {
        if (v) {

            this.value = v;
            this.setRawValue(v);
            this.hiddenField.value = id;

        } else {
            this.setRawValue(id);
        }

        if(this.rendered) {
            this.validate();
        }

        return this;
    },

    validateBlur : function(){
        return !this.treePanel || !this.treePanel.isVisible();
    },

    /*
     * following functions are using by treePanel
     */

    getTree: function() {
        if (!this.treePanel) {

            if (!this.treeWidth) {
                this.treeWidth = Math.max(200, this.width || 200);
            }

            if (!this.treeHeight) {
                this.treeHeight = 200;
            }

            this.treePanel = new Ext.tree.TreePanel({
                renderTo: Ext.getBody(),
                loader: new Ext.tree.TreeLoader({
                    url: this.url,
                    preloadChildren: false,
                    baseParams: this.baseParams
                }),
                root: this.root,
                rootVisible: this.rootVisible,
                floating: true,
                autoScroll: true,
                minWidth: 250,
                minHeight: 300,
                width: this.treeWidth,
                height: this.treeHeight,
                listeners: {
                    hide: this.onTreeHide,
                    show: this.onTreeShow,
                    click: this.onTreeNodeClick,
                    expandnode: this.onExpandOrCollapseNode,
                    collapsenode: this.onExpandOrCollapseNode,
                    resize: this.onTreeResize,
                    scope: this
                }
            });

            this.treePanel.show();
            this.treePanel.hide();

            this.relayEvents(this.treePanel.loader, ['beforeload', 'load', 'loadexception']);

            if(this.resizable){
                this.resizer = new Ext.Resizable(this.treePanel.getEl(),  {
                   pinned:true, handles:'se'
                });
                this.mon(this.resizer, 'resize', function(r, w, h){
                    this.treePanel.setSize(w, h);
                }, this);
            }

            this.treePanel.on("beforeappend", function(tree, parent, node) {
                if (node.attributes.icon == undefined) {
                    node.attributes.icon = 'folder-open';
                }
                node.attributes.icon = _ico(node.attributes.icon);
                if (node.attributes.color) {
                    node.text = "<span style=\"color:#"+ node.attributes.color +"\">" + node.attributes.text + "</span>";
                }
            });

        }
        return this.treePanel;
    },

    onExpandOrCollapseNode: function() {
        if (!this.maxHeight || this.resizable)
            return;  // -----------------------------> RETURN
        var treeEl = this.treePanel.getTreeEl();
        var heightPadding = treeEl.getHeight() - treeEl.dom.clientHeight;
        var ulEl = treeEl.child('ul');  // Get the underlying tree element
        var heightRequired = ulEl.getHeight() + heightPadding;
        if (heightRequired > this.maxHeight)
            heightRequired = this.maxHeight;
        this.treePanel.setHeight(heightRequired);
    },

    onTreeResize: function() {
        if (this.treePanel)
            this.treePanel.getEl().alignTo(this.wrap, 'tl-bl?');
    },

    onTreeShow: function() {
        Ext.getDoc().on('mousewheel', this.collapseIf, this);
        Ext.getDoc().on('mousedown', this.collapseIf, this);
    },

    onTreeHide: function() {
        Ext.getDoc().un('mousewheel', this.collapseIf, this);
        Ext.getDoc().un('mousedown', this.collapseIf, this);
    },

    collapseIf : function(e){
        if(!e.within(this.wrap) && !e.within(this.getTree().getEl())){
            this.collapse();
        }
    },

    onTreeNodeClick: function(node, e) {
        this.setValue(node.id, node.text);
        this.fireEvent('select', this, node);
        this.collapse();
    }

});

Ext.reg('treecombo', Ext.ux.form.TreeCombo);
