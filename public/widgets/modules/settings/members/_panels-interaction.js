Inprint.settings.members.Interaction = function(panels) {

    var members = panels.members;
    var accounts = panels.accounts;
    var groups = panels.groups;
    var usercard = panels.usercard;
    var access = panels.access;
    var help = panels.help;
    var tab = panels.tab;

    // Members

    members.btnAdd.enable();

    members.getSelectionModel().on("selectionchange", function(sm) {

        if (sm.getCount())
            _enable(members.btnEnable, members.btnPasswd, members.btnDisable, members.btnRemove);
        else
            _disable(members.btnEnable, members.btnPasswd, members.btnDisable, members.btnRemove);

        if (sm.getCount() == 1) {
            _enable(members.btnEdit);
            accounts.enable();
            accounts.cmpLoad({ member: members.getValue("id") });
        } else {
            _disable(members.btnEdit);
            accounts.disable();
            accounts.getSelectionModel().clearSelections();
        }

    }, this);

    // Accounts

    accounts.getSelectionModel().on("selectionchange", function(sm) {

        if (sm.getCount())
            _enable(accounts.btnAdd, accounts.btnRemove);
        else
            _disable(accounts.btnAdd, accounts.btnRemove);

        if (sm.getCount() == 1) {
            groups.enable();
            usercard.enable();
            access.enable();
            tab.activate(usercard);
            usercard.cmpFill( accounts.getValue("id"), accounts.getValue("metadata") );
        } else {
            groups.disable();
            usercard.disable();
            access.disable();
            tab.activate(help);
        }

    });

    // Usercard
    usercard.on("actioncomplete", function() {
        accounts.cmpReload();
    });

    // Departmets
    groups.on("activate", function() {
        groups.params = {
            account: accounts.getValue("id"),
            edition: accounts.getValue("edition")
        }
        groups.cmpLoad();
    });

    groups.getSelectionModel().on("selectionchange", function(sm) {

        if (sm.getCount())
            _enable(groups.btnSave);
        else
            _disable(groups.btnSave);

    });

    // Access
    access.on("activate", function() {
        access.params = {
            account: accounts.getValue("id")
        }
        access.cmpLoad();
    });

}