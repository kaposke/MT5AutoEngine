//+------------------------------------------------------------------+
//|                                                   AutoEngine.mq5 |
//|                                  Copyright 2019, Guilherme Bassa |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Guilherme Bassa"
#property link "https://www.mql5.com"
#property version "1.00"

#include "Headers/Globals.mqh"
#include "Headers/ComponentSystem/ComponentSystem.mqh"
#include "Headers/ComponentSystem/SystemComponents/MovementSizeComponent.mqh"
#include "Headers/ValuePool.mqh"

int OnInit()
{
    symbolInfo.Name(_Symbol);
    positionInfo.Select(_Symbol);

    componentSystem = new ComponentSystem();

    componentSystem.AddComponent(new MovementSizeComponent());

    return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
    trade.PositionClose(_Symbol);
    delete componentSystem;
}

void OnTick()
{
    symbolInfo.Refresh();
    symbolInfo.RefreshRates();

    componentSystem.OnTick();

    Comment(componentSystem.GetInfo());
    componentSystem.DrawObjects();
}

void OnBookEvent(const string &symbol) 
{
    MqlBookInfo priceArray[];
    MarketBookGet(symbol, priceArray);
} 
