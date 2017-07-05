import QtQuick 2.1

//TODO - Qt5 Marble is currently blocked 
//import org.kde.edu.marble 0.11

//TODO - this is a dummy
Item{
    width: 475; height: 475
    Rectangle {
            id: screen
            x: 137; y: 93
            width: 200; height: 250
            color: "green"
    }
}

/*TODO - re-enable if Qt5 marble is available
Item{
    width: 475; height: 475
    Rectangle {
            id: screen
            x: 137; y: 93
            width: 200; height: 250
            color: "green"
            //*
            SystemPalette  { id: activePalette }
            MarbleSettings { id: settings }

            MarbleWidget {
                    id: map
                    width: screen.width
                    height: screen.height

                    mapThemeId: "earth/bluemarble/bluemarble.dgml"
                    // mapThemeId: "earth/citylights/citylights.dgml"
                    // mapThemeId: "earth/schagen1689/schagen1689.dgml"
                    activeFloatItems: [ ]

                    Component.onCompleted: {
                            map.center.longitude = main.lon //settings.quitLongitude
                            map.center.latitude  = main.lat //settings.quitLatitude
                            map.radius = 100 // 150


                            var plugins = settings.defaultRenderPlugins
                            settings.removeElementsFromArray(plugins, ["compass",  "coordinate-grid", "progress", "crosshairs", "stars", "scalebar"])
                            // plugins.push( "atmosphere" )

                            settings.activeRenderPlugins = plugins

                            map.activeRenderPlugins = settings.activeRenderPlugins

                            map.setGeoSceneProperty( "terrain",     false )
                            map.setGeoSceneProperty( "cities",      false )
                            map.setGeoSceneProperty( "otherplaces", false )
                            map.setGeoSceneProperty( "places",      false )

                            map.setGeoSceneProperty( "clouds_data", true )
                            map.setGeoSceneProperty( "citylights",  true )
                            // console.log(settings.quitLongitude, settings.quitLatitude)
                    }

            }
    }
    Image { source: "innerFrame_sh.png" }

    function citylights_on()  { map.setGeoSceneProperty( "citylights",  true ) }
    function citylights_off() { map.setGeoSceneProperty( "citylights",  false) }
    function clouds_data_off(){ map.setGeoSceneProperty( "clouds_data", false) }
    function clouds_data_on() { map.setGeoSceneProperty( "clouds_data", true ) }
    function defaultPt()      {
        map.center.longitude = main.lon
        map.center.latitude  = main.lat
        map.radius = 100
    }
    function saveLatLon(){
        main.lon = map.center.longitude
        main.lat = map.center.latitude
        plasmoid.writeConfig("lat", map.center.latitude)
        plasmoid.writeConfig("lon", map.center.longitude)
    }
}
*/
