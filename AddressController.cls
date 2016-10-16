global class AddressController {
    
    public Address address {get; set;}
    
    public AddressController() {
        address = new Address();
    }
    
    // save Address__c object via standard apex
    public PageReference saveAddress() {
    
        /*
        System.debug(Logginglevel.INFO, address.City);
        System.debug(Logginglevel.INFO, address.Country);
        System.debug(Logginglevel.INFO, address.Province);
        System.debug(Logginglevel.INFO, address.PostalCode);
        System.debug(Logginglevel.INFO, address.StreetName);
        System.debug(Logginglevel.INFO, address.StreetNumber);
        */
        // insert
        Address__c addr = new Address__c(
            City__c=address.City, 
            Country__c=address.Country, 
            Province__c=address.Province,
            Postal_Code__c=address.PostalCode, 
            Street_Name__c=address.StreetName, 
            StreetNumber__c=address.StreetNumber);
        
        System.debug(Logginglevel.INFO, 'ADDRESS - ' + addr);
        insert addr;

        return null;
    }
    
    // save Address__c object via javascript remote action to not use ViewState
    @RemoteAction
    global static PageReference saveAddress(Integer streetNumber, String streetName, String city, String postalCode, String province, String country) {
        
        /*    
        System.debug(Logginglevel.INFO, 'saveAddress ' + city);
        System.debug(Logginglevel.INFO, 'saveAddress ' + country);
        System.debug(Logginglevel.INFO, 'saveAddress ' + province);
        System.debug(Logginglevel.INFO, 'saveAddress ' + postalCode);
        System.debug(Logginglevel.INFO, 'saveAddress ' + streetName);
        System.debug(Logginglevel.INFO, 'saveAddress ' + streetNumber);
        */
        
        Address__c addr = new Address__c(
            City__c=city, 
            Country__c=country, 
            Province__c=province,
            Postal_Code__c=postalCode, 
            Street_Name__c=streetName, 
            StreetNumber__c=streetNumber);
        
        System.debug(Logginglevel.INFO, 'SAVE ADDRESS VIA ANGULAR- ' + addr);
        insert addr;

        return null;
    }
    
    // parse address as a string properly and send to my custom webservice 
    @RemoteAction
    global static Object GeocodeWebService(String streetNumber, String streetName, String city, String postalCode, String province, String country) {
        
        /*
        System.debug(Logginglevel.INFO, 'GeocodeWebService ' + city);
        System.debug(Logginglevel.INFO, 'GeocodeWebService ' + country);
        System.debug(Logginglevel.INFO, 'GeocodeWebService ' + province);
        System.debug(Logginglevel.INFO, 'GeocodeWebService ' + postalCode);
        System.debug(Logginglevel.INFO, 'GeocodeWebService ' + streetName);
        System.debug(Logginglevel.INFO, 'GeocodeWebService ' + streetNumber);
        */
        
        string address = streetNumber + ' ' + streetName + ' ' + city + ' ' + province + ', ' + postalCode + ' ' + country;
        
        // for url encoding
        address = address.replaceAll('\\s', '+');
        System.debug(Logginglevel.INFO, 'GeocodeWebService ' + address);
        MapInfo mapInfo = MapsWebService.getGeocodeFromGoogleMaps(address);
        
        return mapInfo;
    }
    
}