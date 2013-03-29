import QtQuick 1.1
// import org.kde.plasma.core 0.1 as PlasmaCore
import "phases.js"   as Phases
import "lunacalc.js" as LunaCalc
import "../calendar"

Item {
    id: luna
    width: 152; height: 152

    property string svg_sourse: "luna-gskbyte13.svg"

	Component.onCompleted: {
		// refresh moon image
        // plasmoid.addEventListener("dataUpdated", dataUpdated);
        // dataEngine("time").connectSource("Local", luna, 360000, PlasmaCore.AlignToHour);

        // dataUpdated()
        // plasmoid.setAspectRatioMode(ConstrainedSquare);
	}

    function dataUpdated(today) {
        if(!today) today = new Date();
        var phaseNumber = LunaCalc.getTodayPhases(today);

        svg_sourse = "luna-gskbyte" + phaseNumber + ".svg"
        console.log(phaseNumber)
	}

    property double tik: 0
    property int tak: -1
    property int count: 0
//*
    function timeChanged() {
        if(tik > 360){
            tik = 12.42
            tak = 0
        }else{
            tik += 12.42
            tak ++
        }
        svg_sourse = "luna-gskbyte" + tak + ".svg"
/*
        var today = new Date();
        today.setDate(today.getDate()+count)
        dataUpdated(today)

        count++
        //console.log(Qt.formatDateTime(today, "dd"))
*/
        console.log(tak,tik)

    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: luna.timeChanged()
    }
// */

    Earth{
        x: 34; y: 34
    }
    Item {
        id: moon
        x: 60; y: 0
        width: 33; height: 33
        Image { x: -6; y: -6; smooth: true; source: "moonUnderShadow.png"}
        Image {
            width: 33; height: 33
            source: luna.svg_sourse
            sourceSize.width: parent.width
            sourceSize.height: parent.height
             smooth: true;
        }
        transform: Rotation {
            id: minuteRotation
            origin.x: 17.5; origin.y: 76;
            angle: tik
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
}
