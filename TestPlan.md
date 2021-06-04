    # Ticket Machine Test Plan





# -> changeConfig / stationList test plan
|#| Name|Purpose|Expected|Actual|
|-|-|-|-|-|
|1|changeConfig|get user input to change the ticketMachine Uuid|receive Uuid and update|load ticketMachine configuration|
|2|createStation|create a new station and change its name or zone|new station created/name changed/zone changed|station name updated OR zone updated|
|3|modifyStation|purpose is to modify a existing station name, zone and add a ticket machine|station name or zone updated or new ticket machine added|station name or zone updated or ticket machine added|
|4|deleteStation|deletes a station from the database list|station deleted|station deleted|
|5|deleteStationError|deletes a station without first clearing the ticket machines in the station|couldnt delete station due to existing ticket machine|Error - unable to delete|
|6|deleteAllStations|clears the station list from the database|deletes all stations|all stations deleted|
|7|listStations|list all stations in the current database|list all stations|display a list of stations|
|8|listTicketMachines|lists all the ticket machines in a specific station|list all machines from a station|display all machines in station|


# -> ticketMachine.jsp test plan  

|#| Name|Purpose|Expected|Actual|
|-|-|-|-|-|
|1|getStartStationName|get the departure station name from the user input|assign start station name to a variable|station name assigned to a variable|
|2|getStartStationNameError| set a random name as station name to check if code breaks|error displayed as station name is not accepted|not error displayed (not implemented)|
|3|getStartZone|get the departure station zone and assign it to a variable|assign start zone to a variable|station zone assigned to a variable|
|4|getEndStationName|get the destination station name from the user input and assign it to a variable|assign destination name to a variable|destination name assigned to a variable|
|5|getDestinationZone|get the destination zone and assign to a variable|assign destination zone to a variable|destination zone assigned to a variable|
|6|getZonesTraveled|get the total zones traveled from the user input|assign the traveled zones to a variable|zones traveled assigned to a variable|
|7|calculatePrice|calculate the ticket price using the zones traveled variable * pricePerZone|set a ticket price to the ticket object|produces no result as it is not correctly implemented|
|8|generateTicket|generate a ticket XML code using a encoder|generate a valid ticket XML code|valid ticket XML generated|
|9|generateTicketError|generate a ticket XML using a random name for the stations|ticket XML not generated and error displayed|ticket XML generated (validation and error catching not implemented)|
||||||
||||||



# -> gate.jsp test plan

|#|Name|Purpose|Expected|Actual|
|-|-|-|-|-|
|1|GetArrivalStation| Get the arrival station name from user input to then match the destination station on the ticket|get a valid station name and display it|displays the station name|
|2|GetArrivalStationError|get the arrival station name from user input, but the user has left the field blank OR with invalid station name|the station name will be invalid|Valid Station boolean will be false|
|3|DecodeTicket|get the ticket XML data from user and decode it to check if the Hash matches and the ticket is valid|display the ticket data|display ticket XML data|
|4|DecodeTicketError|get ticket data from user and change a letter in the ticket Hash|decoding will fail |gate remains closed as Hash doesnt match|
|5|ValidateDate|check the arrival time and check against the time the ticket was issued and check if its valid|get the current time and compare with ticket and if  valid, open the gate|display gate is open|
|6|ValidateDateNotValid|set the arrival time to more than 4 hours after the ticket issue date and check if valid|expected to fail because the arrival time is after the 4 hour limit for a ticket|display gate is locked| 
|7|ValidateStation|get the destination station from the ticket and check if it matches the arrival station|Stations match and boolean validStation is true|validStation is true|
|8|ValidateStationError|get the destination station from the ticket and set a different station as arrival station|Stations dont match and boolean validStation will remain false|validStation is false and gate will remain closed|
|9|OpenGate| check if the booleans validStation, validDate and validFormat are all true and open gate|booleans are all valid and gate will open|Gate opens|
|10|OpenGateError|one the booleans is false and gate will not open|gate will remain closed as not all booleans are valid|Gate remains closed|

    
