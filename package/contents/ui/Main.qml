import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.components 3.0
import org.kde.plasma.plasmoid 2.0

//background
import "timekeeper"

//time keeping
import "clock"
import "calendar"

Item {
    id: main

    readonly property bool debug: false

    readonly property int main_width: 478 * units.devicePixelRatio //540
    readonly property int main_height: 478 * units.devicePixelRatio

    width: main_width
    height: main_height

    Layout.minimumWidth: main_width
    Layout.minimumHeight: main_height
    Layout.preferredWidth: main_width
    Layout.preferredHeight: main_height
    Layout.maximumWidth: main_width
    Layout.maximumHeight: main_height

    Plasmoid.backgroundHints: "NoBackground"

    readonly property string fontName:   "Engravers MT"
    readonly property int fontWeekSize:  10 //plasmoid.configuration.fontWeekSize
    readonly property int fontMonthSize: 10 //plasmoid.configuration.fontMonthSize

    property string mainState:         plasmoid.configuration.mainState
    property string clockState:        plasmoid.configuration.clockState
    property bool calendarLock:      plasmoid.configuration.calendarLock
    property bool whellLock:         plasmoid.configuration.whellLock
    property string stainedglassState: plasmoid.configuration.stainedglassState

    FontLoader {
        id:   fixedFont;
        name: fontName;
        source: "font/Engravers_MT.ttf";
        onStatusChanged: {
            if (fixedFont.status == FontLoader.Error) console.log("Cannot load font");
            // console.log(fixedFont.name, fixedFont.source)
        }
    }

    Timer {
        id: secondTimer
        interval: 1000; running: true; repeat: true;
        onTriggered: {
            var date = new Date;

            if(Qt.formatDateTime(date, "hhmmss") != "000000") {
                clock.setDateTime(date);
            }
        }
    }

    Timer {
        id: minuteTimer
        interval: 60000; running: true; repeat: true;
        onTriggered: {
            var date = new Date;

            if(Qt.formatDateTime(date, "hhmmss") != "000000") {
                timekeeper.setDateTime(date);
                calendar.setDateTime(date);
            }
        }
    }

    Flipable { //main container
        id: container
        property bool flipped: false
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        front: Item {
            width: main_width;
            height: main_height

            Timekeeper{ // frame backgroound
                id:timekeeper;
                z: 1
            }

            Clock {
                id: clock;
                x: 29; y: 60;
                z: 10
                state: "in"
            }

            Calendar{
                id: calendar;
                x: 285;y: 186;
                z: 10
            }
        }
    }
}
