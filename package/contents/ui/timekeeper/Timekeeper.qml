import QtQuick 2.1

import "orrery"

Item {
    id: glass
    width: parent.width; height: parent.height
    
    property var backgroundImages: [
        "backgrounds/glassImmage.png",
        "backgrounds/glassImmage1.png",
        "backgrounds/glassImmage2.png",
        "backgrounds/glassImmage3.png",
        "backgrounds/glassImmage4.png",
        "backgrounds/backSky.png",
        plasmoid.configuration.userBackgroundImage,
        "backgrounds/glassTransparent.png"
    ]

    property double ring_degree
    property int    count_angle
    property bool   lock: false
    property alias  startAngle  : mouse_rotate.start_angle

    function onSecondTimer(date) {
    }

    function onMinuteTimer(date) {
        orrery.onMinuteTimer(date);
    }

    Component.onCompleted: {
        for (var i = 0; i < glass.backgroundImages.length; i++) {
            if (glass.backgroundImages[i] && plasmoid.configuration.backgroundImage === glass.backgroundImages[i]) {
                backgroundImgAnimator.selectedImg = i;
                break;
            }
        }
    }
    
    Image  {
        id: backgroundImg
        x: 0
        y: 0
        width: 298
        height: 298
        source: plasmoid.configuration.backgroundImage
        smooth: true
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        sourceSize.width: 298
        sourceSize.height: 298
        property string selected: plasmoid.configuration.backgroundImage
    }
    
    Rectangle {
        id: backgroundImgAnimator
        x: 0
        y: 0
        opacity: 0
        width: 298
        height: 298
        anchors.centerIn: parent
        //color: "steelblue"
        color: "black"

        property int selectedImg: 0

        function changeImage() {
            if (!imageFlipAnnimation.running) {
                do {
                    if (selectedImg < glass.backgroundImages.length) {
                        selectedImg ++;
                    } else {
                        selectedImg = 0;
                    }
                }
                while (glass.backgroundImages[selectedImg] === "" || !glass.backgroundImages[selectedImg]);
                backgroundImg.selected = glass.backgroundImages[selectedImg];

                state = "onChangeIn";
            }
        }
    
        states: [
            State {
                name: "onChangeIn";
                PropertyChanges { target: backgroundImgAnimator; opacity: 1}
            },
            State {
                name: "onChangeOut";
                PropertyChanges { target: backgroundImgAnimator; opacity: 0}
            }
        ]
        
        transitions: Transition {
            id: imageFlipAnnimation
            NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; duration: 1000  }
            onRunningChanged: {

                if (!imageFlipAnnimation.running) {
                    if (backgroundImgAnimator.state != "onChangeIn") return;

                    backgroundImg.source = backgroundImg.selected;
                    plasmoid.configuration.backgroundImage = backgroundImg.source;

                    backgroundImgAnimator.state = "onChangeOut";
                }
            }
        }

    }
    
    Image  {
        id: innerMetalFrame
        x: 92
        y: 94
        width: 294
        height: 294
        sourceSize.width: 294
        sourceSize.height: 294
        source: "innerMetalFrame.png"
        smooth: true
    }
    
    Image  {
        x: 0
        y: 0
        source: "innerFrame.png"
        smooth: true
        anchors.centerIn: parent
    }

    Image {
        source: "woodSurround.png"
        smooth: true
    }

    Image {
        id:month_ring
        x: 16
        y: 18
        source: "rotatingring.png"
        smooth: true
        rotation: 122
        transform: Rotation {
            origin.x: 223; origin.y: 223;
            angle: glass.ring_degree
            Behavior on angle {
                SpringAnimation { 
                    spring: 2
                    damping: 0.2
                    modulus: 360
                }
            }
        }

    }
    Image {
        x: 69
        y: 71
        source: "counterWheel.png"
        smooth: true
        transform: Rotation {
            origin.x: 170.5; origin.y: 170.5;
            angle: glass.count_angle * -1
            Behavior on angle {
                SpringAnimation {
                    spring: 2
                    damping: 0.2
                    modulus: 360
                }
            }
        }
    }

    MouseArea {//date cog rotation
        id: mouse_rotate
        x: 16; y: 18
        width: 446; height: 445
        property int start_angle: 0
        property int ostanov
        property int a_pred

        function inner(x, y) {
            var dx = x - 223;
            var dy = y - 223;
            var xy = (dx * dx + dy * dy)

            var out = (223 * 223) >   xy;
            var inn = (150 * 150) <=  xy;

            return (out && inn) ? true : false;
        }

        function ringUpdated(count) {
            var today = new Date();
            today.setDate(today.getDate()+count)
            nowTimeAndMoonPhase(today)
        }

        function tri_angle(x,y) {
            x = x - 223;
            y = y - 223;
            if(x === 0) return (y>0) ? 180 : 0;
            var a = Math.atan(y/x)*180/Math.PI;
            a = (x > 0) ? a+90 : a+270;

            return Math.round(a);
        }

        onPressed: {
            if( inner(mouse.x, mouse.y) ){
                glass.lock  = false;

                start_angle = tri_angle(mouse.x, mouse.y)
                ostanov     = glass.ring_degree
                a_pred      = start_angle
            }
        }

        onReleased: {
            glass.lock = whell.lock
        }

        onPositionChanged: {
            var a, b, c
            if( inner(mouse.x, mouse.y) ){
                a = tri_angle(mouse.x, mouse.y)

                b = ostanov + (a - start_angle)
                glass.ring_degree = b
                glass.count_angle = b

                c = (a_pred - a)
                if(c < 90 && -90 < c ) count += c
                a_pred = a

                ringUpdated(count)
            } else {
                start_angle = tri_angle(mouse.x, mouse.y)
                ostanov     = glass.ring_degree
                a_pred      = start_angle
            }
            if(ostanov >  360) ostanov -= 360;
            if(ostanov < -360) ostanov += 360;
            // console.log(b, ostanov, a, start_angle)
        }
    }

    Orrery {
        id: orrery
        x: innerMetalFrame.x
        y: innerMetalFrame.y
        z: 5
        width: 294
        height: 294
    }

    MouseArea {
        /*
         * Background switch button
         */
        id: marble_latlon
        x: 331
        y: 85
        width: 11
        height: 11
        visible: true

        Component.onCompleted: {
            if (main.debug) {

                Qt.createQmlObject("
                                import QtQuick 2.0

                                Rectangle {
                                    width: parent.width
                                    height: parent.height
                                    color: \"transparent\"
                                    border.color: \"white\"
                                }
                            ", this);
            }
        }

        cursorShape: Qt.PointingHandCursor
        onClicked: {
            backgroundImgAnimator.changeImage();
        }
    }

    states: [
        State {
            name: "orrery"
        }
    ]
}
