import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Wayland
import qs.Ui

// Cyber Fastfetch - a small overlay panel that installs the theme preset into
// ~/.config/fastfetch and restores the previous config on demand.
//
// Open it with:
//   omarchy-shell shell toggle aditya27003.cyber-fastfetch
// or bind a key (see README).

Item {
  id: root

  readonly property string moduleName: "aditya27003.cyber-fastfetch"
  readonly property string pluginDir: Qt.resolvedUrl(".").toString().replace(/^file:\/\//, "")
  readonly property string applyScript: Qt.resolvedUrl("scripts/apply.sh").toString().replace(/^file:\/\//, "")
  readonly property string restoreScript: Qt.resolvedUrl("scripts/restore.sh").toString().replace(/^file:\/\//, "")
  readonly property bool busy: applyProc.running || restoreProc.running

  // Injected by the shell when the plugin is loaded.
  property var shell: null

  property bool opened: false
  property bool fastfetchFound: true
  property string statusText: "Ready to install"
  property color statusColor: "#94a3b8"

  function open(payloadJson) {
    root.opened = true
    Qt.callLater(function() { focusScope.forceActiveFocus() })
  }

  function close() {
    root.opened = false
  }

  function dismiss() {
    root.opened = false
    if (root.shell && typeof root.shell.hide === "function")
      root.shell.hide(root.moduleName)
  }

  function toggle() {
    if (root.opened) dismiss()
    else open("")
  }

  function runApply() {
    if (root.busy) return
    root.statusText = "Applying theme…"
    root.statusColor = "#38bdf8"
    applyProc.running = true
  }

  function runRestore() {
    if (root.busy) return
    root.statusText = "Restoring backup…"
    root.statusColor = "#38bdf8"
    restoreProc.running = true
  }

  Process {
    id: applyProc
    command: ["bash", root.applyScript, root.pluginDir]
    onExited: (code) => {
      if (code === 0) {
        root.statusText = "✓ Theme applied! Run fastfetch in a terminal."
        root.statusColor = "#34d399"
      } else {
        root.statusText = "✕ Could not apply the theme (exit " + code + ")"
        root.statusColor = "#f87171"
      }
    }
  }

  Process {
    id: restoreProc
    command: ["bash", root.restoreScript]
    onExited: (code) => {
      if (code === 0) {
        root.statusText = "↺ Restored your previous config"
        root.statusColor = "#38bdf8"
      } else {
        root.statusText = "No backup found yet — apply the theme first"
        root.statusColor = "#fbbf24"
      }
    }
  }

  Process {
    id: fastfetchProbe
    running: true
    command: ["bash", "-c", "command -v fastfetch"]
    onExited: (code) => {
      root.fastfetchFound = code === 0
      if (code !== 0) {
        root.statusText = "fastfetch is not installed"
        root.statusColor = "#fbbf24"
      }
    }
  }

  OverlayWindow {
    id: overlay
    shown: root.opened
    WlrLayershell.namespace: "omarchy-cyber-fastfetch"

    Rectangle {
      anchors.fill: parent
      color: "#73000000"
    }

    MouseArea {
      anchors.fill: parent
      onClicked: root.dismiss()
    }

    Rectangle {
      id: card
      width: 440
      height: 430
      anchors.centerIn: parent
      radius: 14
      color: "#f20b1120"
      border.color: "#3338bdf8"
      border.width: 1

      MouseArea { anchors.fill: parent; onClicked: {} }

      FocusScope {
        id: focusScope
        anchors.fill: parent
        focus: true

        Keys.onEscapePressed: root.dismiss()
        Keys.onPressed: (event) => {
          if (event.key === Qt.Key_A && event.modifiers === Qt.NoModifier) {
            root.runApply()
            event.accepted = true
          } else if (event.key === Qt.Key_R && event.modifiers === Qt.NoModifier) {
            root.runRestore()
            event.accepted = true
          }
        }

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: 18
          spacing: 14

          RowLayout {
            Layout.fillWidth: true
            spacing: 10

            ColumnLayout {
              spacing: 2
              Layout.fillWidth: true

              Text {
                text: "Cyber Fastfetch"
                color: "#f8fafc"
                font.pixelSize: 17
                font.bold: true
                textFormat: Text.PlainText
              }
              Text {
                text: "Cyan & Neon Violet System Info Preset"
                color: "#64748b"
                font.pixelSize: 12
                textFormat: Text.PlainText
              }
            }

            Rectangle {
              Layout.preferredWidth: 56
              Layout.preferredHeight: 22
              radius: 11
              color: "#1a38bdf8"
              border.color: "#4438bdf8"
              border.width: 1

              Text {
                anchors.centerIn: parent
                text: "v1.1.0"
                color: "#38bdf8"
                font.pixelSize: 11
                font.bold: true
                textFormat: Text.PlainText
              }
            }
          }

          Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 10
            color: "#060913"
            border.color: "#1e293b"
            border.width: 1
            clip: true

            RowLayout {
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              anchors.margins: 12
              spacing: 14

              Text {
                text: "    /\\\n   /  \\\n  / /\\ \\\n / ____ \\\n/_/    \\_\\"
                color: "#38bdf8"
                font.family: "monospace"
                font.pixelSize: 11
                lineHeight: 1.15
                textFormat: Text.PlainText
              }

              ColumnLayout {
                spacing: 4
                Layout.fillWidth: true

                Text {
                  text: "user @ omarchy"
                  color: "#34d399"
                  font.family: "monospace"
                  font.pixelSize: 11
                  font.bold: true
                  textFormat: Text.PlainText
                }
                Text {
                  text: "󰍹 SYSTEM     Arch / Hyprland"
                  color: "#38bdf8"
                  font.family: "monospace"
                  font.pixelSize: 10
                  textFormat: Text.PlainText
                }
                Text {
                  text: "󱂬 ENV        foot / bash"
                  color: "#818cf8"
                  font.family: "monospace"
                  font.pixelSize: 10
                  textFormat: Text.PlainText
                }
                Text {
                  text: "󰘚 HARDWARE   CPU / GPU / RAM"
                  color: "#34d399"
                  font.family: "monospace"
                  font.pixelSize: 10
                  textFormat: Text.PlainText
                }

                Row {
                  spacing: 6
                  topPadding: 4
                  Repeater {
                    model: ["#38bdf8", "#818cf8", "#34d399", "#f472b6", "#fbbf24"]
                    Rectangle {
                      required property string modelData
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

          RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Rectangle {
              id: applyBtn
              Layout.fillWidth: true
              Layout.preferredHeight: 36
              radius: 8
              color: applyMouse.containsMouse ? "#7dd3fc" : "#38bdf8"
              opacity: root.busy ? 0.55 : 1

              Text {
                anchors.centerIn: parent
                text: "Apply Theme"
                color: "#090d16"
                font.pixelSize: 13
                font.bold: true
                textFormat: Text.PlainText
              }

              MouseArea {
                id: applyMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.runApply()
              }
            }

            Rectangle {
              id: restoreBtn
              Layout.fillWidth: true
              Layout.preferredHeight: 36
              radius: 8
              color: restoreMouse.containsMouse ? "#1e293b" : "#0f172a"
              border.color: "#334155"
              border.width: 1
              opacity: root.busy ? 0.55 : 1

              Text {
                anchors.centerIn: parent
                text: "Restore Backup"
                color: "#cbd5e1"
                font.pixelSize: 13
                textFormat: Text.PlainText
              }

              MouseArea {
                id: restoreMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.runRestore()
              }
            }
          }

          ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
              Layout.alignment: Qt.AlignHCenter
              text: root.statusText
              color: root.statusColor
              font.pixelSize: 11
              textFormat: Text.PlainText
            }
            Text {
              Layout.alignment: Qt.AlignHCenter
              text: root.fastfetchFound ? "A apply · R restore · Esc close" : "Install fastfetch, then apply"
              color: "#475569"
              font.pixelSize: 10
              textFormat: Text.PlainText
            }
          }
        }
      }
    }
  }
}
