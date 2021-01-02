/*
 * Rimac Video Editor - An Interview Task for New Software Developers
 *
 * © Mike Brown, December 2020.
 * mwbrown42@gmail.com
 *
 * This class implements the video filter, applying the user's requested graphic overlays.
 */

#include <QPainter>
#include <QQmlApplicationEngine>
#include <QQmlProperty>
#include <QQmlComponent>
#include <QDebug>
#include <QDir>
#include <QDateTime>
#include <QGuiApplication>
#include <QScreen>
#include <QVideoFilterRunnable>
#include <QQmlContext>
#include <QProcess>
#include <QString>
#include "overlayFilter.h"
#include "QVideoFrameToQImage.h"
#include "QImagePainter.h"
#include "InterchangeData.h"

// This gives me visibility to the single InterchangeData object
extern InterchangeData interchangeData;

// Retrieved values from the QML side
bool overlayFilterNumericalRandomValueEnabled = false;
int overlayFilterNumericalRandomValueX = 0;
int overlayFilterNumericalRandomValueY = 0;
bool overlayFilterShapeGradientEnabled = false;
QColor overlayFilterColorWhite = QColor("white");
QColor overlayFilterColorBlack = QColor("black");
int overlayFilterShapeGradientWidth = 400;
int overlayFilterShapeGradientHeight = 400;
bool overlayFilterSliderEnabled = false;
int overlayFilterSliderMin = 0;
int overlayFilterSliderMax = 0;
int overlayFilterSliderX = 0;
int overlayFilterSliderY = 0;
int overlayFilterSliderHeight = 50;
int overlayFilterSliderWidth = 800;
int overlayFilterFramerate = 0;

// Locally set as we process each frame
int overlayFilterFrameNumber = 0;

// Note: The interchangeData object is created in main.cpp and a pointer is stored in InterchangeData.h
// for use here.
OverlayFilter::OverlayFilter( QObject* parent ): QAbstractVideoFilter( parent )
{
}

QVideoFilterRunnable *OverlayFilter::createFilterRunnable()
{
    return new OverlayFilterRunnable(this);
}

// This is the constructor for the class doing all the heavy lifting for reading the image and applying the graphial effects
// It reads all of the static information before each video starts playing, improving performance over getting all data for every frame
OverlayFilterRunnable::OverlayFilterRunnable( OverlayFilter* filter ) : m_Filter( filter )
{
    // Numerical Value
    overlayFilterNumericalRandomValueEnabled = interchangeData.getNumericalRandomValueEnabled();
    overlayFilterNumericalRandomValueX = interchangeData.getNumericalRandomValueX();
    overlayFilterNumericalRandomValueY = interchangeData.getNumericalRandomValueY();

    /// Shape Gradient
    overlayFilterShapeGradientEnabled = interchangeData.getShapeGradientEnabled();

    // Slider
    overlayFilterSliderEnabled = interchangeData.getSliderEnabled();
    overlayFilterSliderMin = interchangeData.getSliderMin();
    overlayFilterSliderMax = interchangeData.getSliderMax();
    overlayFilterSliderX = interchangeData.getSliderX();
    overlayFilterSliderY = interchangeData.getSliderY();

    // Video processing
    overlayFilterFramerate = interchangeData.getFramerate();
}

/*
 *  This is called for every frame of the video.
 * - Read the dynamic values associated with the graphic overlays
 * - Paint the overlays onto the frame
 * - Return the frame to the multimedia system
 * - Send the frame number back to QML to update the progress bar
 *
 * TODO: Implement full video saving functionality
 * The section of code below will save each edited frame to an external file in sequence
 * This could be used to construct a new edited video
*/
QVideoFrame OverlayFilterRunnable::run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat, RunFlags flags)
{
    int  overlayFilterNumericalRandomNumber = 42;
    QColor overlayFilterShapeGradientRandomColor1 = overlayFilterColorWhite;
    QColor overlayFilterShapeGradientRandomColor2 = overlayFilterColorBlack;
    int  overlayFilterShapeGradientRandomValueX1 = 0;
    int  overlayFilterShapeGradientRandomValueY1 = 0;
    int  overlayFilterShapeGradientRandomValueX2 = 0;
    int  overlayFilterShapeGradientRandomValueY2 = 0;
    int  overlayFilterSliderValue = 0;

    // Filename pattern for each frame image
    QString filenameTemplate = "rimac######.png";

    Q_UNUSED( flags )

    // Ignore this frame if it doesn't exist
    if ( !input )
    {
        return QVideoFrame();
    }

    // Initialize the video processing
    int videoOutputOrientation = m_Filter->m_VideoOutputOrientation;
    QImage image = QVideoFrameToQImage( *input );
    int w = ( videoOutputOrientation == 0 || videoOutputOrientation == 180 ) ? image.width() : image.height();
    int h = ( videoOutputOrientation == 0 || videoOutputOrientation == 180 ) ? image.height() : image.width();
    QImagePainter painter( &image, input, surfaceFormat, videoOutputOrientation );

    // Read the current dynamic values from the UML side and perform each overlay as requested by the user

    // Numerical value
    if( overlayFilterNumericalRandomValueEnabled )
    {
        overlayFilterNumericalRandomNumber = interchangeData.getNumericalRandomValue();

        // Process numerical value here
        painter.setFont( QFont("Verdana", 72 ) );
        painter.setPen( Qt::white );

        painter.drawText( QRect( overlayFilterNumericalRandomValueX, overlayFilterNumericalRandomValueY, 128, 128 ), Qt::AlignCenter, QString::number( overlayFilterNumericalRandomNumber ) );
    }

    // Shape Gradient
    if ( overlayFilterShapeGradientEnabled )
    {
        overlayFilterShapeGradientRandomColor1 = interchangeData.getShapeGradientRandomColor1();
        overlayFilterShapeGradientRandomColor2 = interchangeData.getShapeGradientRandomColor2();
        overlayFilterShapeGradientRandomValueX1 = interchangeData.getShapeGradientRandomValueX();
        overlayFilterShapeGradientRandomValueY1 = interchangeData.getShapeGradientRandomValueY();

        int gradientWindowSize = 200;
        overlayFilterShapeGradientRandomValueX2 = overlayFilterShapeGradientRandomValueX1 + gradientWindowSize;
        overlayFilterShapeGradientRandomValueY2 = overlayFilterShapeGradientRandomValueY1 + gradientWindowSize;

        QLinearGradient linearGrad(QPointF(overlayFilterShapeGradientRandomValueX1, overlayFilterShapeGradientRandomValueY1),
                                   QPointF(overlayFilterShapeGradientRandomValueX2, overlayFilterShapeGradientRandomValueY2));
        linearGrad.setColorAt(0, overlayFilterShapeGradientRandomColor1);
        linearGrad.setColorAt(1, overlayFilterShapeGradientRandomColor2);
        QRect rect_linear(overlayFilterShapeGradientRandomValueX1, overlayFilterShapeGradientRandomValueY1,
                          gradientWindowSize, gradientWindowSize);
        painter.fillRect(rect_linear, linearGrad);
    }

    // Slider
    if( overlayFilterSliderEnabled )
    {
        overlayFilterSliderValue = interchangeData.getSliderValue();

        // Draw the bounding box
        int boundingBoxWidth = 3;
        QPen outlinePen;
        outlinePen.setColor(Qt::blue);
        outlinePen.setWidth(boundingBoxWidth);
        painter.setPen(outlinePen);
        painter.drawRect(overlayFilterSliderX, overlayFilterSliderY, overlayFilterSliderWidth, overlayFilterSliderHeight );

        // Fill the background
        painter.fillRect(overlayFilterSliderX+boundingBoxWidth, overlayFilterSliderY+boundingBoxWidth,
                         overlayFilterSliderWidth-(2*boundingBoxWidth) + 1, overlayFilterSliderHeight-(2*boundingBoxWidth) + 1, Qt::white );



        // Now overlay the min and max numbers on the bar
        int minMaxTextWidth = 40;
        painter.setFont( QFont("Verdana", 24 ) );
        painter.setPen( Qt::blue );
        painter.drawText( QRect( overlayFilterSliderX + boundingBoxWidth, overlayFilterSliderY + boundingBoxWidth,
                                 minMaxTextWidth, overlayFilterSliderHeight - (2 * boundingBoxWidth) ), Qt::AlignCenter, QString::number( overlayFilterSliderMin ) );
        painter.drawText( QRect( overlayFilterSliderWidth - (2 * boundingBoxWidth) - (minMaxTextWidth / 2), overlayFilterSliderY + boundingBoxWidth,
                                 minMaxTextWidth, overlayFilterSliderHeight - (2 * boundingBoxWidth) ), Qt::AlignCenter, QString::number( overlayFilterSliderMax ) );

        // Draw the Completed and Incompleted Bars
        int startAndEndBarPadding = 48;
        float percentComplete = (float)((float)overlayFilterSliderValue / (float)overlayFilterSliderMax);
        int barWidth = overlayFilterSliderWidth - (2 *  + boundingBoxWidth) - (2 * startAndEndBarPadding);
        int completedWidth =  barWidth * percentComplete;
        int incompletedWidth = barWidth - completedWidth;

        painter.fillRect( overlayFilterSliderX + boundingBoxWidth + startAndEndBarPadding, overlayFilterSliderY + (2 * boundingBoxWidth),
                          completedWidth, overlayFilterSliderHeight - (4 * boundingBoxWidth), Qt::blue);
        painter.fillRect( overlayFilterSliderX + boundingBoxWidth + startAndEndBarPadding + completedWidth, overlayFilterSliderY + (2 * boundingBoxWidth),
                          incompletedWidth, overlayFilterSliderHeight - (4 * boundingBoxWidth), Qt::cyan);

        // Now overlay the current value on the joint of the two bars
        if (( overlayFilterSliderValue != overlayFilterSliderMin ) && ( overlayFilterSliderValue != overlayFilterSliderMax ))
        {
            painter.setPen( Qt::white );
            painter.drawText( QRect(overlayFilterSliderX + boundingBoxWidth + startAndEndBarPadding + completedWidth - (minMaxTextWidth / 2),
                                    overlayFilterSliderY + (2 * boundingBoxWidth),
                                    minMaxTextWidth,
                                    overlayFilterSliderHeight - (4 * boundingBoxWidth)),
                              Qt::AlignCenter, QString::number( overlayFilterSliderValue ) );
        }
    }

    // Frame processing is complete.  Update the current frame number and fire it across to the QML side
    overlayFilterFrameNumber++;
    interchangeData.setFramenumber(overlayFilterFrameNumber);

    // We're done with the graphical overlays, give the frame back to the system
    return image;
}
