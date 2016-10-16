global class PersonController1 {

    public String keyword {get; set;}
    public List<Person__c> people {get; set;} 
    public static Person person {get; set;} 
    
    //public MapInfo mapInfo {get; set;} 
    
    public PersonController1() {
        //person = new Person();
    }
    
    public String getKeyword() {
        return keyword;
    }
    
    public void setKeyword(String searchName) {
        keyword = searchName;
    }
    
    public List<Person__c> getPeople() {
        return people;
    }
    
    @RemoteAction
    global static PageReference savePerson(String Name, Integer Age) {
        
        Person__c p = new Person__c(
            Name__c=Name, 
            Age__c=Age );
            //Date_of_Birth__c=person.DateOfBirth, 
            //IsEmployed__c=person.IsEmployed, 
            //Phone_Number__c=person.PhoneNumber, 
            //Sex__c=person.Sex);
            
        insert p;

        return null;
    }
    
    
    
    public PageReference search() {
        // SOSL query
        people = (List<Person__c>) [FIND :keyword IN ALL FIELDS RETURNING Person__c(Name__c, Age__c, Date_of_Birth__c, IsEmployed__c, Phone_Number__c, Sex__c)][0];
        return null;
    }
    
    @RemoteAction
    global static Object TestWebService() {
        //MapsWebService ws = new MapsWebService();
        string address = 'V5A+0C2';
        MapInfo mapInfo = MapsWebService.getGeocodeFromGoogleMaps(address);
        
        return mapInfo;
    }

}