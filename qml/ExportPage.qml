/*
 * Copyright (C) 2016 Stefano Verzegnassi
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License 3 as published by
 * the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see http://www.gnu.org/licenses/.
 */

import QtQuick 2.9
import Lomiri.Components 1.3
import Lomiri.Components.Themes 1.3
import Lomiri.Content 1.3

Page {
    id: picker
    property var activeTransfer

    property string url
    property var handler
    property var contentType

    signal cancel()
    signal imported(string fileUrl)

    header: PageHeader {
        title: i18n.tr("    Save or Open with:")
        Icon{
            anchors{
                left: parent.left
                top: parent.top
                topMargin: units.gu(1.5)
                bottom: parent.bottom
                bottomMargin: units.gu(1.5)
            }
            width: height
            name: "go-previous"
            color: theme.palette.normal.backgroundText
        }
        MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked:{ 
        stack.pop()
        }
        }
    }

    ContentPeerPicker {
        anchors {
            fill: parent
            topMargin: picker.header.height
        }

        visible: parent.visible
        showTitle: false
        contentType: ContentType.All
        handler: ContentHandler.Destination

        onPeerSelected: {
            picker.activeTransfer = peer.request()
            picker.activeTransfer.stateChanged.connect(function() {
                if (picker.activeTransfer.state === ContentTransfer.InProgress) {
                    console.log("Export: In progress");
                    picker.activeTransfer.items = [ resultComponent.createObject(parent, {"url": url}) ];
                    picker.activeTransfer.state = ContentTransfer.Charged;
                    stack.pop()
                }
            })
        }

        onCancelPressed: {
            stack.pop()
        }
    }

    ContentTransferHint {
        id: transferHint
        anchors.fill: parent
        activeTransfer: picker.activeTransfer
    }

    Component {
        id: resultComponent

        ContentItem {}
    }
}
