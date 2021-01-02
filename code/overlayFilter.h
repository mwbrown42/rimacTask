/*
 * Rimac Video Editor - An Interview Task for New Software Developers
 *
 * © Mike Brown, December 2020.
 * mwbrown42@gmail.com
 *
 * This header describes the C++ class that implements the video filter, applying the user's requested graphic overlays.
 */

#ifndef __OverlayFilter__
#define __OverlayFilter__

#include <QAbstractVideoFilter>
#include <QVideoFilterRunnable>

class OverlayFilter : public QAbstractVideoFilter
{
    Q_OBJECT

    Q_PROPERTY( int videoOutputOrientation MEMBER m_VideoOutputOrientation )

public:
    OverlayFilter( QObject* parent = nullptr );

    QVideoFilterRunnable* createFilterRunnable() Q_DECL_OVERRIDE;

    int m_VideoOutputOrientation;

};

class OverlayFilterRunnable : public QVideoFilterRunnable
{
public:
     OverlayFilterRunnable( OverlayFilter* filter );

    // This is the main worker that performs all of the video processing
    QVideoFrame run( QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat, RunFlags flags ) Q_DECL_OVERRIDE;

protected:
    OverlayFilter* m_Filter;

};

#endif
