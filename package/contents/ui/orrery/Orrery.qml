import QtQuick 2.1


Item {
    id: home;
    width: 298; height: 298
    
    Item {
        id:terra
        x: 34; y: 34; z: 10
        width: 84; height: 84

        Image { id: earth_sh; x: -2; y: -2; z: -1; smooth: true; source: "earthUnderShadow.png" }
    }
}
