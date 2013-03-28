 import QtQuick 1.1
 import "clock"

 Rectangle {
     width: 240; height: 240
     color: "transparent"

     Row {
         anchors.centerIn: parent
         Clock { shift: 4 }
     }
 }
