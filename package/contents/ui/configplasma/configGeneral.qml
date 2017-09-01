/*
 *  Copyright 2013 David Edmundson <davidedmundson@kde.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */

import QtQuick 2.7
import QtQuick.Controls 1.0 as QtControls
import QtQuick.Layouts 1.3 as QtLayouts
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

import "clock"
import "timekeeper"

QtLayouts.ColumnLayout {
    id: generalPage

    property alias cfg_showCalendar: showcalendar.checked
    property alias cfg_clockState: clockposition.currentIndex
    property alias cfg_showCogs: wheelsshow.checked
    property alias cfg_whellState: tickMotion.currentIndex
    property alias cfg_stainedGlassState: stainedglassstate.currentIndex
    property alias cfg_terraState: terrastate.currentIndex
    property int cfg_terraImageIndex: 1
    property alias cfg_yearFormat: yearFormat.currentIndex
    property alias cfg_lat: latitude.text
    property alias cfg_lon: longitude.text

    TextMetrics {
      id: textMetrics
    }

    function requiredWidth(states) {
        // Find width of longest string
        var widest = 0
        for(var i = 0; i < states.count; i++){
          // TODO: Figure out how to get the width properly.
          //       It is working out the text size, but the width
          //       of combo box needs to include the padding round
          //       the text and the button. This workaround adds
          //       a fiddle factor.
          textMetrics.text = states.get(i).key + "WWW"
          widest = Math.max(textMetrics.width, widest)
        }
        return widest
    }


    TerraImageChoices {
        id: terraImageChoices
    }

    QtLayouts.ColumnLayout {
        QtLayouts.Layout.alignment: Qt.AlignTop
        anchors.fill: parent

        QtControls.CheckBox {
            id: showcalendar
            text: i18n("Show Calendar")
        }

        QtControls.CheckBox {
            id: wheelsshow
            text: i18n("Show Clock Cogs")
        }

        QtLayouts.RowLayout {
            spacing: 15
            QtControls.Label {
                text: i18n("Tick Motion")
            }
            QtControls.ComboBox {
                id: tickMotion
                textRole: "key"
                model: tickMotionStates

                TickMotionStates {
                  id: tickMotionStates

                  Component.onCompleted: {

                    setProperty(0, "key", i18n("Off"))
                    setProperty(1, "key", i18n("Clock"))
                    setProperty(2, "key", i18n("Clock and Calendar"))

                    // Find width of longest string
                    tickMotion.implicitWidth = requiredWidth(tickMotionStates)
                  }
                }
            }
        }

        QtLayouts.RowLayout {
            spacing: 15
            QtControls.Label {
                text: i18n("Clock Position")
            }
            QtControls.ComboBox {
                id: clockposition
                textRole: "key"
                model: clockPositionStates

                ClockStates {
                  id: clockPositionStates

                  Component.onCompleted: {
                    setProperty(0, "key", i18n("In"))
                    setProperty(1, "key", i18n("Out"))

                    // Find width of longest string
                    clockposition.implicitWidth = requiredWidth(clockPositionStates)                  }
                }
            }
        }

        QtLayouts.RowLayout {
            spacing: 15
            QtControls.Label {
                text: i18n("Stained Glass")
            }
            QtControls.ComboBox {
                id: stainedglassstate
                textRole: "key"
                model: stainedGlassStates

                StainedGlassStates {
                  id: stainedGlassStates

                  Component.onCompleted: {
                    setProperty(0, "key", i18n("Plain"))
                    setProperty(1, "key", i18n("Green"))
                    setProperty(2, "key", i18n("Purple"))

                    // Find width of longest string
                    stainedglassstate.implicitWidth = requiredWidth(stainedGlassStates)
                  }
                }
            }
        }

        QtLayouts.RowLayout {
            spacing: 15
            QtControls.Label {
                text: i18n("Terra State")
            }
            QtControls.ComboBox {
                id: terrastate
                textRole: "key"
                model: terraStates

                TerraStates {
                    id: terraStates
                    Component.onCompleted: {
                        setProperty(0, "key", i18n("Earth & Moon"))
                        setProperty(1, "key", i18n("Big Moon"))
                        //setProperty(2, "key", i18n("Big Earth")) TODO fix Marble

                        // Find width of longest string
                        terrastate.implicitWidth = requiredWidth(terraStates)
                    }
                }
            }
        }

        QtLayouts.RowLayout {

            QtControls.Label {
                text: i18n("Terra Image")
            }

            PlasmaComponents.ToolButton {
                id: previousButton
                iconSource: "go-previous"
                enabled: cfg_terraImageIndex > 0
                onClicked: cfg_terraImageIndex -= 1
            }

            Image {
                id: terraPreview
                width: 50
                height: 50
                source: 'terra/' + terraImageChoices.getFilename(cfg_terraImageIndex)
                sourceSize.width: width
                sourceSize.height: height
            }

            PlasmaComponents.ToolButton {
                id: nextButton
                iconSource: "go-next"
                enabled: cfg_terraImageIndex < terraImageChoices.count - 1
                onClicked: cfg_terraImageIndex += 1
            }

        }

        QtLayouts.RowLayout {
            QtControls.Label {
                text: i18n("Year format")
            }
            QtControls.ComboBox {
                id: yearFormat
                textRole: "key"
                model: ListModel {
                    id: yyyy
                    dynamicRoles: true
                    Component.onCompleted: {
                        var now = new Date().getFullYear()
                        append({key: (now % 100).toString(), value: 0})
                        append({key: now.toString(), value: 1})

                        // Find width of longest string
                        yearFormat.implicitWidth = requiredWidth(yyyy)
                    }
                }
            }
        }

        QtLayouts.RowLayout {
            QtControls.Label {
                text: i18n("Latitude + Longitude")
            }
            QtControls.TextField {
                id: latitude
            }
            QtControls.TextField {
                id: longitude
            }
        }

    }
}
