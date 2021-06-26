# Go Out

Go Out is an application that allows users to search a specified area on a Google Map. They then get a selection of 5 locations (if available), and they can then invite their friends to an event. From there, the users can accept the invitation, and submit their preference vote. As the votes come in, users can add the events to their calendars and get ready to Go Out!


<img src="https://github.com/g-rahm-b/go_out_flutter/blob/master/images/GoOutLogin.png?raw=true" width="300"> <img src="https://github.com/g-rahm-b/go_out_flutter/blob/master/images/GoOutMap.png?raw=true" width="300"> <img src="https://github.com/g-rahm-b/go_out_flutter/blob/master/images/GoOutPlanning.png?raw=true" width="300"> <img src="https://github.com/g-rahm-b/go_out_flutter/blob/master/images/GoOutVoting.png?raw=true" width="300"> <img src="https://github.com/g-rahm-b/go_out_flutter/blob/master/images/GoOutEvent.png?raw=true" width="300"> <img src="https://github.com/g-rahm-b/go_out_flutter/blob/master/images/GoOutProfile.png?raw=true" width="300">


## Features
- Modern user interface.
- Find and add friends
- Update profile information, including profile pictures.
- Search anywhere in the world to schedule the type of Event that you and your friends (or just you) would like to have.
- Vote on all places returned from the search to ensure the most popular place wins, eliminating indecisiveness.
- Add events directly to your calendar

## Backend and External APIs

I primarly chose Firebase - specifically Firestore - as the backend for ease of setup and scaling. Firebase's Authentication is also easy to set up, and secure. Google Maps and Places APIs were used for retrieving the specified Event details for the users. Please note, if you are testing from an IDE you may need to generate your own API keys. 


## Contributing
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://github.com/g-rahm-b/go_out_flutter/pulls)
[![Bugs](https://img.shields.io/static/v1?label=Bugs&message=Report&color=red&style=flat-square)](https://github.com/g-rahm-b/go_out_flutter/issues)

I encourage anybody to make a pull request. For large changes, please open up a new issue so that we can discuss the changes.


## License
Copyright (c) Graeme Bernier. All rights reserved.
[MIT](https://choosealicense.com/licenses/mit/)
