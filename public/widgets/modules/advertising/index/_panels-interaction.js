Inprint.advert.index.Interaction = function(parent, panels) {

    var editions  = panels.editions;
    var modules   = panels.modules;
    var headlines = panels["headlines"];

    // Tree
    editions.getSelectionModel().on("selectionchange", function(sm, node) {
        modules.disable();
        headlines.disable();
        
        if (node && node.attributes.type == "place") {
            
            parent.edition = node.attributes.edition;
            
            modules.enable();
            modules.place = node.id;
            modules.cmpLoad({ edition: parent.edition, place: modules.place });
            
            headlines.enable();
            headlines.place = node.id;
            headlines.cmpLoad({ edition: parent.edition, place: headlines.place });
            
        }
    });

    //Grids
    modules.getSelectionModel().on("selectionchange", function(sm) {
        _enable(modules.btnSave);
    }, parent);
    
    headlines.getSelectionModel().on("selectionchange", function(sm) {
        _enable(headlines.btnSave);
    }, parent);

}
