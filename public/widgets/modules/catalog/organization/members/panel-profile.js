Inprint.member.Profile = Ext.extend(Ext.Panel, {
    initComponent: function() {

        Ext.apply(this, {
            title: _("Profile"),
            autoScroll:true,
            disabled:true,
            tpl: new Ext.XTemplate(
                '<h1>{name}</h1>',
                '<img src="/profile/image/{id}">',
                '<p>ID: {id}</p>',
                '<p>Login: {login}</p>',
                '<p>Email: {email}</p>',
                '<hr>',
                '<p>Shortcut: {shortcut}</p>',
                '<p>Position: {position}</p>'
            )
        });

        Inprint.member.Profile.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.member.Profile.superclass.onRender.apply(this, arguments);
    },

    cmpFill: function(record) {
        if (record)
            this.tpl.overwrite(this.body, record.data);
    }

});
