var appModule = angular.module('PersonApp', []);

appModule.controller('PersonController',
        ['$scope', '$window', '$document', '$attrs', personController]);
		

function personController($scope, $window, $document, $attrs) {
	$scope.personEntity = new $Person.Entity();
	$scope.personList = [];
	RefreshPerson();
	
	function RefreshPerson() {
		$scope.personEntity.retrieve({limit: 100}, function(err, records, event){
		if (err) {
			alert(err.messsage);
		}
		else {
			records.forEach(function(record) {
				var name__c = record.get("Name__c");
				var age__c = record.get("Age__c");
				var person = {
					Name: name__c, 
					Age: age__c
				};
				//alert('record.get(Name__c) ' + record.get("Name__c"));
				//alert('record.get(Age__c) ' + record.get("Age__c"));
				$scope.personList.push(person);
			})
			
			$scope.$apply();
		} // end else
	  });// end retrieve( ...
	}
	
	(function() {
		
	})();// end (function() { ...
	
} // END personController($scope, $window, $document, $attrs)
