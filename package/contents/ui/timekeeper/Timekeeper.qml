import QtQuick 2.1

import "orrery"

Item {
    id: frame
    width: parent.width
    height: parent.height

    property int count: 0
    
    property var backgroundImages: [
        "frame/backgrounds/glassImmage.png",
        "frame/backgrounds/glassImmage1.png",
        "frame/backgrounds/glassImmage2.png",
        "frame/backgrounds/glassImmage3.png",
        "frame/backgrounds/glassImmage4.png",
        "frame/backgrounds/backSky.png",
        plasmoid.configuration.userBackgroundImage,
        "frame/backgrounds/glassTransparent.png"
    ]

    property double ring_degree
    property int    count_angle
    property bool   lock: false
    property alias  startAngle  : mouse_rotate.start_angle

    function setDateTime(date) {
        if (frame.count == 0) {
            orrery.setDateTime(date);

            var MM = [0, -31, -62, -93, -123, -153, -182.5, -212, -241.5, -270.5, -299.5, -329.2]
            var month = date.getMonth()
            var dayOfMonth  = date.getDate()-1
            frame.ring_degree = MM[month] - dayOfMonth;
        }
    }

    Component.onCompleted: {
        for (var i = 0; i < frame.backgroundImages.length; i++) {
            if (frame.backgroundImages[i] && plasmoid.configuration.backgroundImage === frame.backgroundImages[i]) {
                backgroundImgAnimator.selectedImg = i;
                break;
            }
        }

        backgroundImg.source = frame.backgroundImages[backgroundImgAnimator.selectedImg];
        backgroundImg.selected = frame.backgroundImages[backgroundImgAnimator.selectedImg];
    }
    
    Image  {
        id: backgroundImg
        x: 0
        y: 0
        width: 298
        height: 298
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
                    if (selectedImg < frame.backgroundImages.length) {
                        selectedImg ++;
                    } else {
                        selectedImg = 0;
                    }
                }
                while (frame.backgroundImages[selectedImg] === "" || !frame.backgroundImages[selectedImg]);
                backgroundImg.selected = frame.backgroundImages[selectedImg];

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
            NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; duration: 500  }
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
        source: "frame/innerMetalFrame.png"
        smooth: true
    }
    
    Image  {
        x: 0
        y: 0
        source: "frame/innerFrame.png"
        smooth: true
        anchors.centerIn: parent
    }

    Image {
        source: "frame/woodSurround.png"
        smooth: true
    }

    Image {
        id:month_ring
        x: 16
        y: 18
        source: "frame/rotatingring.png"
        smooth: true
        rotation: 122
        transform: Rotation {
            origin.x: 223; origin.y: 223;
            angle: frame.ring_degree
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
        source: "frame/counterWheel.png"
        smooth: true
        transform: Rotation {
            origin.x: 170.5; origin.y: 170.5;
            angle: frame.count_angle * -1
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
            today.setDate(today.getDate() + count);

            orrery.setDateTime(today);
            calendar.setDateTime(today);
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
                frame.lock  = false;

                start_angle = tri_angle(mouse.x, mouse.y)
                ostanov     = frame.ring_degree
                a_pred      = start_angle
            }
        }

        onReleased: {

        }

        onPositionChanged: {
            var a, b, c
            if( inner(mouse.x, mouse.y) ){
                a = tri_angle(mouse.x, mouse.y)

                b = ostanov + (a - start_angle)
                frame.ring_degree = b
                frame.count_angle = b

                c = (a_pred - a)
                if(c < 90 && -90 < c ) count += c
                a_pred = a

                ringUpdated(count)
            } else {
                start_angle = tri_angle(mouse.x, mouse.y)
                ostanov     = frame.ring_degree
                a_pred      = start_angle
            }
            if(ostanov >  360) ostanov -= 360;
            if(ostanov < -360) ostanov += 360;
            // console.log(b, ostanov, a, start_angle)
        }
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
                                    anchors.fill: parent
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

    Orrery {
        id: orrery
        x: innerMetalFrame.x
        y: innerMetalFrame.y
        z: 5
        width: 294
        height: 294
    }
}
