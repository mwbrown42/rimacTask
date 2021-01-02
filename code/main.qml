/*
 * Rimac Video Editor - An Interview Task for New Software Developers
 *
 * © Mike Brown, December 2020.
 * mwbrown42@gmail.com
 *
 * This is the main application window.  Its two buttons allow the user to explore
 * the Raw Video or Edited Video side of the app.
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.2
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.0
import Qt.labs.folderlistmodel 2.15
import Qt.labs.settings 1.0

// CRITICAL: If running this on Windows, you must download and install
// K-Lite Codec pack from https://codecguide.com/download_k-lite_codec_pack_basic.htm

// This is the initial user interface screen.  It shows some graphics and lets the user
// enter the Raw or Edited part of the application
ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1024
    height: 768
    title: qsTr("Rimac 1.4 Megawatt Video Editor")

    // Save folder path that the user selected during the previous run
    Settings {
        id: folderDialogSettings
        property url folder
    }

    // Display the Rimac corporate logo across the top
    ColumnLayout {
        id: mainWindowRowLayout
        width: parent.width
        height: parent.height
        clip: true
        spacing: 10
        transformOrigin: Item.TopLeft

        // Display the corporate logo across the top of the screen
        Image {
            id: corporateImage
            width: parent.width
            height: 200
            source: "Rimac_Automobili_horizontal-1.png"
            clip: false
            Layout.fillHeight: true
            Layout.fillWidth: true
            sourceSize.height: 1067
            sourceSize.width: 1600
            fillMode: Image.PreserveAspectCrop
        }

        // Display and act on the Raw and Edited Video buttons
        RowLayout {
            id: buttonsColumnLayout
            width: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true

            // When clicked, create and launch the Raw Video thumbnail window, coming from a different QML file
            Button {
                id: rawVideosButton
                height: 80
                text: qsTr("Raw Videos")
                onClicked:
                {
                    var rawFolderChoiceDialogComponent = Qt.createComponent("rawFolderChoiceDialog.qml")
                    // console.log("Returned from raw createComponent")
                    if( rawFolderChoiceDialogComponent.status !== Component.Ready )
                    {
                        // console.log("Error:"+ rawVideoThumbnailWindowComponent.errorString() );
                        console.log("Error:"+ rawFolderChoiceDialogComponent.errorString() );
                    }
                    else
                    {
                        // console.log("rawVideoThumbnailWindowComponent created successfully")
                        var rawFolderChoiceDialogWindow    = rawFolderChoiceDialogComponent.createObject(null)
                        // console.log("raw dialog window: " + rawFolderChoiceDialogWindow)
                        rawFolderChoiceDialogWindow.open()
                    }
                }

            }

            // When clicked, create and launch the Edited Video thumbnail window, coming from a different QML file
            Button {
                id: editVideosButton
                height: 80
                text: qsTr("Edited Videos")
                onClicked:
                {
                    // When clicked, create and launch the Raw Video thumbnail window, coming from a different QML file
                    var editedFolderChoiceDialogComponent = Qt.createComponent("editedFolderChoiceDialog.qml")
                    if( editedFolderChoiceDialogComponent.status !== Component.Ready )
                    {
                        console.log("Error:"+ editedFolderChoiceDialogComponent.errorString() );
                    }
                    else
                    {
                        var editedFolderChoiceDialogWindow    = editedFolderChoiceDialogComponent.createObject(null)
                        editedFolderChoiceDialogWindow.open()
                    }
                }
            }
        }

        // Display the Concept_One and Concept_Two cars along the bottom of the screen
        RowLayout {
            id: carsColumnLayout
            width: parent.width
            height: 300
            spacing: 5
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Image {
                id: c1Image
                width: 100
                height: 200
                source: "Concept_One_rolling-4-1600x1000.jpg"
                Layout.fillHeight: true
                Layout.fillWidth: true
                sourceSize.height: 1067
                sourceSize.width: 1600
                fillMode: Image.Stretch
            }

            Image {
                id: c2Image
                width: 100
                height: 200
                source: "Rimac-Track_4-1600x1067.jpg"
                Layout.fillHeight: true
                Layout.fillWidth: true
                sourceSize.height: 1067
                sourceSize.width: 1600
                fillMode: Image.Stretch
            }
        }
    }
}


