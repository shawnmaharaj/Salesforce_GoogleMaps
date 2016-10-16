public class PersonController {

    public String keyword {get; set;}
    public List<Person__c> people {get; set;} 
    public Person person {get; set;} 
    
    public PersonController() {
        person = new Person();
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
    
    public PageReference saveperson() {
        
        Person__c p = new Person__c(
            Name__c=person.Name, 
            Age__c=person.Age, 
            Date_of_Birth__c=person.DateOfBirth, 
            IsEmployed__c=person.IsEmployed, 
            Phone_Number__c=person.PhoneNumber, 
            Sex__c=person.Sex);
            
        insert p;

        return null;
    }
    
    public PageReference search() {
        // SOSL query
        people = (List<Person__c>) [FIND :keyword IN ALL FIELDS RETURNING Person__c(Name__c, Age__c, Date_of_Birth__c, IsEmployed__c, Phone_Number__c, Sex__c)][0];
        return null;
    }

}