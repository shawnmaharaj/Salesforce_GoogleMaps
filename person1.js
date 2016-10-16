var appModule = angular.module('PersonApp', []);

appModule.controller('PersonController',
        ['$scope', '$window', '$document', '$attrs', personController]);
		

function personController($scope, $window, $document, $attrs) {
	$scope.personEntity = new $Person.Entity();
	$scope.personList = [];
	getPerson();
	googleMap(-34.397, 150.644);
	
	function getPerson() {
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
	
	$scope.Refresh = function () {
		PersonController1.savePerson($scope.Name, $scope.Age, function(result, event) {
			if(event.status) {
				$scope.personList = [];
				getPerson();
			}
		});
		//getPerson();
	}
	
	$scope.GetGeocode = function () {
		PersonController1.TestWebService(function(result, event) {
			if(event.status) {
				$scope.Latitude =  result.Latitude;
				$scope.Longitude =  result.Longitude;
				googleMap($scope.Latitude, $scope.Longitude);
				$scope.$apply();
			}
		});
		//getPerson();
	}
	
	function googleMap(latitude, longitude) {
	  $window.map = new google.maps.Map(document.getElementById('map1'), {
	      center: {
		
		  lat: latitude,
		  lng: longitude
	      },
	      zoom: 8
	  });
	}
	
	
	
} // END personController($scope, $window, $document, $attrs)
