@isTest
global class TestSuite {
    
    @isTest
    public static void testAccountCallout() {
        // traction on demand, 2700+Production+Way+Burnaby+BC,+V5A+0C2+Canada
        Integer streetNumber = 2700;
        String streetName = 'Production Way';
        String city = 'Burnaby'; 
        String province = 'BC';
        String postalCode = 'V5A 0C2';
        String country = 'Canada';
        String address = streetNumber + ' ' + streetName + ' ' + city + ' ' + province + ', ' + postalCode + ' ' + country;
        
        // for url encoding
        address = address.replaceAll('\\s', '+');
    
        RestMock fakeResponse = new RestMock(address);
        
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        MapInfo mapInfo = MapsWebService.getGeocodeFromGoogleMaps(address);
        
        System.assertEquals(mapInfo.Latitude, 49.2598871);
        System.assertEquals(mapInfo.Longitude, -122.9157945);
    }

    // LOOK AT
    // http://salesforce.stackexchange.com/questions/88006/methods-defined-as-testmethod-do-not-support-web-service-callouts-test-skipped
    
    private class RestMock implements HTTPCalloutMock {
        
        public String Addr { get; set; } 
        public RestMock(string address) {
            Addr = address; 
        }
        
        // I should have probably make the webservice more generic (e.g. returning an HTTPResponse object) 
        // That way I could unit test the webservice more thoroughly (i.e. check the http response status == 200)
        
        public HTTPResponse respond(HTTPRequest req){
            // traction on demand, 2700+Production+Way+Burnaby+BC,+V5A+0C2+Canada
            Integer streetNumber = 2700;
            String streetName = 'Production Way';
            String city = 'Burnaby'; 
            String province = 'BC';
            String postalCode = 'V5A 0C2';
            String country = 'Canada';
            String address = streetNumber + ' ' + streetName + ' ' + city + ' ' + province + ', ' + postalCode + ' ' + country;
            
            // for url encoding
            address = address.replaceAll('\\s', '+');
            System.debug(Logginglevel.INFO, 'GeocodeWebService ' + address);
        
            
            req = new HttpRequest();
            req.setMethod('POST');
    
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            String apiKey = 'AIzaSyBnGK5AFG9P5qbvbz0BiWbdpesFdeLKWwo';
            req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address=' + address + '&key='+ apiKey);
            
            //Set the HTTPRequest body 
            req.setBody('some post body'); 
                
            Http http = new Http();
    
            //Execute web service call to google    
            HTTPResponse res = http.send(req);  
            
            return res;
        }
    }

    
}