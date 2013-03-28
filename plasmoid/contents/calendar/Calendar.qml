import QtQuick 1.1

Item {
    id: calendar
    width: 478; height: 478
    Image {
        id: iGlass
        x: 2; y: 1
        source: "innerFramesAndGlass.png"
    }
    Image {
        id: iSurround
        source: "woodSurround.png"
    }

    property int tik
//    function timeChanged() {
//        var date = new Date;
//        tik  = date.getUTCSeconds();
//    }
//    Timer {
//        interval: 100; running: true; repeat: true;
//        onTriggered: calendar.timeChanged()
//    }

    Image {
        id: rotatingring
        x: 16; y: 17
        source: "rotatingring.png"

        MouseArea {
            id: mousearea

            property bool __isPanning: false
            property int __lastX: -1
            property int __lastY: -1

            anchors.fill : parent


            function inner(x, y){
                var dx = x - 223;
                var dy = y - 223;
                var xy = (dx * dx + dy * dy)

                var out = (223 * 223) >   xy;
                var inn = (186 * 186) <=  xy;

                if(out && inn) return true; else return false;
            }
            function get_angle(x,y){
                var x = x - 223;
                var y = y - 223;
                if(x==0) return (y>0) ? 180 : 0;
                var a = Math.atan(y/x)*180/Math.PI;
                a = (x > 0) ? a+90 : a+270;
                return a;
            }
            onPressed: {/*
                var x = mouse.x
                var y = mouse.y
                console.log(x, y)
            */}

            onReleased: {
                Math.atan()
                //console.log(mouse.x, mouse.y)
               // console.log("onReleased")
            }

            onPositionChanged: {
                if(inner(mouse.x, mouse.y))
                   calendar.tik=get_angle(mouse.x, mouse.y)
            }

            onCanceled: {
                console.log("onCanceled")
            }
        }

        transform: Rotation {
            id: minuteRotation
            origin.x: 223; origin.y: 223;
            angle: calendar.tik
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }

    }
    Image {
        id: counterWheel
        x: 69
        y: 71
        source: "counterWheel.png"
    }

}
