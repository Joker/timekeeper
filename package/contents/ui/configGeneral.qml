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

import "clock"
import "timekeeper"

QtLayouts.ColumnLayout {
    id: generalPage

    property alias cfg_showCalendar: showcalendar.checked
    property alias cfg_clockState: clockposition.currentIndex
    property alias cfg_showCogs: wheelsshow.checked
    property alias cfg_whellState: tickMotion.currentIndex
    property alias cfg_stainedGlassState: stainedglassstate.currentIndex
    property alias cfg_terraState: terrastate.text
    property alias cfg_terraImage: terraimage.text
    property alias cfg_yearFormat: yearFormat.currentIndex
    property alias cfg_lat: latitude.text
    property alias cfg_lon: longitude.text


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
                property int modelWidth
                textRole: "key"
                implicitWidth: modelWidth
                model: tickMotionStates

                TextMetrics {
                  id: textMetrics
                }

                TickMotionStates {
                  id: tickMotionStates

                  Component.onCompleted: {

                    setProperty(0,"key", i18n("Off"))
                    setProperty(1,"key", i18n("Clock"))
                    setProperty(2,"key", i18n("Clock and Calendar"))

                    // Find width of longest string
                    var widest = 0
                    for(var i = 0; i < tickMotionStates.count; i++){
                      // TODO: Figure out how to get the width properly.
                      //       It is working out the text size, but the width
                      //       of combo box needs to include the padding round
                      //       the text and the button. This workaround adds
                      //       a fiddle factor.
                      textMetrics.text = tickMotionStates.get(i).key + "WWWW"
                      widest = Math.max(textMetrics.width, widest)
                    }
                    tickMotion.modelWidth = widest
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
                    setProperty(0,"key", i18n("In"))
                    setProperty(1,"key", i18n("Out"))
                  }
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
                    setProperty(0,"key", i18n("Plain"))
                    setProperty(1,"key", i18n("Green"))
                    setProperty(2,"key", i18n("Purple"))
                  }
                }
            }
        }

        QtLayouts.RowLayout {
            spacing: 15
            QtControls.Label {
                text: i18n("Terra State")
            }
            QtControls.TextField {
                id: terrastate
            }
        }

        QtLayouts.RowLayout {
            QtControls.Label {
                text: i18n("Terra Image")
            }
            QtControls.TextField {
                id: terraimage
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
                  dynamicRoles: true
                  Component.onCompleted: {
                    var now = new Date().getFullYear()
                    append({key: (now % 100).toString(), value: 0})
                    append({key: now.toString(), value: 1})
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
