Inprint.cmp.memberRulesForm.Interaction = function(main, panels) {

    var domainPanel = main.cmpGetDomainPanel();
    var editionsPanel = main.cmpGetEditionsPanel();
    var organizationPanel = main.cmpGetOrganizationPanel();

    main.panels.tabs.btnSave.on("click", function(){
            main.cmpSave( main.panels.tabs.getActiveTab().cmpGetGrid() );
        });

    main.panels.tabs.btnClear.on("click", function(){
            main.cmpClear( main.panels.tabs.getActiveTab().cmpGetGrid() );
        });

    // Domain

    domainPanel.on("activate", function() {
        main.cmpFill(
            domainPanel.cmpGetGrid()
        );
    });

    // Editions

    editionsPanel.cmpGetTree().getSelectionModel().on("selectionchange", function(sm, node) {

        var grid = editionsPanel.cmpGetGrid();
        grid.enable();
        grid.cmpSetBinding(node.id);
        if (node) main.cmpFill( grid );
    });

    // Catalog

    organizationPanel.cmpGetTree().getSelectionModel().on("selectionchange", function(sm, node) {
        var grid = organizationPanel.cmpGetGrid();
        grid.enable();
        grid.cmpSetBinding(node.id);
        if (node) main.cmpFill( grid );
    });

};
