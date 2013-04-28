import QtQuick 1.1

Item {
    id: glass
    width: 478; height: 478

    property double ring_degree
    property int    count_angle
    property bool   lock: false
    property alias  sa  : mousearea.start_angle
    property alias  mar : marble
    property bool   ch  : true

    Image  { x: 2; y: 0; source: "innerFramesAndGlass.png" }

    Marble { id: marble; x: 2; y: 0; visible: false; }
    // property alias ms: marble.source
    // Loader { id: marble; x: 2; y: 0 ; visible: false; }

    Image { source: "woodSurround.png" }

    Image {
        id:ring
        x: 16; y: 18
        source: "rotatingring.png"
        smooth: true
        rotation: 122
        transform: Rotation {
            origin.x: 223; origin.y: 223;
            angle: glass.ring_degree
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }

    }
    Image {
        x: 69; y: 71
        source: "counterWheel.png"
        smooth: true
        transform: Rotation {
            origin.x: 170.5; origin.y: 170.5;
            angle: glass.count_angle * -1
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    MouseArea {
        id: mousearea
        x: 16; y: 18
        width: 446; height: 445
        property int start_angle:0
        property int ostanov
        property int a_pred


        function inner(x, y){
            var dx = x - 223;
            var dy = y - 223;
            var xy = (dx * dx + dy * dy)

            var out = (223 * 223) >   xy;
            var inn = (150 * 150) <=  xy;

            if(out && inn) return true; else return false;
        }
        function ringUpdated(count) {
            var today = new Date();
            today.setDate(today.getDate()+count)
            toEarthMoonTime(today)
        }
        function tri_angle(x,y){
            x = x - 223;
            y = y - 223;
            if(x == 0) return (y>0) ? 180 : 0;
            var a = Math.atan(y/x)*180/Math.PI;
            a = (x > 0) ? a+90 : a+270;

            return Math.round(a);
        }

        onPressed: {
            if(inner(mouse.x, mouse.y)){
                glass.lock  = false;

                start_angle = tri_angle(mouse.x, mouse.y)
                ostanov     = glass.ring_degree
                a_pred      = start_angle
            }
        }
        onReleased: {
            glass.lock = clock.lock
        }
        onPositionChanged: {
            var a, b, c
            if(inner(mouse.x, mouse.y)){
                a = tri_angle(mouse.x, mouse.y)

                b = ostanov + (a - start_angle)
                glass.ring_degree = b
                glass.count_angle = b

                c = (a_pred - a)
                if(c < 90 && -90 < c ) count += c
                a_pred = a

                ringUpdated(count)
            }else{
                start_angle = tri_angle(mouse.x, mouse.y)
                ostanov     = glass.ring_degree
                a_pred      = start_angle
            }
            if(ostanov >  360)ostanov -= 360
            if(ostanov < -360)ostanov += 360
            // console.log(b, ostanov, a, start_angle)
        }
    }

    MouseArea {
        id: mousearea1; x: 137; y: 386; width: 11; height: 11; visible: false
        onClicked: { if(!glass.ch) marble.citylights_on(); else marble.citylights_off(); glass.ch = !glass.ch }
    }
    MouseArea {
        id: mousearea2; x: 331; y: 386; width: 11; height: 11; visible: false
        property bool ch: true
        onClicked: { if(!ch) marble.clouds_data_on(); else marble.clouds_data_off(); ch = !ch }
    }
    MouseArea {
        id: mousearea3; x: 332; y: 84;  width: 11; height: 11; visible: false
        onClicked: { marble.defaultPt() }
    }

    states: [
        State {
            name: "earth"
            PropertyChanges { target: marble; visible: true }
            PropertyChanges { target: mousearea; visible: false }

            PropertyChanges { target: mousearea1; visible: true }
            PropertyChanges { target: mousearea2; visible: true }
            PropertyChanges { target: mousearea3; visible: true }
        }
    ]
    //transform: Rotation { origin.x: 239; origin.y: 239; axis { x: 1; y: 1; z: 0 } angle: 0 }
}
