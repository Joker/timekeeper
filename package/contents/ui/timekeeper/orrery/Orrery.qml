import QtQuick 2.1

import "planets.js" as Planets

Item {
    id: home;

    Component.onCompleted: {

    }

    property var showingDate: new Date();

    function setDateTime(date) {
        if (Math.abs(showingDate - date) < 100){return} //limit framerate
        showingDate = date;

        var offest   = date.getTimezoneOffset();
        var hours    = date.getHours();
        var minutes  = date.getMinutes();

        earth.rot = (hours * earth.framesPerHour + Math.round((minutes + offest) / earth.framesPerMin)) % earth.earthNumFrames;
    }
    
    Item {
        id:planetarium
        width: parent.width
        height: parent.height
        property var planets: [sun, mercury, venus, earth, mars, jupiter, saturn, uranus, neptune]

        Image {
            id: sun;
            x: parent.width/2 - width/2;
            y: parent.height/2 - height/2;
            smooth: true;
            source: "./images/sun.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }
        }

        Image {
            id: mercury

            property int planetoffset: 38

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            smooth: true
            source: "./images/mercury.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }

            transform: Rotation {
                origin.x: mercury.width / 2
                origin.y: mercury.height / 2 + mercury.planetoffset
                angle: 360 - Planets.getTrueAnomaly(0, showingDate)
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360}
                }
            }
        }

        Image {
            id: venus;

            property int planetoffset: 56

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            smooth: true;
            source: "./images/venus.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }

            transform: Rotation {
                origin.x: venus.width / 2
                origin.y: venus.height / 2 + venus.planetoffset
                angle: 360 - Planets.getTrueAnomaly(1, showingDate)
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            id: earth;

            property int  rot: 0
            property int  earthNumFrames: 96
            property int  framesPerHour: earthNumFrames / 24
            property int  framesPerMin: 60 / framesPerHour

            property int planetoffset: 74

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            width: 15
            height: 15

            smooth: true;
            source: "../../terra/animation/earth"+ rot + ".png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }

            transform: Rotation {
                origin.x: earth.width / 2
                origin.y: earth.height / 2 + earth.planetoffset
                angle: 360 - Planets.getTrueAnomaly(2, showingDate)
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            id: mars;

            property int planetoffset: 88

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            smooth: true;
            source: "./images/mars.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }

            transform: Rotation {
                origin.x: mars.width / 2
                origin.y: mars.height / 2 + mars.planetoffset
                angle: 360 - Planets.getTrueAnomaly(3, showingDate)
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            id: jupiter;

            property int planetoffset: 104

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            smooth: true;
            source: "./images/jupiter.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }

            transform: Rotation {
                origin.x: jupiter.width / 2
                origin.y: jupiter.height / 2 + jupiter.planetoffset
                angle: 360 - Planets.getTrueAnomaly(4, showingDate)
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }

        }

        Image {
            id: saturn;

            property int planetoffset: 118

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            smooth: true;
            source: "./images/saturn.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }

            transform: Rotation {
                origin.x: saturn.width / 2
                origin.y: saturn.height / 2 + saturn.planetoffset
                angle: 360 - Planets.getTrueAnomaly(5, showingDate)
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            id: uranus;

            property int planetoffset: 132

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            smooth: true;
            source: "./images/uranus.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }

            transform: Rotation {
                origin.x: uranus.width / 2
                origin.y: uranus.height / 2 + uranus.planetoffset
                angle: 360 - Planets.getTrueAnomaly(6, showingDate)
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            id: neptune;

            property int planetoffset: 144

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            smooth: true;
            source: "./images/neptune.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }
            transform: Rotation {
                origin.x: neptune.width / 2
                origin.y: neptune.height / 2 + neptune.planetoffset
                angle: 360 - Planets.getTrueAnomaly(7, showingDate)
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }
    }
}
