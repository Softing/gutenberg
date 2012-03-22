Inprint.cmp.memberRulesForm.Interaction = function(main, panels) {

    var domainPanel = main.cmpGetDomainPanel();
    var editionsPanel = main.cmpGetEditionsPanel();
    var organizationPanel = main.cmpGetOrganizationPanel();

    var handlerSave = function(){
            main.cmpSave( main.panels.tabs.getActiveTab().cmpGetGrid() );
        };

    var handlerClear = function(){
            main.cmpClear( main.panels.tabs.getActiveTab().cmpGetGrid() );
        };

    main.panels.domain.cmpGetGrid().btnSave.on("click", handlerSave);
    main.panels.editions.cmpGetGrid().btnSave.on("click", handlerSave);
    main.panels.organization.cmpGetGrid().btnSave.on("click", handlerSave);

    main.panels.editions.cmpGetGrid().btnClear.on("click", handlerClear);
    main.panels.organization.cmpGetGrid().btnClear.on("click", handlerClear);

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
