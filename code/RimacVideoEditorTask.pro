QT += qml quick multimedia

CONFIG += c++11

QML_IMPORT_NAME = InterchangeData
QML_IMPORT_MAJOR_VERSION = 1

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        InterchangeData.cpp \
        QImagePainter.cpp \
        QVideoFrameToQImage.cpp \
        VideoFrame.cpp \
        main.cpp \
        overlayFilter.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    InterchangeData.h \
    QImagePainter.h \
    QVideoFrameToQImage.h \
    VideoFrame.h \
    overlayFilter.h


