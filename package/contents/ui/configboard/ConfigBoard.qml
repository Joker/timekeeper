import QtQuick 2.1
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: cf
    width: 200; height: 150

    state: "up"

    Image {
        source: "background.png"

        PlasmaComponents.TextField {
            id: font_path
            x: 36; y: 30
            width: 136; height: 21
            font.pixelSize: 12
        }
        Text {
            id: font_path_text
            x: 39; y: 32
            width: 130; height: 19
            color: "#805d5d"
            text: qsTr("/absolut/font/path")
            verticalAlignment:   Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    font_path_text.visible = false;
                    font_path.forceActiveFocus()

                    function fdAccepted(fdlg) {
                        font_path.text = fdlg.file
                    }
                    var fd = new OpenFileDialog()
                        fd.accepted.connect(fdAccepted)
                        fd.show()
                }

            }
        }

        Text { text: qsTr("week"); x: 39; y: 66; font.pixelSize: 12 }
        PlasmaComponents.TextField {
            id: week_size
            x: 73; y: 62
            width: 27; height: 20
            text: qsTr("11")

            font.pixelSize: 12
            maximumLength: 2
        }
        Text { text: qsTr("month"); x: 103; y: 66; font.pixelSize: 12 }
        PlasmaComponents.TextField {
            id: month_size
            x: 145; y: 62
            width: 27; height: 20
            text: qsTr("14")

            font.pixelSize: 12
            maximumLength: 2
        }


        Image {
            id: ok
            x: 33; y: 92
            source: "okb.png"

            MouseArea {
                x: 4; y: 3; width: 56; height: 25

                onClicked: {
                    main.fontWeekSize  = week_size.text
                    main.fontMonthSize = month_size.text
                    if (font_path.text.length > 0)
                        main.fontPath = font_path.text
                    else
                        main.fontPath = "clock/Engravers_MT.ttf"
                    cf.state = "up"
                }
            }
        }
        Image {
            id: def
            x: 162; y: 105
            source: "cancel.png"

            MouseArea {
                x: 0; y: 0; width: 22; height: 21
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    def.forceActiveFocus()
                    font_path.text = qsTr("")
                    font_path_text.visible = true
                    week_size.text = qsTr("11")
                    month_size.text = qsTr("14")
                }
            }
        }
    }


    states: [
        State {
            name: "up"
            PropertyChanges { target: cf; visible: false }
            PropertyChanges { target: rotation; angle: 90 }
        },
        State {
            name: "down"
            PropertyChanges { target: cf; visible: true }
            PropertyChanges { target: rotation; angle: 0 }
        }
    ]
    transform: Rotation {
        id: rotation
        origin.x: cf.width/2
        origin.y: 0
        axis.x: 1; axis.y: 0; axis.z: 0
        angle: 90
    }
    transitions: [
        Transition {
            from: "up"; to: "down"
            SpringAnimation { target: rotation; property: "angle"; spring: 4; damping: 0.3; modulus: 360 ;mass :5}
        },
        Transition {
            from: "down"; to: "up"
            SequentialAnimation {
                NumberAnimation { target: rotation; property: "angle";   duration: 400  }
                PropertyAction  { target: cf;       property: "visible"; value: "false" }
            }
        }
    ]

}

