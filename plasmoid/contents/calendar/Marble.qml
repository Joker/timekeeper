import QtQuick 1.1
import org.kde.edu.marble 0.11

Item{
    width: 475; height: 475
    Rectangle {
            id: screen
            x: 137
            y: 93
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
                    activeFloatItems: [ ]

                    Component.onCompleted: {
                            map.center.longitude = 55.45 //settings.quitLongitude
                            map.center.latitude = 37.37 //settings.quitLatitude
                            map.radius = 100 //settings.quitRadius


                            var plugins = settings.defaultRenderPlugins
                            settings.removeElementsFromArray(plugins, ["compass",  "coordinate-grid", "progress", "crosshairs", "stars", "scalebar"])
                            plugins.push( "atmosphere" )

                            settings.activeRenderPlugins = plugins

                            map.activeRenderPlugins = settings.activeRenderPlugins
                            map.setGeoSceneProperty( "clouds_data", true )
                            map.setGeoSceneProperty( "terrain", false )
                            map.setGeoSceneProperty( "cities", false )
                            map.setGeoSceneProperty( "otherplaces", false )
                            map.setGeoSceneProperty( "places", false )
                            map.setGeoSceneProperty( "citylights", true )
                        // console.log(settings.quitLongitude, settings.quitLatitude)
                    }
            }
            // */
    }
    Image {source: "innerFrame_sh.png" }
}
