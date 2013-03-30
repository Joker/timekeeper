import QtQuick 1.1

Item {
    id: calendar
    width: 478; height: 478

    Image {
        id: iGlass
        x: 2; y: 0
        source: "innerFramesAndGlass.png"
    }
    Image {
        id: iSurround
        source: "woodSurround.png"
    }

    property int tik
    property int tak
    property bool lock: true

    Image {
        id: rotatingring
        x: 16; y: 18
        source: "rotatingring.png"
        smooth: true


        MouseArea {
            id: mousearea

            anchors.fill : parent

            property double an
            function inner(x, y){
                var dx = x - 223;
                var dy = y - 223;
                var xy = (dx * dx + dy * dy)

                var out = (223 * 223) >   xy;
                var inn = (150 * 150) <=  xy;

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
            onPressed: {
                if(inner(mouse.x, mouse.y)){
                    calendar.lock = false
                    an = get_angle(mouse.x, mouse.y)
                }
            }

            onReleased: {
                calendar.lock = true
            }

            onPositionChanged: {
                var a
                if(inner(mouse.x, mouse.y)){
                    a = get_angle(mouse.x, mouse.y)
                    a = a + an
                    console.log(a, an)
                    calendar.tik=a
                    calendar.tak=a
                }
            }

            onCanceled: {
                console.log("onCanceled")
            }
        }

        transform: Rotation {
            id: monthRotation
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
        smooth: true
        transform: Rotation {
            id: counterRotation
            origin.x: 170.5; origin.y: 170.5;
            angle: calendar.tak * -1
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }
}
