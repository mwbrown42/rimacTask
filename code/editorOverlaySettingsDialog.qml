/*
 * Rimac Video Editor - An Interview Task for New Software Developers
 *
 * © Mike Brown, December 2020.
 * mwbrown42@gmail.com
 *
 * This file defines the dialog box that acccepts the user's graphical overlay settings
 * and launches the video processing filter.
 */

import QtQuick 2.3
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Dialogs.qml 1.0
import QtQuick.Layouts 1.11
import QtQuick.Window 2.15
import Qt.labs.folderlistmodel 2.15
import Qt.labs.settings 1.0
import QtMultimedia 5.15

ApplicationWindow
{
    id: videoEditorOverlaySettingsDialog
    width: 350
    height: 250
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width

    title: "Editor Overlay Settings"
    visible: true

    property bool numericValueSetting: false
    property int numericValueX: 0
    property int numericValueY: 0
    property bool shapeGradientSetting: false
    property int shapeGradientX: 0
    property int shapeGradientY: 0
    property bool sliderSetting: false
    property int sliderX: 0
    property int sliderY: 0


    // When the user clicks this button, send the user's values over to C++ and
    // launch the video filter processing
    footer: DialogButtonBox {
        id: videoEditorOverlaysSettingsDialogFooter
        x: 0
        y: 250
        Button {
            id: applyButton
            text: qsTr("Apply To Video")
            onClicked:
            {
                numericValueSetting = numericValueCheckBox.checked
                interchangeData.setNumericalRandomValueEnabled(numericValueSetting)
                numericValueX = numericValueTextFieldX.text
                interchangeData.setNumericalRandomValueX(numericValueX)
                numericValueY = numericValueTextFieldY.text
                interchangeData.setNumericalRandomValueY(numericValueY)

                shapeGradientSetting = shapeGradientCheckBox.checked
                interchangeData.setShapeGradientEnabled(shapeGradientSetting)
                shapeGradientX = shapeGradientTextFieldX.text
                interchangeData.setShapeGradientRandomValueX(shapeGradientX)
                shapeGradientY = shapeGradientTextFieldY.text
                interchangeData.setShapeGradientRandomValueY(shapeGradientY)

                sliderSetting = sliderCheckBox.checked
                interchangeData.setSliderEnabled(sliderSetting)
                sliderX = sliderTextFieldX.text
                interchangeData.setSliderX(sliderX)
                sliderY = sliderTextFieldY.text
                interchangeData.setSliderY(sliderY)

                videoRendererWindow.selectedFileUrl = rawVideoThumbnail.source
                videoRendererWindow.show()

                videoEditorOverlaySettingsDialog.close()
            }
        }
        Button
        {
            id: cancelButton
            text: qsTr("Cancel")
            onClicked: videoEditorOverlaySettingsDialog.close()
        }
    }

    // This defines the layout and actions of the user's settings for the 3 graphics overlays
    GridLayout {
        id: videoOverlaySettingsGridLayout
        height: 180
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        rows: 3
        columns: 5
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        CheckBox {
            id: numericValueCheckBox
            text: qsTr("Numeric Value")
        }

        Label {
            id: numericValueXLabel
            text: qsTr("X")
        }

        TextField {
            id: numericValueTextFieldX
            width: 80
            text: "100"
            Layout.maximumWidth: 80
            validator: IntValidator {bottom: 0; top: 1919;}
        }

        Label {
            id: numericValueYLabel
            text: qsTr("Y")
        }

        TextField {
            id: numericValueTextFieldY
            width: 80
            text: "100"
            Layout.maximumWidth: 80
            validator: IntValidator {bottom: 0; top: 1079;}
        }


        CheckBox {
            id: shapeGradientCheckBox
            text: qsTr("Shape Gradient")
        }

        Label {
            id: shapeGradientXLabel
            text: qsTr("X")
        }

        TextField {
            id: shapeGradientTextFieldX
            width: 80
            text: "100"
            Layout.maximumWidth: 80
            validator: IntValidator {bottom: 0; top: 1919;}
        }

        Label {
            id: shapeGradientYLabel
            text: qsTr("Y")
        }

        TextField {
            id: shapeGradientTextFieldY
            width: 80
            text: "100"
            Layout.maximumWidth: 80
            validator: IntValidator {bottom: 0; top: 1079;}
        }

        CheckBox {
            id: sliderCheckBox
            text: qsTr("Slider")
        }

        Label {
            id: sliderXLabel
            text: qsTr("X")
        }

        TextField {
            id: sliderTextFieldX
            width: 80
            text: "20"
            Layout.maximumWidth: 80
            validator: IntValidator {bottom: 0; top: 1919;}
        }

        Label {
            id: sliderYLabel
            text: qsTr("Y")
        }

        TextField {
            id: sliderTextFieldY
            width: 80
            text: "400"
            Layout.maximumWidth: 80
            validator: IntValidator {bottom: 0; top: 1079;}
        }
    }
}
