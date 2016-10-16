var appModule = angular.module('AddressApp', []);

appModule.controller('AngularController',
        ['$scope', '$window', '$document', '$attrs', addressMapController]);
		

function addressMapController($scope, $window, $document, $attrs) {
	// connect apex "Address" table to angular
	$scope.addressEntity = new $Address.AddressEntity();
	
	// -- Initialize angular objects and functions -- //
	$scope.addressList = [];
	$scope.addr = {
		StreetNumber: null,
		StreetName: '',
		City: '',
		PostalCode: '',
		Province: '',
		Country: 'Canada'
	};
	
	getAddresses();
	googleMap(-34.397, 150.644); // somewhere in australia
	// -- Initialize angular objects and functions -- //
	
	// gets all addresses from server and binds them to angular scope
	function getAddresses() {
		$scope.addressEntity.retrieve({limit: 100}, function(err, records, event) {
		    if (err) {
			    // todo - more sophisticated logging needed
			    alert(err.messsage);
		    }
		    else {
			    records.forEach(function(record) {
				    var street_name__c = record.get("Street_Name__c");
				    var street_number__c = record.get("StreetNumber__c");
				    var city__c = record.get("City__c");
				    var postal_code__c = record.get("Postal_Code__c");
				    var province__c = record.get("Province__c");
				    var country__c = record.get("Country__c");
				    
				    var address = {
					    StreetName: street_name__c, 
					    StreetNumber: street_number__c,
					    City: city__c,
					    PostalCode: postal_code__c,
					    Province: province__c,
					    Country: country__c
				    };
				    //alert('record.get(Name__c) ' + record.get("Name__c"));
				    //alert('record.get(Age__c) ' + record.get("Age__c"));
				    $scope.addressList.push(address);
			    })
			    
			    $scope.$apply();
		    } // end else
		});// end retrieve( ...
	} // end getAddresses()
	
	
	$scope.SaveAndRefreshAddress = function () {
	  
	  // call saveAddress method in apex controller "AddressController"
		AddressController.saveAddress($scope.addr.StreetNumber, $scope.addr.StreetName, $scope.addr.City, $scope.addr.PostalCode, $scope.addr.Province, $scope.addr.Country, 
		  function(result, event) {
			if(event.status) {
				// rebind angular table
				$scope.addressList = [];
				getAddresses();
				
				// reset address parameters
				$scope.addr.StreetNumber = null;
				$scope.addr.StreetName = '';
				$scope.addr.City = '';
				$scope.addr.PostalCode = '';
				$scope.addr.Province = '';
				$scope.addr.Country = 'Canada';
				
			}
			else {
			    // todo - more sophisticated logging needed
			}
		});
	}
	
	
	// Call apex webservice "getGeocodeFromGoogleMaps" that encapulates process of calling google's geocode webservice 
	// pass in address parameters, return latitude and longitude coordinates from google
	$scope.GetGeocode = function (streetNumber, streetName, city, postalCode, province, country) {
		AddressController.GeocodeWebService(streetNumber, streetName, city, postalCode, province, country, 
		  function(result, event) {
			if(event.status) {
				$scope.Latitude =  result.Latitude;
				$scope.Longitude =  result.Longitude;
				googleMap($scope.Latitude, $scope.Longitude);
				$scope.$apply();
			}
			else {
			    // todo - more sophisticated logging needed
			}
		});
	} // end $scope.GetGeocode ..
	
	
	// create google map in visualforce via google maps API v3
	function googleMap(latitude, longitude) {
		var location = {lat: latitude, lng: longitude};
		
		var mapDiv = document.getElementById('map');

		// direct DOM manipulate is discouraged by angular this map module should be encapsulated in an custom directive, 
		// but this is a simple example...
		
		// Custom directives: reusable components inside your view (similar to user controls like apex:component). 
		// Angular Directive: An instruction given to angular to manipulate a piece of the DOM, i.e. ng-scope
		// Service or "Factory": singleton objects that can be injected into our controllers and can be shared across pages
		
		// create google map object and bind to window object.
		$window.map = new google.maps.Map(mapDiv, {
		  center: {
		
			lat: latitude,
			lng: longitude
		  },
		  position: marker,
		  zoom: 19
		});
		
		// create red marker on the google map
		var marker = new google.maps.Marker({
		  position: location,
		  map: $window.map
		});
	  
	} // end googleMap(..
	

	
	
	
} // END addressMapController($scope, $window, $document, $attrs)
