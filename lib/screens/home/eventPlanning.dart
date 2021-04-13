import 'dart:async';
import 'package:go_out_v2/models/event.dart';
import 'package:go_out_v2/screens/eventPlanning/planEvent.dart';
import 'package:go_out_v2/shared/loading.dart';
import 'package:location/location.dart';
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
// import 'package:google_place/google_place.dart';


class EventPlanning extends StatefulWidget {
  // final LocationData location;
  // EventPlanning({this.location});

  @override
  State<EventPlanning> createState() => EventPlanningMapState();
}

class EventPlanningMapState extends State<EventPlanning> {
  //Google Places


  //Everything needed for obtaining permissions.
  bool a0 = false, a1 = false, a2 = false, a3 = false, a4 = true, a5 = false, a6 = false, a7 = false, a8 = false, a9 = false;
  bool i0 = false, i1 = false, i2 = false, i3 = false, i4 = false, i5 = false, i6 = false;
  int radioValue = 0;
  PermissionName permissionName = PermissionName.Internet;
  String message = '';

  //Map data
  Set<Marker> _markers = HashSet<Marker>();
  BitmapDescriptor _markerIcon;
  GoogleMapController _controller;
  Set<Circle> _circles = HashSet<Circle>();
  double radius = 250;

  // Location
  Location location = new Location();
  LocationData _locationData;
  LatLng _markerLocation;


  //Ids
  int _circleIdCounter = 1;

  //Type Controllers
  bool _isCircle = false;

  @override
  initState() {
    super.initState();


    print('==initState== Going into Async Function');
    _getLocationData();
    print('==initState== Requesting permissions');
    requestPermissions();
    print('==initState== Setting Marker Icon');
    _setMarkerIcon();

  }

  Future<void> _getLocationData() async {
    try{
      print('Fetching Location info');
      _locationData = await location.getLocation();
      print('**User Device Location Info**');
      print(_locationData);
      return location.getLocation();
    }catch(e){
      print(e);
      return null;
    }

  }

  requestPermissions() async {
    List<PermissionName> permissionNames = [];
    if (a0) permissionNames.add(PermissionName.Calendar);
    if (a1) permissionNames.add(PermissionName.Camera);
    if (a2) permissionNames.add(PermissionName.Contacts);
    if (a3) permissionNames.add(PermissionName.Microphone);
    if (a4) permissionNames.add(PermissionName.Location);
    if (a5) permissionNames.add(PermissionName.Phone);
    if (a6) permissionNames.add(PermissionName.Sensors);
    if (a7) permissionNames.add(PermissionName.SMS);
    if (a8) permissionNames.add(PermissionName.Storage);
    if (a9) permissionNames.add(PermissionName.State);

    if (i0) permissionNames.add(PermissionName.Internet);
    if (i1) permissionNames.add(PermissionName.Calendar);
    if (i2) permissionNames.add(PermissionName.Camera);
    if (i3) permissionNames.add(PermissionName.Contacts);
    if (i4) permissionNames.add(PermissionName.Microphone);
    if (i5) permissionNames.add(PermissionName.Location);
    if (i6) permissionNames.add(PermissionName.Storage);
    message = '';
    var permissions = await Permission.requestPermissions(permissionNames);
    permissions.forEach((permission) {
      message += '${permission.permissionName}: ${permission.permissionStatus}\n';
    });
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller)
  {
    print('=========MAP CREATED=============');
    //set the map style
    _setMapStyle();
    _controller = controller;
    print('Creating marker and initial circle');
    final String circleIdVal = 'circle_id_$_circleIdCounter';
    _circleIdCounter++;
    _circles.add(
        Circle(
            circleId: CircleId(circleIdVal),
            center: LatLng(_locationData.latitude, _locationData.longitude),
            radius: radius,
            fillColor: Colors.redAccent.withOpacity(0.5),
            strokeWidth: 3,
            strokeColor: Colors.redAccent));
    _markers.add(
        Marker(
            markerId: MarkerId('0'),
            position: LatLng(_locationData.latitude, _locationData.longitude),
            icon: BitmapDescriptor.defaultMarker,
            draggable: true,
            onDragEnd: ((newPosition) {
              setState(() {
                  print('set state');
                  _markerLocation = newPosition;
                  _setCircles(newPosition);
              });
            }),
            infoWindow: InfoWindow(
                title: "Event Epicenter",
                snippet: 'Center of your Search Radius. Drag and drop!')
        )
    );
    setState(() {
      print('set State 2');
    });


  }

  _setMarkerIcon() async {
    print('Setting the marker Icon');
    _markerIcon =
    await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/coffee_icon.png');
  }

  //Setting the styling of the map based on a saved Json file
  void _setMapStyle() async {
    String style = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
    _controller.setMapStyle(style);

  }

  //Sets the circles as points to the map
  void _setCircles(LatLng point) {
    final String circleIdVal = 'circle_id_$_circleIdCounter';
    _circles.clear();
    _circleIdCounter++;
    print(
        'Circle | Latitude: ${point.latitude}  Longitude: ${point.longitude}  Radius: $radius');
    _circles.add(Circle(
        circleId: CircleId(circleIdVal),
        center: point,
        radius: radius,
        fillColor: Colors.redAccent.withOpacity(0.5),
        strokeWidth: 3,
        strokeColor: Colors.redAccent));

    _circles.forEach((value) {
      print('Circled ID: ${value.circleId}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getLocationData(),
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.data == null){
          return Loading();
        }

        //ToDO: Build a stream that listens to changes in _Circles, to update the radius
        //ToDo: Also, add a stream that will listen to the radius info that you'll eventually have.
      return Scaffold(
        body: Stack(
          children: <Widget>[

            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(_locationData.latitude, _locationData.longitude),
                zoom: 14
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              buildingsEnabled: true,
              liteModeEnabled: false,
              circles: _circles,
              markers: _markers,
              onMapCreated: _onMapCreated,
            ),
            SizedBox(

              height: 120,
              child: Slider(
                  value: radius ?? 250,
                  activeColor: Colors.red,
                  inactiveColor: Colors.blue,
                  min: 100.0,
                  max: 2500.0,
                  divisions: 60,
                  onChanged: (val) =>    setState(() {
                    print(_markerLocation);
                    radius = val;
                    _setCircles(LatLng(_markerLocation.latitude, _markerLocation.longitude));
                  })
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
              child: Text(
                "Adjust slider to change search radius.",
                style: TextStyle(
                  color: Colors.white
                )
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
          child: Align(
            alignment: Alignment.bottomCenter,

            child: FloatingActionButton.extended(
              onPressed: (){
                print('');
                print('********* Button Press *********');
                Event newEvent = new Event();
                print(_markerLocation.latitude);
                print(_markerLocation.longitude);
                newEvent.lat = _markerLocation.latitude;
                print(newEvent.lat);
                newEvent.lng = _markerLocation.longitude;
                print(newEvent.lng);
                newEvent.searchRadius = radius;
                print(newEvent.searchRadius);
                print(newEvent);
                Navigator.push(
                  context,
                    MaterialPageRoute(builder: (context) => PlanEvent(newEvent: newEvent)));
              },
              label: Text('Plan your event!'),
              icon: Icon(Icons.next_plan_outlined),

            ),
          ),
        ),
      );
      },
    );
  }
  getPermissionsStatus() async {
    List<PermissionName> permissionNames = [];
    if (a0) permissionNames.add(PermissionName.Calendar);
    if (a1) permissionNames.add(PermissionName.Camera);
    if (a2) permissionNames.add(PermissionName.Contacts);
    if (a3) permissionNames.add(PermissionName.Microphone);
    if (a4) permissionNames.add(PermissionName.Location);
    if (a5) permissionNames.add(PermissionName.Phone);
    if (a6) permissionNames.add(PermissionName.Sensors);
    if (a7) permissionNames.add(PermissionName.SMS);
    if (a8) permissionNames.add(PermissionName.Storage);

    if (i0) permissionNames.add(PermissionName.Internet);
    if (i1) permissionNames.add(PermissionName.Calendar);
    if (i2) permissionNames.add(PermissionName.Camera);
    if (i3) permissionNames.add(PermissionName.Contacts);
    if (i4) permissionNames.add(PermissionName.Microphone);
    if (i5) permissionNames.add(PermissionName.Location);
    if (i6) permissionNames.add(PermissionName.Storage);
    message = '';
    List<Permissions> permissions = await Permission.getPermissionsStatus(permissionNames);
    permissions.forEach((permission) {
      message += '${permission.permissionName}: ${permission.permissionStatus}\n';
      print(message);
    });
    setState(() {
      message;
    });
  }
  getSinglePermissionStatus() async {
    var permissionStatus = await Permission.getSinglePermissionStatus(permissionName);
    setState(() {
      message = permissionStatus.toString();
    });
  }

}