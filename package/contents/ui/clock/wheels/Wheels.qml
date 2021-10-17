import QtQuick 2.1

Item{
    id:wh
    property int ang: 0
    property bool hide: false
    property bool lock: false

    width: 132; height: 93

    function setDateTime(date) {
        if (Math.abs(showingDate - date) < 100){return} //limit framerate
        showingDate = date;

        var offest   = date.getTimezoneOffset();
        var hours    = date.getHours();
        var minutes  = date.getMinutes();

        earth.rot = (hours * earth.framesPerHour + Math.round((minutes + offest) / earth.framesPerMin)) % earth.earthNumFrames;
    }

    Image {
        id: cogShadow
        x: 43; y: -5;
        source: "cogShadow.png"
        smooth: true;
        transform: Rotation {
            angle: ang * -1
            origin.x: cogShadow.width/2; origin.y: cogShadow.height/2;
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
    Image {
        id: cog
        x: 50; y: -17;
        width: 82; height: 84;
        source: "cog.png"
        smooth: true;
        transform: Rotation {
            angle: ang * -1
            origin.x: cog.width/2; origin.y: cog.height/2;
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
    Image {
        id: wheelShadow
        x: 3; y: 2;
        source: "wheelShadow.png"
        smooth: true;
        transform: Rotation {
            angle: ang
            origin.x: wheelShadow.width/2; origin.y: wheelShadow.height/2;
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
    Image {
        id: wheel
        source: "wheel.png"
        smooth: true;
        transform: Rotation {
            angle: ang
            origin.x: wheel.width/2; origin.y: wheel.height/2;
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
    Image {
        x: 26
        y: 2
        source: "driveBand.png"

        MouseArea {
            id: tiktak_ma
            x: 16; y: 36
            width: 14; height: 14
            cursorShape: Qt.PointingHandCursor

            Component.onCompleted: {
                if (main.debug) {

                    Qt.createQmlObject("
                                    import QtQuick 2.0

                                    Rectangle {
                                        anchors.fill: parent
                                        color: \"transparent\"
                                        border.color: \"white\"
                                    }
                                ", this);
                }
            }

            onClicked: {
                if(!whell.lock){
                    whell.ang = -10
                    whell.lock = !whell.lock
                } else if(!timekeeper.lock){
                    timekeeper.count_angle = 10
                    timekeeper.lock = !timekeeper.lock
                } else {
                    whell.lock = !whell.lock
                    timekeeper.lock = !timekeeper.lock

                    whell.ang = 0
                    calendar.ang = 0
                    timekeeper.count_angle = 0
                }
                plasmoid.configuration.calendarLock = timekeeper.lock
                plasmoid.configuration.whellLock = whell.lock
            }
        }
    }


    state: "in"

    states: [
        State {
            name: "hide"; PropertyChanges { target: wh; x: 10;  y: 25; }
            when: hide
        },
        State {
            name: "in";   PropertyChanges { target: wh; x: -26; y: 137; }
            when: {clock.state === "in" && !hide}
        },
        State {
            name: "out";  PropertyChanges { target: wh; x: -5; }
            when: {clock.state === "out" && !hide}
        }
    ]
    transitions: Transition {
        NumberAnimation { properties: "x"; duration: 1500 }
        NumberAnimation { properties: "y"; duration: 800  }
    }
}
