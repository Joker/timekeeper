import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.2

Item {
    id: gen

    Layout.fillHeight: true
    Layout.fillWidth:  true

    Layout.minimumWidth:    implicitWidth
    Layout.minimumHeight:   implicitHeight
    Layout.preferredWidth:  implicitWidth
    Layout.preferredHeight: implicitHeight


    property alias cfg_lat:  lat.text
    property alias cfg_lon:  lon.text

    property alias cfg_fontName:          selectfont.editText
    property alias cfg_fontWeekSize:  week.value
    property alias cfg_fontMonthSize: month.value


    ColumnLayout {
        id: cl
        anchors.fill: parent

        GroupBox {
            id: gb1
            title: i18n("Your location:")
            Layout.fillHeight: true
            Layout.fillWidth:  true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            GridLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                columns: 2

                Label {
                    text: i18n("Latitude:")
                    Layout.alignment: Qt.AlignRight
                    anchors.verticalCenter: lat.verticalCenter
                }

                TextField {
                    id: lat
                    placeholderText: qsTr("Latitude")
                }

                Label {
                    text: i18n("Longitude:")
                    Layout.alignment: Qt.AlignRight
                    anchors.verticalCenter: lon.verticalCenter
                }

                TextField {
                    id: lon
                    placeholderText: qsTr("Longitude")
                }
            }
        }

        GroupBox {
            id: gb2
            title: i18n("Time kepeeper font:")
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
    }
}
