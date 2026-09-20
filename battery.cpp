#include "battery.h"

Battery::Battery(QObject *parent){}


void Battery::increase_Battry_Level(int x){
    level += x;
    if (level >100){
        level = 100;
    }
    emit level_Value_Changed();
}


void Battery::decrease_Battry_Level(int x){
    level -= x;
    if (level < 0){
        level =0;
    }
    emit level_Value_Changed();
}


int Battery::get_Level_Value() const{
    return level;
}


void Battery::set_New_Level(int newLevel){
    if (newLevel == level){return;}

    level = newLevel;
    emit level_Value_Changed();
}
