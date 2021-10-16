import QtQuick 2.1

import "planets.js" as Planets

Item {
    id: home;

    property var showingDate: new Date();

    function onSecondTimer(date) {
    }

    function onMinuteTimer(date) {
        showingDate = date;
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
                origin.y: mercury.width / 2 + mercury.planetoffset
                angle: Planets.angle(0, showingDate)
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
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
                origin.y: venus.width / 2 + venus.planetoffset
                angle: Planets.angle(1, showingDate)
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            id: earth;

            property int planetoffset: 74

            x: sun.x + (sun.width / 2) - (this.width / 2)
            y: sun.y + (sun.height / 2) - (this.height / 2) - planetoffset

            width: 15
            height: 15

            smooth: true;
            source: "../../terra/animation/earth0.png"

            MouseArea {
                anchors.fill: parent
                visible: true;

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }

            transform: Rotation {
                origin.x: earth.width / 2
                origin.y: earth.width / 2 + earth.planetoffset
                angle: Planets.angle(3, showingDate)
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
                origin.y: mars.width / 2 + mars.planetoffset
                angle: Planets.angle(4, showingDate)
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
                origin.y: jupiter.width / 2 + jupiter.planetoffset
                angle: Planets.angle(5, showingDate)
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
                origin.y: saturn.width / 2 + saturn.planetoffset
                angle: Planets.angle(6, showingDate)
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
                origin.y: uranus.width / 2 + uranus.planetoffset
                angle: Planets.angle(7, showingDate)
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
                origin.y: neptune.width / 2 + neptune.planetoffset
                angle: Planets.angle(8, showingDate)
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }
    }
}
