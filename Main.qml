import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: root

    width: 480
    height: 720
    minimumWidth: 400
    minimumHeight: 620
    visible: true
    title: qsTr("Battery")
    color: "#070a0f"

    // ---- Smoothly animated copy of the backend value -------------------
    property real displayLevel: myBattery.level
    Behavior on displayLevel {
        NumberAnimation { duration: 450; easing.type: Easing.OutCubic }
    }

    // ---- Helpers --------------------------------------------------------
    function levelColor(l) {
        if (l <= 20) return "#f87171"   // red
        if (l <= 40) return "#fbbf24"   // amber
        if (l <= 75) return "#4ade80"   // green
        return "#2dd4bf"                // full / teal
    }

    // ---- Background -----------------------------------------------------
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#141c2b" }
            GradientStop { position: 1.0; color: "#06080c" }
        }
    }

    // =====================================================================
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 26

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "POWER CELL"
            color: "#4d5a75"
            font.pixelSize: 12
            font.letterSpacing: 5
        }

        // ------------------------ BATTERY GAUGE -------------------------
        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 220
            Layout.preferredHeight: 340

            // soft glow behind the battery
            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 1.5
                height: parent.height * 1.05
                radius: width / 2
                color: root.levelColor(root.displayLevel)
                opacity: 0.12
                Behavior on color { ColorAnimation { duration: 300 } }
            }

            // terminal cap
            Rectangle {
                id: cap
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                width: 70
                height: 16
                radius: 5
                color: "#2a3548"
            }

            // battery body
            Rectangle {
                id: body
                anchors.top: cap.bottom
                anchors.topMargin: 6
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: parent.height - cap.height - 6
                radius: 26
                color: "#0e1420"
                border.width: 3
                border.color: "#2a3548"

                // inner track
                Rectangle {
                    id: inner
                    anchors.fill: parent
                    anchors.margins: 12
                    radius: 16
                    color: "#101827"
                    clip: true

                    // animated fill
                    Rectangle {
                        id: fill
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: parent.height *
                                Math.max(0, Math.min(100, root.displayLevel)) / 100
                        radius: 16
                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: Qt.lighter(root.levelColor(root.displayLevel), 1.25)
                            }
                            GradientStop {
                                position: 1.0
                                color: root.levelColor(root.displayLevel)
                            }
                        }

                        // sheen highlight
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 3
                            radius: 14
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.22) }
                                GradientStop { position: 0.5; color: Qt.rgba(1,1,1,0.02) }
                                GradientStop { position: 1.0; color: Qt.rgba(1,1,1,0.0) }
                            }
                        }
                    }
                }
            }

            // big percentage readout
            Column {
                anchors.centerIn: body
                spacing: -10

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Math.round(root.displayLevel)
                    color: "#ffffff"
                    font.pixelSize: 70
                    font.weight: Font.Light
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "%"
                    color: "white"
                    font.pixelSize: 20
                    font.letterSpacing: 3
                    Behavior on color { ColorAnimation { duration: 300 } }
                }
            }
        }

        // ----------------------- ACTION BUTTONS -------------------------
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 18

            ActionButton {
                label: "Use Phone"
                leftPadding: 25
                symbol: "▼"
                baseColor: "#3a1e28"
                accentColor: "#f87171"
                onClicked: myBattery.decrease_Battry_Level(10)
            }

            ActionButton {
                label: "Charge"
                leftPadding: 35
                symbol: "▲"
                baseColor: "#14331f"
                accentColor: "#4ade80"
                onClicked: myBattery.increase_Battry_Level(10)
            }
        }

        // --------------------------- PRESETS ----------------------------
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            Chip {
                label: "LOW"
                accent: "#f87171"
                onClicked: myBattery.level = 5
            }
            Chip {
                label: "HALF"
                accent: "#fbbf24"
                onClicked: myBattery.level = 50
            }
            Chip {
                label: "FULL"
                accent: "#2dd4bf"
                onClicked: myBattery.level = 100
            }
        }
    }

    // =====================================================================
    //  Reusable inline components
    // =====================================================================

    component ActionButton: Button {
        id: actionBtn
        property string label: ""
        property string symbol: ""
        property color baseColor: "#1e2637"
        property color accentColor: "#4f7dff"

        implicitHeight: 58
        implicitWidth: 160
        focusPolicy: Qt.NoFocus

        background: Rectangle {
            radius: 16
            color: actionBtn.down    ? Qt.darker(actionBtn.baseColor, 1.3)
                 : actionBtn.hovered ? Qt.lighter(actionBtn.baseColor, 1.25)
                 : actionBtn.baseColor
            border.width: 1
            border.color: actionBtn.hovered ? actionBtn.accentColor
                                            : Qt.rgba(1,1,1,0.06)
            Behavior on color { ColorAnimation { duration: 120 } }
            Behavior on border.color { ColorAnimation { duration: 150 } }
        }

        contentItem: RowLayout {
            spacing: 8

            Text {
                Layout.alignment: Qt.AlignVCenter
                text: actionBtn.symbol
                color: actionBtn.accentColor
                font.pixelSize: 16
            }
            Text {
                Layout.alignment: Qt.AlignVCenter
                text: actionBtn.label
                color: "#e6eefc"
                font.pixelSize: 15
                font.letterSpacing: 0.5
            }
        }
    }

    component Chip: Button {
        id: chipBtn
        property string label: ""
        property color accent: "#4f7dff"

        implicitHeight: 40
        leftPadding: 14
        rightPadding: 16
        focusPolicy: Qt.NoFocus

        background: Rectangle {
            radius: height / 2
            color: chipBtn.down    ? Qt.rgba(1,1,1,0.14)
                 : chipBtn.hovered ? Qt.rgba(1,1,1,0.08)
                 : Qt.rgba(1,1,1,0.04)
            border.width: 1
            border.color: chipBtn.hovered ? chipBtn.accent : Qt.rgba(1,1,1,0.10)
            Behavior on color { ColorAnimation { duration: 150 } }
            Behavior on border.color { ColorAnimation { duration: 150 } }
        }

        contentItem: RowLayout {
            spacing: 8

            Rectangle {
                Layout.alignment: Qt.AlignVCenter
                implicitWidth: 8
                implicitHeight: 8
                radius: 4
                color: chipBtn.accent
            }
            Text {
                Layout.alignment: Qt.AlignVCenter
                text: chipBtn.label
                color: chipBtn.hovered ? chipBtn.accent : "#c6d2e6"
                font.pixelSize: 13
                font.letterSpacing: 1
                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }
    }
}
