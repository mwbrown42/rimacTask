/*
 * Rimac Video Editor - An Interview Task for New Software Developers
 *
 * © Mike Brown, December 2020.
 * mwbrown42@gmail.com
 *
 * This header file defines the aspects of data interchange between the QML side of the app and the C++ side of the app.
 */

#ifndef INTERCHANGEDATA_H
#define INTERCHANGEDATA_H

#include <QObject>
#include <QColor>

class InterchangeData : public QObject
{
    Q_OBJECT

    // this makes frameNumber available as a QML property
    Q_PROPERTY(int framenumber READ framenumber WRITE setFramenumber NOTIFY framenumberChanged)


public:
    InterchangeData();

// Signal sends the current frame number back to the QML side to onFrameNumberChanged()
signals:
    // void frameNumberChanged( int );
    void framenumberChanged( );


// Slots are public methods available in QML
// Every variable gets a getter and setter
public slots:
    bool getNumericalRandomValueEnabled();
    void setNumericalRandomValueEnabled(bool);
    int getNumericalRandomValue();
    void setNumericalRandomValue(int);
    int getNumericalRandomValueX();
    void setNumericalRandomValueX(int);
    int getNumericalRandomValueY();
    void setNumericalRandomValueY(int);

    bool getShapeGradientEnabled();
    void setShapeGradientEnabled(bool);
    QColor getShapeGradientRandomColor1();
    void setShapeGradientRandomColor1(QColor);
    QColor getShapeGradientRandomColor2();
    void setShapeGradientRandomColor2(QColor);
    int getShapeGradientRandomValueX();
    void setShapeGradientRandomValueX(int);
    int getShapeGradientRandomValueY();
    void setShapeGradientRandomValueY(int);

    bool getSliderEnabled();
    void setSliderEnabled(bool);
    int getSliderValue();
    void setSliderValue(int);
    int getSliderMin();
    void setSliderMin(int);
    int getSliderMax();
    void setSliderMax(int);
    int getSliderX();
    void setSliderX(int);
    int getSliderY();
    void setSliderY(int);

    int getFramerate();
    void setFramerate(int);

    int framenumber() const;
    void setFramenumber( int );

    // Test method
    void doSomething(const QString &text);
};

#endif // INTERCHANGEDATA_H
