let mapCenter = {lat: 47.55935, lng: -122.2529};
var locationMarker;
var map;

//--------------------------------------------------------------------------------
function printClickPoint(event){
   var lat = event.latLng["lat"]()
   var long = event.latLng["lng"]()
    console.log(lat.toFixed(6) + ", " + long.toFixed(6))
   }
//--------------------------------------------------------------------------------
async function initMap(){

  const {Map} = await google.maps.importLibrary("maps");

  const defaultTreeMarker =  {path: google.maps.SymbolPath.CIRCLE,
                                 fillColor: '#FFF',
                                 fillOpacity: 0.6,
                                 strokeColor: '#000',
                                 strokeOpacity: 0.9,
                                 strokeWeight: 1,
                                 scale: 4
                                }

  const plotCoords = [{lat: 47.559355, lng:-122.252906},
                      {lat: 47.559082, lng: -122.252489},
                      {lat: 47.559355, lng: -122.252906}];



  map = new Map(document.getElementById("map"),
                {center: {lat: 47.55935, lng: -122.2529},
                 zoom: 16.0,
                });

  map.addListener("click", (mapsMouseEvent) => {
     printClickPoint(mapsMouseEvent);
     })
                  
    //drawTrees(map)
    return(map)

} // initMap function


async function drawTrees(map){
  //await readTreeData();
  console.log("tree count: " + window.trees.length)
  window.trees.forEach(function(tree){
      var size = tree["dbh"]/2;
      if(size < 5){
         size = 5;
         }
       var newColor = calculateWpDamageColor(tree);
       const icon = {path: google.maps.SymbolPath.CIRCLE,
                     scale: size,
                     fillOpacity: 1,
                     strokeWeight: 1,
                     //fillColor: calculateHealthColor(tree),
                     fillColor: newColor,
                     strokeColor: '#000',
                     }
       let marker = new google.maps.Marker({
           position: {lat:  tree["lat"], lng: tree["lon"]},
           map,
           title: tree["id"].toString(),
           icon: icon
           })
       let infoWindow = new google.maps.InfoWindow({
           content: "<h4> tree #" + tree["id"] + " (" + tree["observer"] + ")</h4>" +
             "<ul>" +
               "<li> dbh: " + tree["dbh"] +
               "<li> h1: " + tree["h1"] +
               "<li> h2: " + tree["h2"] +
               "<li> h3: " + tree["h3"] +
               "<li> lat: " + tree["lat"] +
               "<li> lon: " + tree["lon"] +
               "<li> overall health: " + tree["h"] +
               "<li> aspect: " + tree["aspect"] +
               "<li> slope: " + tree["slope"] + 
               "<li> date: " + tree["date"] + 
               "<li> location: " + tree["loc"] + 
               "</ul>" +
               tree["comments"]
           })
       marker.addListener("click", () => {
          infoWindow.open({
             anchor: marker,
             map,
             });
          })
       }) // forEach


    setInterval(function(){
       navigator.geolocation.getCurrentPosition(function(pos){
           var latLng = {"lat": pos.coords.latitude, "lng": pos.coords.longitude};
           if(typeof(locationMarker) == "undefined"){
              locationMarker = new google.maps.Marker({
                 position: mapCenter,
                 map: map,
                 icon: {
                    path: google.maps.SymbolPath.CIRCLE,
                    scale: 10,
                    fillOpacity: 1,
                    strokeWeight: 1,
                    fillColor: '#5384ED',
                    strokeColor: '#ffffff',
                    },
                 });
           locationMarker.setPosition(latLng)
           }
         })
      }, 1000);
} // drawTrees
