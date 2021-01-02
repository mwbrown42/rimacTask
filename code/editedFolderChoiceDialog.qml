/*
 * Rimac Video Editor - An Interview Task for New Software Developers
 *
 * © Mike Brown, December 2020.
 * mwbrown42@gmail.com
 *
 * This file defines the dialog box that allows the user to choose the directory for the edited video files.
 */

import QtQuick 2.0
import QtQuick.Dialogs 1.3

FileDialog
{
    id: editedFolderChoiceDialog
    title: "Please choose a video folder"
    selectFolder: true
    folder: folderDialogSettings.folder

    // When the user navigates and accepts the directory, create and launch the Edited Thumbnail window from a different QML file
    onAccepted:
    {
        // Preserve folder home across runs
        folderDialogSettings.folder = editedFolderChoiceDialog.folder

        // Create the object and pass the selected folder over to the thumnail video window as a property
        var editedVideoThumbnailWindowComponent = Qt.createComponent("editedVideoThumbnailWindow.qml")
        if( editedVideoThumbnailWindowComponent.status !== Component.Ready )
        {
            console.log("editedFolderChoiceDialog: Error:"+ editedVideoThumbnailWindowComponent.errorString() )
        }
        else
        {
            var editedVideoThumbnailWindow = editedVideoThumbnailWindowComponent.createObject( mainWindow, {editedFolderChoiceFolder: folder} )
            editedVideoThumbnailWindow.show()
        }
    }
    onRejected:
    {
        console.log("editedFolderChoiceDialog: User cancelled")
    }
}
