Inprint.fascicle.places.Interaction = function(parent, panels) {

    var places = panels["places"];
    var modules   = panels["modules"];
    var headlines = panels["headlines"];

    // Tree
    places.getSelectionModel().on("selectionchange", function(sm, node) {
        
        modules.disable();
        headlines.disable();
        
        if (node && node.attributes.type == "place") {
            parent.edition = node.attributes.edition;
            modules.enable();
            modules.cmpLoad({ edition: node.attributes.edition });
            headlines.enable();
            headlines.cmpLoad({ edition: node.attributes.edition });
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
