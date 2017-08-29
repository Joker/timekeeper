/**
    Copyright 2017 Bill Binder <dxtwjb@gmail.com>

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

import QtQuick 2.1 as QtQuick

/*
Defines the list of images for 'terra', i.e. earth+moon, big moon in centre,
or marble earth in centre.
key       - shown in the ComboBox - the actual text is added later, when the
            the ComboBox is being populated.
stateName - component state name
*/
QtQuick.ListModel {
  id: terraStates

  QtQuick.ListElement { key: "X"; stateName: "" }
  QtQuick.ListElement { key: "Y"; stateName: "big_moon" }
  //QtQuick.ListElement { key: "Z"; stateName: "big_earth" }  TODO fix Marble

  function getStateName(reqdValue) {
    return terraStates.count>0 ? terraStates.get(reqdValue).stateName : ""
  }

  function next(value) {
    return (value < terraStates.count-1) ? value+1 : 0
  }

}
