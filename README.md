# DB Project - Task 1

# Ranch Manager

## Group

Alvacir Wesley Kalatai Alberti

## Purpose

To store the data of the day-to-day operations of a cattle ranch (more coming soon).

Cattle farming is a tradition in many parts of the world, making up a billion dollar industry, and central to that success, are the animals - many animals mind you, in the world, the total cattle population is estimated to be equal to 987.5 million heads (World Cattle Inventory: Ranking Of Countries - USDA), some places, like my home country Brazil, have actually more cattle than people. Gone was the time where a cattle ranch would buy calves from a neighbor, just to put them in their land to feed and raise until the selling point was reached, without keeping any kind of record for the calves, or tracking the weight progression of the cow. Nowadays, cattle ranches have adopted the practices of the information age, as everything is measured and tracked. From the moment the calf steps for the first time in the ranch, it's weight is recorded, where it came from and what to expect from it comes from who sold it, every day the calf spent in the ranch, the amount of food it consumes, the weight it has gained, all the expenses it represents are also noted.

All of those things are data. Data which can be recorded, and there is no better way to record it than in a database. Having this data somewhere makes it possible to build on top of it, and the main idea for it is to be the backbone of a ranch management system, and the main target audience are small and medium ranchers of developing countries, that still do things the way they were done a century ago. The aim of the solution is to be a cost effective and easy-to-use system to keep track of cattle, and how to profit the most from the cattle, being able to see where are the places money is being lost or where it can be made.

## Data Requirements

Along with my knowledge of the area, I interviewed Thalliny Nayara, a Brazilian veterinarian specialized in cattle care. The data the must be present in the database is as follows:

- Cattle
    - Unique ID for a particular cow
    - The tag number (after the cow exits the ranch, the tag number must be set to NULL - opportunity for a trigger)
    - Price bought (if bought)
    - Weight at birth
    - Weight at reception (if bought from elsewhere)
    - Date born
    - Date received (if bought from elsewhere)
    - Parents (if data is available)
- Operation
    - Daily / weekly / monthly weight recordings (depends on the ranch's process)
    - Total food consumed per month (if the cattle is in a intensive system)
    - Average food consumption per day
    - Vaccines (recording the vaccines that have yet to be administered and the ones that have already been administered -  record the type and dates)
    - Illnesses
    - Medical procedures
    - Miscellaneous reports
    - Price sold
    - Value added
    - The time it remained in the ranch
- Food
    - Price per kilogram of the food (intensive operations)
    - Amount used per day / week / month
- Ranch
    - Ranch unique ID (Allows for better identification and tracking of cattle)
    - Ranch location (address and/or geolocation)
    - Ranch name
    - Ranch owner
    - Person responsible
    - Employees
    - Costs (Fixed and variable)

## Functional Requirements

The application is already being hosted at https://super-violet-8783.on.fleek.co/ using Fleek, that is a handy and cool tool I use to deploy projects on IPFS. The application will be comprised of a simple detailed view for any specific cow, specified by it's ID or current tag number. In this application one will be able to see all the details about the history of this particular cow, and edit the information that can be edited, like medical procedures and vaccines that have been administered. This is only for testing purposes, as the final product would be bundled in a desktop or mobile application, where the ranch employees and management would be able to input new data for the incoming cattle, modify and add data for the cattle already present in the ranch and add the records for when cattle are sold. This makes it possible for the ranch to be well administered, and all the bottlenecks and money pits to be known, ensuring the best management possible for the operation.