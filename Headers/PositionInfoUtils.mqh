#include "Globals.mqh"

bool IsBuy()
{
    return positionInfo.PositionType() == POSITION_TYPE_BUY;
}

bool IsSell()
{
    return positionInfo.PositionType() == POSITION_TYPE_SELL;
}