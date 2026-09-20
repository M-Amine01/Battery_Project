#pragma once
#include <QObject>


class Battery : public QObject{
    Q_OBJECT
    Q_PROPERTY(int level READ get_Level_Value WRITE set_New_Level NOTIFY level_Value_Changed )

private:
    int level = 100;

public:
    explicit Battery(QObject *parent = nullptr);

    Q_INVOKABLE void increase_Battry_Level(int x);
    Q_INVOKABLE void decrease_Battry_Level(int x);

    int get_Level_Value() const;
    void set_New_Level(int newLevel);
signals:
    void level_Value_Changed();
};
