/*
 * Rimac Video Editor - An Interview Task for New Software Developers
 *
 * © Mike Brown, December 2020.
 * mwbrown42@gmail.com
 *
 * This file defines the window that shows the user a series of thumbnails of edited videos.
 * When the user selects one, it is played in a fullscreen window.
 */

import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.11
import Qt.labs.folderlistmodel 2.15
import QtMultimedia 5.15
import Qt.labs.settings 1.0

// This is the Edited thumbail video window
ApplicationWindow
{
    id: editedVideoThumbnailWindowRoot
    title: "Edited Video Thumbnails"
    width: 800
    height: 460
    visible: false

    // Save the new folder when the user accepts it from the dialog
    property var editedFolderChoiceFolder
    onEditedFolderChoiceFolderChanged:
    {
        editedVideoFolderModel.folder = editedFolderChoiceFolder
    }

    // This grid lays out the thumbnails and allows for the dynamic sizing and position
    // when changed by the user
    GridView
    {
        id: editedVideoThumbnailListView
        anchors.fill: parent
        model: editedVideoFolderModel
        delegate: editedVideoThumbnailMediaDelegate
        cellWidth: (width / 2) - 5
        cellHeight: (height / 2) - 5

        // This model holds the list of files in the user's selected directory
        FolderListModel
        {
            id: editedVideoFolderModel
            nameFilters: ["*Edited*"]
            showFiles: true
            showDirs: false
            sortField: FolderListModel.Name
        }

        // This draws a blue box around each of the thumbnail videos
        Component
        {
            id: editedVideoThumbnailMediaDelegate

            Rectangle
            {
                id: editedVideoThumbnailMediaRectangle
                x: 10
                width: editedVideoThumbnailListView.cellWidth - 10
                height: editedVideoThumbnailListView.cellHeight - 10
                border.color: "blue"
                border.width: 2
                radius: 4

                // This Qt class implements the video player for the thumbnail.
                // In order to get a nice image, I seek forward one second and then pause the video
                Video
                {
                    id: editedVideoThumbnail
                    width: editedVideoThumbnailListView.cellWidth - 20
                    height: editedVideoThumbnailListView.cellHeight - 20
                    x: (editedVideoThumbnailMediaRectangle.width - editedVideoThumbnail.width) / 2
                    y: (editedVideoThumbnailMediaRectangle.height - editedVideoThumbnail.height) / 2
                    visible: true
                    autoLoad: true
                    autoPlay: true
                    source: fileUrl

                    // When the user clicks anywhere on the video, launch a fullscreen video player for it
                    MouseArea
                    {
                        id: editedFullscreenVideoLaunchArea
                        anchors.fill: parent
                        onPressed:
                        {
                            editedFullscreenVideoWindow.selectedFileUrl = editedVideoThumbnail.source // Set property attribute for the source file
                            editedFullscreenVideoWindow.showMaximized()
                        }
                    }

                    onPlaying:
                    {
                        // When it begins playing, jump 1 second and pause
                        editedVideoThumbnail.seek(1000)
                        editedVideoThumbnail.pause()
                    }

                    onStopped:
                    {
                        console.log("editedVideoThumbnailWindow: video stopped, setting file to empty");
                        editedFullscreenVideoWindow.selectedFileUrl = "";
                    }
                }
            }
        }
    }


    // This is a simple fullscreen video player, called when the user mouse clicks on a video thumbnail
    ApplicationWindow
    {
        id: editedFullscreenVideoWindow
        title: "Edited Fullscreen Video Player"
        objectName: "editedFullscreenVideoWindow"
        visible: false

        // Get the video filename and start playing
        property url selectedFileUrl
        onSelectedFileUrlChanged:
        {
            if( selectedFileUrl.toString() != "" )
            {
                editedVideoFullscreen.source = selectedFileUrl
                editedVideoFullscreen.play()
            }
        }

        // Position and control the video player window
        Video
        {
            id: editedVideoFullscreen
            visible: true
            anchors.fill: parent
            autoLoad: true
            autoPlay: true
            onStatusChanged:
            {
                if(status === MediaPlayer.Loaded)
                {
                    // Check metadata values if necessary
                }
            }
        }

        onClosing:
        {
            editedVideoFullscreen.stop()
            editedFullscreenVideoWindow.selectedFileUrl = "";
        }
    }
}
