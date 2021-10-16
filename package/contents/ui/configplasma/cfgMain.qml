import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.0


ColumnLayout {

    property alias cfg_userBackgroundImage:  backImg.text

    GroupBox {

        title: i18n("Background image")
        Layout.fillHeight: true
        Layout.fillWidth:  true

        GridLayout {
            anchors.verticalCenter:   parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 3

            Label {
                text: i18n("Background image:")
                Layout.alignment: Qt.AlignRight
                anchors.verticalCenter: backImg.verticalCenter
            }

            TextField {
                id: backImg
                Layout.minimumWidth: 300
                placeholderText: qsTr("Path")
            }
            
            Button {
                id: btnSignals
                anchors.verticalCenter: backImg.verticalCenter
                text: i18n("Browse")

                onClicked: {
                    fileDialog.visible = true
                }
            }
        }
    }
    
    FileDialog {
        id: fileDialog
        title: i18n("Please choose a file")
        nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
        selectMultiple: false
        onAccepted: {
            backImg.text = fileDialog.fileUrls[0]
            Qt.quit()
        }
        onRejected: {
            Qt.quit()
        }
    }
}

