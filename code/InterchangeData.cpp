/*
 * Rimac Video Editor - An Interview Task for New Software Developers
 *
 * © Mike Brown, December 2020.
 * mwbrown42@gmail.com
 *
 * This class implements the data interchange between the QML side of the app and the C++ side of the app.
 */

#include <QDebug>
#include <QColor>
#include "InterchangeData.h"

InterchangeData::InterchangeData()
{
}

// Numerical value
bool numericalRandomValueEnabled;
int numericalRandomValue;
int numericalRandomValueX;
int numericalRandomValueY;

// Shape Gradient
bool shapeGradientEnabled;
QColor shapeGradientRandomColor1;
QColor shapeGradientRandomColor2;
int shapeGradientRandomValueX;
int shapeGradientRandomValueY;

// Slider
bool sliderEnabled;
int sliderValue;
int sliderMin;
int sliderMax;
int sliderX;
int sliderY;

int framerate;

// Passed back to QML via signal
int internalFramenumber;

// Every member has a getter and a setter

// Numerical Value
bool InterchangeData::getNumericalRandomValueEnabled()
{
    return numericalRandomValueEnabled;
}

void InterchangeData::setNumericalRandomValueEnabled(bool newNumericalRandomValueEnabled)
{
    numericalRandomValueEnabled = newNumericalRandomValueEnabled;
}

int InterchangeData::getNumericalRandomValue()
{
    return numericalRandomValue;
}

void InterchangeData::setNumericalRandomValue( int newNumericalRandomValue)
{
    numericalRandomValue = newNumericalRandomValue;
}

int InterchangeData::getNumericalRandomValueX()
{
    return numericalRandomValueX;
}

void InterchangeData::setNumericalRandomValueX( int newNumericalRandomValueX)
{
    numericalRandomValueX = newNumericalRandomValueX;
}

int InterchangeData::getNumericalRandomValueY()
{
    return numericalRandomValueY;
}

void InterchangeData::setNumericalRandomValueY( int newNumericalRandomValueY)
{
    numericalRandomValueY = newNumericalRandomValueY;
}


// Shape Gradient
bool InterchangeData::getShapeGradientEnabled()
{
    return shapeGradientEnabled;
}

void InterchangeData::setShapeGradientEnabled(bool newShapeGradientEnabled)
{
    shapeGradientEnabled = newShapeGradientEnabled;
}

QColor InterchangeData::getShapeGradientRandomColor1()
{
    return shapeGradientRandomColor1;
}

void InterchangeData::setShapeGradientRandomColor1( QColor newShapeGradientRandomColor1)
{
    shapeGradientRandomColor1 = newShapeGradientRandomColor1;
}

QColor InterchangeData::getShapeGradientRandomColor2()
{
    return shapeGradientRandomColor2;
}

void InterchangeData::setShapeGradientRandomColor2( QColor newShapeGradientRandomColor2)
{
    shapeGradientRandomColor2 = newShapeGradientRandomColor2;
}

int InterchangeData::getShapeGradientRandomValueX()
{
    return shapeGradientRandomValueX;
}

void InterchangeData::setShapeGradientRandomValueX( int newShapeGradientRandomValueX)
{
    shapeGradientRandomValueX = newShapeGradientRandomValueX;
}

int InterchangeData::getShapeGradientRandomValueY()
{
    return shapeGradientRandomValueY;
}

void InterchangeData::setShapeGradientRandomValueY( int newShapeGradientRandomValueY)
{
    shapeGradientRandomValueY = newShapeGradientRandomValueY;
}


// Slider
bool InterchangeData::getSliderEnabled()
{
    return sliderEnabled;
}

void InterchangeData::setSliderEnabled(bool newSliderEnabled)
{
    sliderEnabled = newSliderEnabled;
}

int InterchangeData::getSliderValue()
{
    return sliderValue;
}

void InterchangeData::setSliderValue( int newSliderValue)
{
    sliderValue = newSliderValue;
}

int InterchangeData::getSliderMin()
{
    return sliderMin;
}

void InterchangeData::setSliderMin( int newSliderMin)
{
    sliderMin = newSliderMin;
}

int InterchangeData::getSliderMax()
{
    return sliderMax;
}

void InterchangeData::setSliderMax( int newSliderMax)
{
    sliderMax = newSliderMax;
}

int InterchangeData::getSliderX()
{
    return sliderX;
}

void InterchangeData::setSliderX( int newSliderX)
{
    sliderX = newSliderX;
}

int InterchangeData::getSliderY()
{
    return sliderY;
}

void InterchangeData::setSliderY( int newSliderY)
{
    sliderY = newSliderY;
}

int InterchangeData::getFramerate()
{
    return framerate;
}

void InterchangeData::setFramerate( int newFramerate)
{
    framerate = newFramerate;
}

// Completion Percentage goes back to QML
int InterchangeData::framenumber() const
{
    // qDebug() << "InterchangeData:frameNumber(): giving frame number back to the QML side: " << internalFramenumber;
    return internalFramenumber;
}

// This setter is special because it implements the link of sending data from the C++ side to the QML side.
// It's done with special keyword tokens in the header file and the 'emit' keyword in front of the auto-generated notification method frameNumberChanged
void InterchangeData::setFramenumber( int newFramenumber)
{
    if( newFramenumber != internalFramenumber)
    {
        internalFramenumber = newFramenumber;
        emit framenumberChanged(); // trigger signal of frame number change
    }}

// Test method, callable from QML
void InterchangeData::doSomething(const QString &text)
{
    // qDebug() << "InterchangeData:doSomething() called with" << text;
}

// Declare the one single instance of this object in the system
InterchangeData interchangeData;
