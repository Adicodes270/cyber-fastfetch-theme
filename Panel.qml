import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root
    implicitWidth: 380
    implicitHeight: 310

    property string statusText: "Ready to install"
    property color statusColor: "#94a3b8"
    property string pluginDir: Qt.resolvedUrl("presets/").toString().replace("file://", "")

    Process {
        id: applyProc
        command: [
            "bash", "-c",
            "mkdir -p ~/.config/fastfetch/backup && " +
            "[ -f ~/.config/fastfetch/config.jsonc ] && cp ~/.config/fastfetch/config.jsonc ~/.config/fastfetch/backup/config.jsonc.bak; " +
            "cp '" + root.pluginDir + "config.jsonc' ~/.config/fastfetch/config.jsonc && " +
            "cp '" + root.pluginDir + "cyber_logo.txt' ~/.config/fastfetch/cyber_logo.txt"
        ]
        onExited: (code) => {
            if (code === 0) {
                root.statusText = "✓ Theme applied! Run fastfetch in a terminal."
                root.statusColor = "#34d399"
            } else {
                root.statusText = "✕ Failed (exit code " + code + ")"
                root.statusColor = "#f87171"
            }
        }
    }

    Process {
        id: restoreProc
        command: [
            "bash", "-c",
            "[ -f ~/.config/fastfetch/backup/config.jsonc.bak ] && " +
            "cp ~/.config/fastfetch/backup/config.jsonc.bak ~/.config/fastfetch/config.jsonc"
        ]
        onExited: (code) => {
            if (code === 0) {
                root.statusText = "↺ Restored previous config"
                root.statusColor = "#38bdf8"
            } else {
                root.statusText = "No backup found"
                root.statusColor = "#fbbf24"
            }
        }
    }

    // Outer translucent dark glass card
    Rectangle {
        anchors.fill: parent
        radius: 14
        color: "#e60b1120"
        border.color: "#3338bdf8"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            // Header Row
            RowLayout {
                Layout.fillWidth: true

                ColumnLayout {
                    spacing: 2
                    Text {
                        text: "Cyber Fastfetch"
                        color: "#f8fafc"
                        font.pixelSize: 17
                        font.bold: true
                    }
                    Text {
                        text: "Cyan & Neon Violet System Info Preset"
                        color: "#64748b"
                        font.pixelSize: 12
                    }
                }

                Item { Layout.fillWidth: true }

                // Version Pill
                Rectangle {
                    width: 48
                    height: 22
                    radius: 11
                    color: "#1a38bdf8"
                    border.color: "#4438bdf8"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "v1.0"
                        color: "#38bdf8"
                        font.pixelSize: 11
                        font.bold: true
                    }
                }
            }

            // Mini Terminal Preview Box
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 10
                color: "#060913"
                border.color: "#1e293b"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 14

                    // Mini Arch ASCII art
                    Text {
                        text: "    /\\\n   /  \\\n  / /\\ \\\n / ____ \\\n/_/    \\_\\"
                        color: "#38bdf8"
                        font.family: "monospace"
                        font.pixelSize: 11
                        lineHeight: 1.15
                    }

                    // Mini Module Preview
                    ColumnLayout {
                        spacing: 4
                        Layout.fillWidth: true

                        Text {
                            text: "user @ omarchy"
                            color: "#34d399"
                            font.family: "monospace"
                            font.pixelSize: 11
                            font.bold: true
                        }
                        Text {
                            text: "󰍹 SYSTEM     Arch / Hyprland"
                            color: "#38bdf8"
                            font.family: "monospace"
                            font.pixelSize: 10
                        }
                        Text {
                            text: "󱂬 ENV        foot / bash"
                            color: "#818cf8"
                            font.family: "monospace"
                            font.pixelSize: 10
                        }
                        Text {
                            text: "󰘚 HARDWARE   CPU / GPU / RAM"
                            color: "#34d399"
                            font.family: "monospace"
                            font.pixelSize: 10
                        }

                        // Color Palette Dots
                        Row {
                            spacing: 6
                            topPadding: 4
                            Repeater {
                                model: ["#38bdf8", "#818cf8", "#34d399", "#f472b6", "#fbbf24"]
                                Rectangle {
                                    width: 8
                                    height: 8
                                    radius: 4
                                    color: modelData
                                }
                            }
                        }
                    }
                }
            }

            // Action Buttons
            RowLayout {
                spacing: 10
                Layout.fillWidth: true

                Rectangle {
                    id: applyBtn
                    Layout.fillWidth: true
                    height: 36
                    radius: 8
                    color: applyMouse.containsMouse ? "#7dd3fc" : "#38bdf8"

                    Text {
                        anchors.centerIn: parent
                        text: "Apply Theme"
                        color: "#090d16"
                        font.pixelSize: 13
                        font.bold: true
                    }

                    MouseArea {
                        id: applyMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: applyProc.running = true
                    }
                }

                Rectangle {
                    id: restoreBtn
                    Layout.fillWidth: true
                    height: 36
                    radius: 8
                    color: restoreMouse.containsMouse ? "#1e293b" : "#0f172a"
                    border.color: "#334155"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Restore Backup"
                        color: "#cbd5e1"
                        font.pixelSize: 13
                    }

                    MouseArea {
                        id: restoreMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: restoreProc.running = true
                    }
                }
            }

            // Status Footer
            Text {
                text: root.statusText
                color: root.statusColor
                font.pixelSize: 11
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}