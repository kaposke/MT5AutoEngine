#include "../../Globals.mqh"
#include "../SystemComponent.mqh"
#include "../../ValuePool.mqh"
#include "../../ChartObjects.mqh"
#include "../../Trader.mqh"

class ExtremityTraderComponent : public SystemComponent
{
private:
    MovementSizeComponent *movementSizeComponent;

    double top, bot;
    double safetyTop, safetyBot;

    double safetyDistance;

    bool brokeUpwards;
    bool wasOutside;

public:
    ExtremityTraderComponent(MovementSizeComponent *movementSizeComponent);
    ~ExtremityTraderComponent();

    void OnTick();
    string GetInfo() const;
};

ExtremityTraderComponent::ExtremityTraderComponent(MovementSizeComponent *movementSizeComponent)
{
    this.movementSizeComponent = movementSizeComponent;

    top = 0.0;
    bot = 0.0;

    safetyTop = 0.0;
    safetyBot = 0.0;

    safetyDistance = 3.0;

    wasOutside = false;
}

ExtremityTraderComponent::~ExtremityTraderComponent()
{
}

void ExtremityTraderComponent::OnTick()
{
    if (!movementSizeComponent.HasDefinedExtremities())
        return;
        
    double price = symbolInfo.Last();

    top = movementSizeComponent.GetTop();
    bot = movementSizeComponent.GetBot();

    safetyTop = top + safetyDistance;
    safetyBot = bot - safetyDistance;

    // Invert on safety boundaries
    // if (price >= safetyTop && positionInfo.IsSellSide() ||
    //     price <= safetyBot && positionInfo.IsBuySide())
    // {
    //     Trade.InvertAll();
    // }

    // Check if we broke to some side
    if (price >= top)
    {
        brokeUpwards = true;
    }
    else if (price <= bot)
    {
        brokeUpwards = false;
    }

    // If we were outside and went back
    if (wasOutside && movementSizeComponent.IsPriceBetweenExtremities())
    {
        // Sell if broke upwards
        if (brokeUpwards)
        {
            if (!positionInfo.HasSide())
                Trade.SellMarket(1);
            else if (positionInfo.IsBuySide())
                Trade.InvertAll();
        }
        else // Buy if broke downwards
        {
            if (!positionInfo.HasSide())
                Trade.BuyMarket(1);
            else if (positionInfo.IsSellSide())
                Trade.InvertAll();
        }
    }

    wasOutside = movementSizeComponent.IsPriceBetweenExtremities();
}

string ExtremityTraderComponent::GetInfo() const
{
    string output = "";

    output += StringFormat("Top: %.2f\n", top);
    output += StringFormat("Bot: %.2f\n", bot);

    output += StringFormat("Side: %s\n", positionInfo.HasSide() ? (positionInfo.IsBuySide() ? "Buy" : "Sell") : "No Side");
    output += StringFormat("Volume: %.1f\n", positionInfo.Volume());
    output += StringFormat("Profit: %.2f\n", Trade.GetTotalTickProfit());

    return output;
}