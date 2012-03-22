Inprint.cmp.memberProfile.Panel = Ext.extend(Ext.Panel, {
    initComponent: function() {

        Ext.apply(this, {
            autoScroll:true,
            bodyStyle: "padding: 10px 10px",
            tpl: new Ext.XTemplate(
                '<div class=" x-panel x-panel-noborder x-form-label-left x-column" style="width: 169px;">'+
                    '<div class="x-panel-bwrap">'+
                        '<div class="x-panel-body x-panel-body-noheader x-panel-body-noborder" style="width: 159px;">'+

                            '<fieldset class=" x-fieldset x-form-label-left" style="width: 137px;">'+
                                '<legend class="x-fieldset-header x-unselectable" style="-moz-user-select: none;">'+
                                    '<span class="x-fieldset-header-text">'+ _("Photo") +'</span>'+
                                '</legend>'+
                                '<div class="x-fieldset-bwrap">'+
                                    '<div class="x-fieldset-body" style="width: 137px;">'+
                                        '<div tabindex="-1" class="x-form-item  x-hide-label">'+

                                            '<div style="padding-left: 45px;" class="x-form-element">'+
                                                '<img name="imagefield" class="x-form-field" src="/profile/image/{id}" style="width: 137px;"></div>'+
                                                '<div class="x-form-clear-left"></div>'+
                                            '</div>'+
                                    '</div>'+
                                '</div>'+
                            '</fieldset>'+

                        '</div>'+
                    '</div>'+
                '</div>'+

                '<div class=" x-panel x-panel-noborder x-form-label-left x-column" style="width: 394px;">'+
                    '<div class="x-panel-bwrap">'+
                        '<div class="x-panel-body x-panel-body-noheader x-panel-body-noborder" style="width: 394px;">'+
                            '<fieldset class=" x-fieldset x-form-label-left" style="width: 372px;">'+
                                '<legend class="x-fieldset-header x-unselectable" style="-moz-user-select: none;">'+
                                    '<span class="x-fieldset-header-text">'+ _("System profile") +'</span>'+
                                '</legend>'+
                                '<div class="x-fieldset-bwrap">'+
                                    '<div class="x-fieldset-body" style="width: 372px;">'+
                                        '<div tabindex="-1" class="x-form-item " >'+
                                            '<label class="x-form-item-label" style="width: 60px;">'+ _("ID") +':</label>'+
                                            '<div style="padding-left: 65px;" class="x-form-element">'+
                                                '{id}'+
                                            '</div>'+
                                            '<div class="x-form-clear-left"></div>'+
                                        '</div>'+
                                        '<div tabindex="-1" class="x-form-item " >'+
                                            '<label class="x-form-item-label" style="width: 60px;">'+ _("Login") +':</label>'+
                                            '<div style="padding-left: 65px;" class="x-form-element">'+
                                                '{login}'+
                                            '</div>'+
                                            '<div class="x-form-clear-left"></div>'+
                                        '</div>'+
                                    '</div>'+
                                '</div>'+
                            '</fieldset>'+
                            '<fieldset class=" x-fieldset x-form-label-left" style="width: 372px;">'+
                                '<legend class="x-fieldset-header x-unselectable" style="-moz-user-select: none;">'+
                                    '<span class="x-fieldset-header-text">'+ _("Employee profile") +'</span>'+
                                '</legend>'+
                                '<div class="x-fieldset-bwrap">'+
                                    '<div class="x-fieldset-body" style="width: 372px;">'+
                                        '<div tabindex="-1" class="x-form-item " >'+
                                            '<label class="x-form-item-label" style="width: 60px;">'+ _("Title") +':</label>'+
                                            '<div style="padding-left: 65px;" class="x-form-element">'+
                                                '{title}'+
                                            '</div>'+
                                            '<div class="x-form-clear-left"></div>'+
                                        '</div>'+
                                        '<div tabindex="-1" class="x-form-item " >'+
                                            '<label class="x-form-item-label" style="width: 60px;">'+ _("Shortcut") +':</label>'+
                                            '<div style="padding-left: 65px;" class="x-form-element">'+
                                                '{shortcut}'+
                                            '</div>'+
                                            '<div class="x-form-clear-left"></div>'+
                                        '</div>'+
                                        '<div tabindex="-1" class="x-form-item " >'+
                                            '<label class="x-form-item-label" style="width: 60px;">'+ _("Position") +':</label>'+
                                            '<div style="padding-left: 65px;" class="x-form-element">'+
                                                '{position}'+
                                            '</div>'+
                                            '<div class="x-form-clear-left"></div>'+
                                        '</div>'+
                                    '</div>'+
                                '</div>'+
                            '</fieldset>'+
                        '</div>'+
                    '</div>'+
                '</div>'
            )
        });

        Inprint.cmp.memberProfile.Panel.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.cmp.memberProfile.Panel.superclass.onRender.apply(this, arguments);
    }

});
