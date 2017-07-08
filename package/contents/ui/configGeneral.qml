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

import QtQuick 2.0
import QtQuick.Controls 1.0 as QtControls
import QtQuick.Layouts 1.3 as QtLayouts

QtLayouts.ColumnLayout {
    id: generalPage

    property alias cfg_mainState: mainstate.text
    property alias cfg_clockState: clockstate.text
    property alias cfg_whellState: wheelshidden.checked
    property alias cfg_stainedGlassState: stainedglassstate.text
    property alias cfg_terraState: terrastate.text
    property alias cfg_terraImage: terraimage.text
    property alias cfg_shortYear: shortYear.checked
    property double cfg_lat: 56.0
    property double cfg_lon: 03.0


    QtLayouts.ColumnLayout {
        QtLayouts.Layout.alignment: Qt.AlignTop
        anchors.fill: parent

        QtLayouts.RowLayout {
            spacing: 15
            QtControls.Label {
                text: i18n("Main State")
            }
            QtControls.TextField {
                id: mainstate
            }
        }

        QtLayouts.RowLayout {
            spacing: 15
            QtControls.Label {
                text: i18n("Clock State")
            }
            QtControls.TextField {
                id: clockstate
            }
        }

        QtControls.CheckBox {
            id: wheelshidden
            text: i18n("Hide Wheels")
        }


        QtLayouts.RowLayout {
            spacing: 15
            QtControls.Label {
                text: i18n("Stained Glass")
            }
            QtControls.TextField {
                id: stainedglassstate
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
            QtControls.CheckBox {
                id: shortYear
                text: i18n("Show short year")
            }
        }
    }
}
