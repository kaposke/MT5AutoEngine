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
#include "Headers/ComponentSystem/Components.mqh"
#include "Headers/ComponentSystem/SystemComponents/MovementSizeComponent.mqh"
#include "Headers/ComponentSystem/SystemComponents/MarketTrendComponent.mqh"
#include "Headers/ValuePool.mqh"
#include "Headers/Trader.mqh"

int OnInit()
{
    symbolInfo.Name(_Symbol);

    // movementSizeComponent = new MovementSizeComponent();
    // extremityTraderComponent = new ExtremityTraderColomponent(movementSizeComponent);
    marketTrendComponent = new MarketTrendComponent();

    componentSystem = new ComponentSystem();
    // componentSystem.AddComponent(movementSizeComponent);
    // componentSystem.AddComponent(extremityTraderComponent);
    componentSystem.AddComponent(marketTrendComponent);

    return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
    Trade.ClosePosition();
    PrintFormat("Total profit in ticks: %.2f", Trade.GetTotalTickProfit());
    delete componentSystem;
    delete Trade;
}

void OnTick()
{
    symbolInfo.Refresh();
    symbolInfo.RefreshRates();

    positionInfo.Update();

    componentSystem.OnTick();

    Comment(componentSystem.GetInfo());
    componentSystem.DrawObjects();
}

void OnBookEvent(const string &symbol) 
{
    MqlBookInfo priceArray[];
    MarketBookGet(symbol, priceArray);
} 
