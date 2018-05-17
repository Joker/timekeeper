import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.0


ColumnLayout {

    property alias cfg_backgroundImage:  backImg.text

    property alias cfg_fontName:      selectfont.editText
    property alias cfg_fontWeekSize:  week.value
    property alias cfg_fontMonthSize: month.value

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

    GroupBox {

        title: i18n("Time kepeeper font")
        Layout.fillHeight: true
        Layout.fillWidth:  true

        GridLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter:   parent.verticalCenter
            columns: 2

            ComboBox {
                id: selectfont
                model: Qt.fontFamilies()
                editable: true

                Layout.minimumWidth: 300
                Layout.columnSpan:   2
            }

            Label {
                text: i18n("Week font size:")
                Layout.alignment: Qt.AlignRight
                anchors.verticalCenter: week.verticalCenter
            }

            SpinBox {
                id: week
                minimumValue: 9
                maximumValue: 17
            }

            Label {
                text: i18n("Month font size:")
                Layout.alignment: Qt.AlignRight
                anchors.verticalCenter: month.verticalCenter
            }

            SpinBox {
                id: month
                minimumValue: 9
                maximumValue: 17
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

