/*
 * Rimac Video Editor - An Interview Task for New Software Developers
 *
 * © Mike Brown, December 2020.
 * mwbrown42@gmail.com
 *
 * This class implements the intialization point of the application.
 * Most of it is boilerplate, but it does set the InterchangeData object into the context so it
 * can be accessed by the C++ side and the QML side.
 */

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "overlayFilter.h"
#include "InterchangeData.h"

// The single InterchangeData object is created here once and shared across the app
extern InterchangeData interchangeData;

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    app.setOrganizationName("Rimac Automobili");
    app.setOrganizationDomain("https://www.rimac-automobili.com/");
    app.setApplicationName("Rimac Video Editor");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    // Add for QML <-> C++ data exchange
    QQmlContext * context = engine.rootContext();

    // The object will be available in QML with name "interchangeData"
    context->setContextProperty("interchangeData",&interchangeData);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl)
    {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    // Filter to implement Rimac video overlay functionality
    qmlRegisterType<OverlayFilter>("MikeOverlayFilter", 1, 0, "OverlayFilter");

    // Data sharing object between C++ and QML
    qmlRegisterType<InterchangeData>("InterchangeData", 1, 0, "InterchangeData");

    return app.exec();
}
