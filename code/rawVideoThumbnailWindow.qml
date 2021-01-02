/*
 * Rimac Video Editor - An Interview Task for New Software Developers
 *
 * © Mike Brown, December 2020.
 * mwbrown42@gmail.com
 *
 * This file defines the window that shows the user a series of thumbnails of videos.
 * When the user selects one, it is played in a fullscreen window.
 * When the user selects the Edit button for a video, it is prepared for overlay editing
 */

import QtQml 2.15
import QtQuick 2.3
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import Qt.labs.folderlistmodel 2.15
import QtMultimedia 5.15
import QtQuick.Layouts 1.15
import MikeOverlayFilter 1.0
import InterchangeData 1.0

// This is the Raw thumbail video window
ApplicationWindow
{
    id: rawVideoThumbnailWindowRoot
    title: "Raw Video Thumbnails And Edit Control"
    width: 800
    height: 600
    visible: false

    // Save the new folder when the user accepts it from the dialog
    property var rawFolderChoiceFolder
    onRawFolderChoiceFolderChanged:
    {
        rawVideoFolderModel.folder = rawFolderChoiceFolder
    }

    // This grid lays out the thumbnails and allows for the dynamic sizing and position
    // when changed by the user
    GridView
    {
        id: rawVideoThumbnailListView
        anchors.fill: parent
        model: rawVideoFolderModel
        delegate: rawVideoThumbnailMediaDelegate
        cellWidth: (width / 2) - 5
        cellHeight: (height / 2) - 5

        // This model holds the list of files in the user's selected directory
        FolderListModel
        {
            id: rawVideoFolderModel
            nameFilters: ["*"]
            showFiles: true
            showDirs: false
            sortField: FolderListModel.Name
        }

        // This contains the definition for each of the thumbnails, containing the Edit button and video
        Component
        {
            id: rawVideoThumbnailMediaDelegate

            Rectangle
            {
                id: rawVideoThumbnailMediaRectangle
                x: 10
                width: rawVideoThumbnailListView.cellWidth - 10
                height: rawVideoThumbnailListView.cellHeight - 10
                border.color: "blue"
                border.width: 2
                radius: 4

                // This Qt class implements the video player for the thumbnail.
                // In order to get a nice image, I seek forward one second and then pause the video
                Video
                {
                    id: rawVideoThumbnail
                    width: rawVideoThumbnailListView.cellWidth - 20
                    height: rawVideoThumbnailListView.cellHeight - 20
                    x: (rawVideoThumbnailMediaRectangle.width - rawVideoThumbnail.width) / 2
                    visible: true
                    autoLoad: true
                    autoPlay: true
                    source: fileUrl

                    // When the user clicks anywhere on the video, launch a fullscreen video player for it
                    MouseArea
                    {
                        id: rawFullscreenVideoLaunchArea
                        anchors.fill: parent
                        onPressed:
                        {
                            rawPlainFullscreenVideoWindow.selectedFileUrl = rawVideoThumbnail.source
                            rawPlainFullscreenVideoWindow.showMaximized()
                        }
                    }

                    // When it begins playing, jump 1 second and pause
                    onPlaying:
                    {
                        rawVideoThumbnail.seek(1000)
                        rawVideoThumbnail.pause()
                    }

                    onStopped:
                    {
                        // console.log("videoRendererWindow: video stopped, setting file to empty");
                        videoRendererWindow.selectedFileUrl = "";
                    }
                }

                // Define and handle the Edit button
                Button
                {
                    id: editOverlaysVideoButton
                    x: (rawVideoThumbnailMediaRectangle.width - rawVideoThumbnail.width) / 2
                    y: (rawVideoThumbnailMediaRectangle.height - rawVideoThumbnail.height) / 2
                    height: 20
                    width: rawVideoThumbnail.width
                    text: qsTr("Edit")
                    visible: true

                    // When the user clicks the Edit button, create and launch the overlay settings dialog
                    onClicked:
                    {
                        var editorOverlaySettingsDialogComponent = Qt.createComponent("editorOverlaySettingsDialog.qml")
                        if( editorOverlaySettingsDialogComponent.status !== Component.Ready )
                        {
                            console.log("Error:"+ editorOverlaySettingsDialogComponent.errorString() );
                        }
                        else
                        {
                            var editorOverlaySettingsDialogWindow = editorOverlaySettingsDialogComponent.createObject(mainWindow)
                            editorOverlaySettingsDialogWindow.show()
                        }
                    }
                }
            }
        }
    }

    // This is the window that shows the graphical editing overlays to the user as the video plays
    ApplicationWindow
    {
        id: videoRendererWindow
        title: "Video Renderer"
        objectName: "videoRenderer"
        visible: false
        width: 960
        height: 540

        // This is where I catch the updated frame number from the C++ videoo filter.
        Connections
        {
            target: interchangeData
            onFramenumberChanged:
            {
                // Do the math to calculate percentage complete and display to the user
                localVars.frameNumber = interchangeData.framenumber
                localVars.percentComplete = localVars.frameNumber / localVars.totalFrames * 100.0;
                localVars.percentCompleteWhole = Math.floor(localVars.percentComplete)
                videoRendererProgressBarPercentLabel.text = localVars.percentCompleteWhole + " %"
                videoRendererProgressBar.value = localVars.percentComplete
            }
        }

        // Get the video filename and start playing
        property url selectedFileUrl
        onSelectedFileUrlChanged:
        {
            localVars.duration = -1
            localVars.frameRate = -1
            localVars.userCancel = false

            if( selectedFileUrl.toString() != "" )
            {
                interchangeData.setSliderMin(localVars.sliderMin)
                interchangeData.setSliderMax(localVars.sliderMax)

                videoRendererMediaPlayer.source = selectedFileUrl
                videoRendererMediaPlayer.play()
            }
        }

        // Variable scratchpad
        Item
        {
            id: localVars
            property var metaData
            property int numericalRandomValue: 0.0
            property int sliderValue: 0
            property int sliderMin: 0
            property int sliderMax: 20
            property bool sliderUp: true
            property real shapeGradientRandomColorR: 0.0
            property real shapeGradientRandomColorG: 0.0
            property real shapeGradientRandomColorB: 0.0
            property color shapeGradientRandomColor1
            property color shapeGradientRandomColor2
            property int shapeGradientRandomValueX: 0
            property int shapeGradientRandomValueY: 0
            property real duration: -1.0
            property real frameRate: -1.0
            property real frameNumber: 0.0
            property real totalFrames: 0.0
            property real percentComplete: 0.0
            property int percentCompleteWhole: 0.0
            property bool userCancel: false
        }

        // This lays out the video window, the prorgress bar, the percent complete label and the Cancel button
        Rectangle
        {
            id: videoRendererEngineRectangle
            x: 10
            y: 10
            width: parent.width - 20
            height: parent.height - 20
            border.color: "blue"
            border.width: 2
            radius: 4

            // Since we're applying a filter to every frame of the video, we have to use the MediaPlayer
            // and VideoOutput classes, rather than the Video class we use elsewhere for video handling
            // This is the video loading and decoding engine, it passes over the VideoOutput for playing and filtering
            MediaPlayer {
                id: videoRendererMediaPlayer
                autoLoad: true
                autoPlay: true
                onDurationChanged:
                {
                    localVars.duration = videoRendererMediaPlayer.duration
                    localVars.frameRate  = videoRendererMediaPlayer.metaData.videoFrameRate
                    localVars.totalFrames = Math.floor(localVars.duration / 1000.0 * localVars.frameRate)
                }

                onStopped:
                {
                    // Playback and image file generation has halted.  This is where I could potentiall postprocess
                    // to generate a new video file because Qt doesn't provide anything natively:
                    // Invoke ffmpeg to create the new video FileDialog
                    //     Format: ffmpeg -framerate XX -i rimac%06d.png <filename>-Edited.mp4
                    //     Doesn't work on Windows because it can't glob a group of files by the pattern
                    // Invoke ffmpeg to extract the audio from the original video
                    // Invoke ffmpeg to combine the audio track and the edited silent video file
                }
            }

            // This shows the video frames on the screen and allows us to assign our filter that
            // does all of the graphical overlays
            VideoOutput {
                id: videoRendererVideoOutput
                source: videoRendererMediaPlayer
                x: 10
                y: 10
                width: videoRendererEngineRectangle.width - x - x
                height: videoRendererEngineRectangle.height - 65
                visible: true
                filters: [ overlayFilter ]
            }

            // Simple declaration only, the work is done in C++
            OverlayFilter
            {
                id: overlayFilter
            }

            // Define and operate the progress bar row
            RowLayout
            {
                id: videoRendererProgressBarRow
                x: 10
                y: videoRendererVideoOutput.height + 20
                width: videoRendererEngineRectangle.width  - x - x;
                height: 40
                Layout.alignment: Qt.AlignVCenter

                Label {
                    id: videoRendererProgressBarLabel
                    x: 20
                    text: qsTr("Editing Progress: ")
                }

                // The (ugly) Qt progress bar
                ProgressBar {
                    id: videoRendererProgressBar
                    Layout.preferredWidth: parent.width * 0.7
                    from: 0.0
                    to: 100.0
                    visible: true
                    value: 0
                }

                // The percent complete label
                Label {
                    id: videoRendererProgressBarPercentLabel
                    width: 40
                    text: qsTr("0 %")

                }

                // And the Cancel button
                Button {
                    id: videoRendererProgressBarCancelButton
                    text: qsTr("Cancel")
                    onClicked:
                    {
                        localVars.userCancel = true
                        videoRendererMediaPlayer.stop()
                        videoRendererWindow.close()
                    }
                }
            }

            // These three timers are defined by the task and used to trigger the generation of new random data
            // for the numerical value, gradient box and slider bar.  These values are sent over to the filter
            // via the shared global InterchangeData object

            // The numerical timer fires every 300ms
            Timer {
                id: numericalTimer
                interval: 300
                repeat: true
                running: true
                onTriggered:
                {
                    localVars.numericalRandomValue = Math.floor(Math.random() * 99).toFixed()
                    interchangeData.setNumericalRandomValue(localVars.numericalRandomValue)
                }
            }

            // The gradient box timer fires every 1000ms
            Timer {
                id: shapeGradientTimer
                interval: 1000
                repeat: true
                running: true
                onTriggered:
                {
                    localVars.shapeGradientRandomColorR = Math.random()
                    localVars.shapeGradientRandomColorG = Math.random()
                    localVars.shapeGradientRandomColorB = Math.random()
                    localVars.shapeGradientRandomColor1 = Qt.rgba(  localVars.shapeGradientRandomColorR,
                                                                  localVars.shapeGradientRandomColorG,
                                                                  localVars.shapeGradientRandomColorB,
                                                                  0.5)

                    localVars.shapeGradientRandomColorR = Math.random()
                    localVars.shapeGradientRandomColorG = Math.random()
                    localVars.shapeGradientRandomColorB = Math.random()
                    localVars.shapeGradientRandomColor2 = Qt.rgba(  localVars.shapeGradientRandomColorR,
                                                                  localVars.shapeGradientRandomColorG,
                                                                  localVars.shapeGradientRandomColorB,
                                                                  0.5)

                    localVars.shapeGradientRandomValueX = Math.floor(Math.random() * videoRendererVideoOutput.width)
                    localVars.shapeGradientRandomValueY = Math.floor(Math.random() * videoRendererVideoOutput.height)


                    interchangeData.setShapeGradientRandomColor1(localVars.shapeGradientRandomColor1)
                    interchangeData.setShapeGradientRandomColor2(localVars.shapeGradientRandomColor2)
                    interchangeData.setShapeGradientRandomValueX(localVars.shapeGradientRandomValueX)
                    interchangeData.setShapeGradientRandomValueY(localVars.shapeGradientRandomValueY)
                }
            }

            // The slider numerical timer fires every 500ms
            Timer {
                id: sliderTimer
                interval: 500
                repeat: true
                running: true
                onTriggered:
                {
                    // Convoluted way to slide between sliderMin and sliderMax without if statements
                    localVars.sliderUp ? localVars.sliderValue += 1: localVars.sliderValue -= 1
                    localVars.sliderValue <= localVars.sliderMin ? localVars.sliderUp = true : 0
                    localVars.sliderValue >= localVars.sliderMax ? localVars.sliderUp = false : 0
                    interchangeData.setSliderValue(localVars.sliderValue);
                }
            }
        }
        onClosing:
        {
            videoRendererMediaPlayer.stop()
            videoRendererWindow.selectedFileUrl = "";
        }
    }


    // This is a simple fullscreen video player, called when the user mouse clicks on a video thumbnail
    ApplicationWindow
    {
        id: rawPlainFullscreenVideoWindow
        title: "Raw Plain Fullscreen Video Player"
        objectName: "rawPlainFullscreenVideoWindow"
        visible: false

        // Get the video filename and start playing
        property url selectedFileUrl
        onSelectedFileUrlChanged:
        {
            if( selectedFileUrl.toString() != "" )
            {
                rawPlainVideoFullscreen.source = selectedFileUrl
                rawPlainVideoFullscreen.play()
            }
        }

        // Position and control the video player window
        Video
        {
            id: rawPlainVideoFullscreen
            visible: true
            anchors.fill: parent
            autoLoad: true
            autoPlay: true
            onStatusChanged:
            {
                if(status === MediaPlayer.Loaded)
                {
                    // Plays automatically
                }
            }
        }

        onClosing:
        {
            rawPlainVideoFullscreen.stop()
            rawPlainFullscreenVideoWindow.selectedFileUrl = "";
        }
    }
}


