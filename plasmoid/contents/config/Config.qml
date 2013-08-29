import QtQuick 1.1
import org.kde.plasma.components 0.1 as PlasmaComponents
import "/usr/lib/kde4/imports/org/kde/plasma/components/"

Item {
    width: 200; height: 150
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
                    console.log(font_path.text)
                }
            }
        }
        Image {
            id: def
            x: 162; y: 105
            source: "cancel.png"

            MouseArea {
                x: 0; y: 0; width: 22; height: 21
            }
        }
    }
}

