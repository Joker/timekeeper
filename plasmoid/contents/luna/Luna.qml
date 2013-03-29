import QtQuick 1.1
// import org.kde.plasma.core 0.1 as PlasmaCore
import "phases.js"   as Phases
import "lunacalc.js" as LunaCalc

Item {
    id: luna
    property string svg_sourse: "luna-gskbyte1.svg"
	Component.onCompleted: {
		// refresh moon image
        // plasmoid.addEventListener("dataUpdated", dataUpdated);
        // dataEngine("time").connectSource("Local", luna, 360000, PlasmaCore.AlignToHour);

        dataUpdated()
        // plasmoid.setAspectRatioMode(ConstrainedSquare);
	}

    function dataUpdated() {
		var phases = LunaCalc.getTodayPhases();
		// set the correct image for the moon
		var phaseNumber = LunaCalc.getCurrentPhase(phases);

        svg_sourse = "luna-gskbyte" + phaseNumber + ".svg"
        console.log(svg_sourse)
	}


    Image {
        source: luna.svg_sourse
        sourceSize.width: parent.width
        sourceSize.height: parent.height
    }
}
