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
Defines the list of images for terra.
  filename - relative to the ui/terra directory
*/
QtQuick.ListModel {
  id: terraImageChoices
  QtQuick.ListElement { value: 1; filename: "e1.png" }
  QtQuick.ListElement { value: 2; filename: "e2.png" }
  QtQuick.ListElement { value: 3; filename: "e3.png" }
  QtQuick.ListElement { value: 4; filename: "e4.png" }
  QtQuick.ListElement { value: 5; filename: "e5.png" }
  QtQuick.ListElement { value: 6; filename: "e6.png" }

  function getFilename(reqdValue) {
    return terraImageChoices.count>0 ? terraImageChoices.get(reqdValue).filename : ""
  }

  function next(value) {
    return (value < terraImageChoices.count-1) ? value+1 : 0
  }

}
