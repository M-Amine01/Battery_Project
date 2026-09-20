#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include "battery.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;


    Battery myBattery;
    engine.rootContext()->setContextProperty("myBattery" , &myBattery);


    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Battery", "Main");

    return app.exec();
}
