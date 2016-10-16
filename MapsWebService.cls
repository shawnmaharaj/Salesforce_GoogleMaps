global class MapsWebService {
    
    // return Latitude and Longitude provided a "valid" address
    webservice static MapInfo getGeocodeFromGoogleMaps(String address) { // Address addr
        
       
        System.debug(Logginglevel.INFO, 'initial getGeocodeFromGoogleMaps');
        MapInfo mapInfo = new MapInfo();
            
        HttpRequest req = new HttpRequest();
        
        //Set HTTPRequest Method. Use Post because im sending credential key, slightly more secure then GET because credentials not in URL 
        req.setMethod('POST');

        //Set HTTPRequest header properties
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String apiKey = 'INSERT_API_KEY_HERE';

        req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address=' + address + '&key='+ apiKey);
        
        //Set the HTTPRequest body 
        req.setBody('some post body'); 
        
        Http http = new Http();

     try {

          //Execute web service call to google    
          HTTPResponse res = http.send(req);   
          System.debug(Logginglevel.INFO, res.getBody());
          
          if (res.getStatusCode() == 200) {
          
                // Traverse relevant data I need (Latitude and Longitude) from JSON response
                // --SHOW RESPONSE BODY IN DEBUG LOGS--
                Map<String, Object> googleResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                System.debug(Logginglevel.INFO, 'Map<String, Object> ' + googleResponse);
                
                List<Object> items = (List<Object>) googleResponse.get('results');
                
                for (Object itm : items) {
                    
                    Map<String, Object> results = (Map<String, Object>) itm;

                    
                    Map<String, Object> geometry = (Map<String, Object>) results.get('geometry');
                    
                    System.debug(Logginglevel.INFO, 'GEOMETRY' + geometry);
                    
                    Map<String, Object> location = (Map<String, Object>) geometry.get('location');
                    System.debug(Logginglevel.INFO, 'LOCATION ' + location);
                    
                    mapInfo.Latitude = (Decimal) location.get('lat');
                    mapInfo.Longitude = (Decimal) location.get('lng');
                    System.debug(Logginglevel.INFO, 'LAT ' + mapInfo.Latitude);
                    System.debug(Logginglevel.INFO, 'LNG ' + mapInfo.Longitude);
                    
                } // end - for (Object item: items) 
                
                
          } // end - (res.getStatusCode() == 200)
          
          
          //Helpful debug messages
          System.debug(Logginglevel.INFO, res.toString());
          System.debug(Logginglevel.INFO, 'STATUS:'+res.getStatus());
          System.debug(Logginglevel.INFO, 'STATUS_CODE:'+res.getStatusCode());

        } catch(System.CalloutException e) {
            //Exception handling goes here....
            System.debug(LoggingLevel.Info, e.getMessage());
        } 
        
        return mapInfo;
    }
}