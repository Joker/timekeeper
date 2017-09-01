/**
    Copyright 2016 Bill Binder <dxtwjb@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.7 as QtQuick

/*
Defines the list of clock position states.
  key - shown in the ComboBox, text is updated when ComboBox is populated
  state - the state name
*/
QtQuick.ListModel {
  id: clockPositionStates

  QtQuick.ListElement {key:"A"; stateName:"in"}
  QtQuick.ListElement {key:"B"; stateName:"out"}

  function getStateName(reqdValue) {
    return (clockPositionStates.count > 0) ? clockPositionStates.get(reqdValue).stateName : ""
  }

  function next(value) {
    return (value < clockPositionStates.count-1) ? value+1 : 0
  }
}
