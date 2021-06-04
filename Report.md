    # Report

## Use Case diagram

The Use case diagram has 4 different "users" that have different access to the program and different roles. The client role is to make use of the ticket machine to create tickets and then to use the gate to validate its ticket. the station manager role is to configure the system by creating, modifying or deleting stations and ticket machines.

Most of the use cases in the diagram have been implemented successfully with some exceptions. The payment check was not implemented as i was not able to properly calculate the number of zones traveled and displaying the ticket price. The station validation check on the gate.jsp was build to check if the destination station in the ticket is the same as the arrival station. this was done like this because my logic is that , if you buy a ticket for a specific station, you will need to leave at that station.


## Robustness diagram

The Robustness diagram has 2 users and allows us to see how the program works and how the methods of each file come together to form the objects used by the program. The station manager uses the stationList.jsp and ticketMachine.jsp files to apply CRUD operations to the stations and ticket machines. the station manager also uses the gate.jsp to decode the ticket presented by the customer and check if its valid and can also change a ticket machine configuration with the changeConfig.jsp file. The user also uses the ticketMachine.jsp to create its ticket and the gate.jsp file to validate its ticket at he exit.


## Test plan

The test plan consists of extensive tests of my use cases where i test the essential methods of the program and also the customer side methods where data is manually inputed which is where most errors can occur.


# Code Evaluation

## Ticket

In the ticket file i added 1 more variable endZone so i could assign the zone of the destination station so i could calculate the traveled zones and with that calculate the price. unfortunatly i was not able to complete this task but i still left the new variable in the ticket file because it causes no conflict.

## Ticket Machine

In the ticket machine file i tried to calculate the zones traveled but couldnt finish this task, so i left the code in the file and the html code commented out to avoid confusion.

## Gate

In the gate file i decided to create 3 validators to check if the ticket is in the right station, in the correct format and within the valid travel time of 4 hours. for the station validation i choose to check if the destination station in the ticket and the arrival station match because this is how a train station system works in the World.
    
