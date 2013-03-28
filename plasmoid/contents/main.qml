 import QtQuick 1.1
 import "clock"
 import "calendar"

 Rectangle {
     width: 500; height: 500
     color: "transparent"

     Row {
         anchors.centerIn: parent
         Calendar {
             Clock { shift: 4 }
         }

     }
 }
