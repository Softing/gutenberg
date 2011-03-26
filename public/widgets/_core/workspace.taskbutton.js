// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

//Inprint.TaskbarBtn = Ext.extend(Ext.Button, {
Inprint.TaskbarBtn = Ext.extend(Ext.Toolbar.SplitButton, {

    panel: false,
    icon:  '',
    text:  '',
    initComponent : function(){

        this.tooltip = this.text;

        if ( this.description ) {
            this.text =  this.text +' <'+ this.description +'>';
        }

        this.text = Ext.util.Format.ellipsis(this.text || 'Unnamed window', 60);

        Ext.apply(this, {
            panel:        this.panel,
            tooltip:      this.tooltip,
            toggleGroup:  "taskbar",
            enableToggle: true,
            menu : {
                items: [{
                    text: _("Close"),
                    scope: this,
                    icon: _ico("cross"),
                    handler: function() {
                        Inprint.ObjectResolver.remove(this.panel);
                    }
                }]
            }
        });

        Inprint.TaskbarBtn.superclass.initComponent.call(this);

        this.on("click", function(btn) {
            if (btn.pressed) {
                Inprint.ObjectResolver.show(btn.panel);
            } else {
                Inprint.ObjectResolver.hide(btn.panel);
            }
        });
    }

});

Inprint.TaskButton = function(cmp, el) {

    this.cmp = cmp;

    if (! cmp.rawTitle) {
        cmp.rawTitle = 'Unnamed window';
    }

    var text = Ext.util.Format.ellipsis(cmp.rawTitle, 12);
    var tooltip = false;

    if (cmp.rawTitle.length > text.length) {
        tooltip = cmp.rawTitle;
    }

    Ext.apply(this, {
        icon: cmp.icon,
        text: text,
        tooltip: tooltip
    });

    Inprint.TaskButton.superclass.constructor.call(this, {
        renderTo: el,
        handler : function() {
            Inprint.layout.show(cmp);
        },
        clickEvent:'mousedown',
        template: new Ext.Template(
                '<table border="0" cellpadding="0" cellspacing="0" class="x-btn-wrap x-btn x-btn-text-icon"><tbody><tr>',
                '<td class="x-btn-left"><i>&#160;</i></td>',
                '<td class="x-btn-center"><em unselectable="on"><button class="x-btn-text" type="{1}">{0}</button></em></td>',
                '<td class="x-btn-right"><i>&#160;</i></td>',
                "</tr></tbody></table>")
    });
};

Ext.extend(Inprint.TaskButton, Ext.Button, {
    onRender : function() {
        Inprint.TaskButton.superclass.onRender.apply(this, arguments);
    }
});
