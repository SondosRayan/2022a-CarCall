# Database

> we used Google firebase, and StreamBuilders in order to be able to listen to database changes. 

## Database Structure

In our database, we stored 3 main collectios: 
- Users - in which we store all users and their data, for each user, we stored his personal info including his car license plate number. In addition, each user holds 3 collections that will be discussed below. 
- Cars - in which we store all cars registered in the app, meaning all cars people added to their profiles when registering in the app. for each car we save its number as the id for this collection, in addition we store the car's owner id (its user id).
- Requests - in this collection we store all help requests users created in the app, this collection is displayed in home screen.
- messages - in this collection we store all chat conversations between users.
- messageAlert - in this collection, for each user we store all last messages between him and other users.

### colections for each user:

* [ ] Alerts: contains all alerts other users sent to this user.
* [ ] Requests: contains all requests the user made.
* [ ] Offers: contains all help offers the user received from other users.
* [ ] tokens: contains all tokens of the user devicesm (for notifications implemnetation).
* [ ] blocked: contains all users the user blocked.


### for each alert/help request/help offer, we store:
* [ ] sender: the uid of the user who sent it. 
* [ ] sender_name: the name of the user who sent it.
* [ ] type: the type of the alert/help requests/help offers, such as : water, car crash.. (help offer type is the same as help request type).

### When a user asks for help:

* [ ] The help request is added to the user's Requests collection, so the user's requests list, displayed in the 'My Requests' screen, is updated accordingly.
* [ ] The help request is added to the general Requests collection of the app, with location information, the requests list, displayed in the home page screen in other users app, is updated accordingly.

### When a user (No.1) sends an alert to another user (No.2):

* [ ] The alert is added to the Alerts collection of user No.2.

### When a user (No.1) offer help to another user (No.2):

* [ ] The help offer is added to the Offers collection of user No.2.


