#include "../../Globals.mqh"
#include "../SystemComponent.mqh"
#include "../../SumTracker.mqh"
#include "../../ChartObjects.mqh"
#include "../../Trader.mqh"

class MarketTrendComponent : public SystemComponent
{
private:
    SumTracker *sumTracker;
    double lastPrice;

    int historySize;

    int minimumOppositeTrendToInvert;

public:
    MarketTrendComponent();
    ~MarketTrendComponent();

    void OnTick();
    string GetInfo() const;
};

MarketTrendComponent::MarketTrendComponent()
{
    historySize = 500;
    sumTracker = new SumTracker(historySize);
    lastPrice = 0.0;

    minimumOppositeTrendToInvert = 8;
}

MarketTrendComponent::~MarketTrendComponent()
{
    delete sumTracker;
}

void MarketTrendComponent::OnTick()
{
    double price = symbolInfo.Last();

    if (lastPrice != 0)
    {
        int direction = (price - lastPrice) / symbolInfo.TickSize();
        sumTracker.Add(direction);
    }

    // Has saved full history size
    if (sumTracker.GetValueCount() == historySize)
    {
        if (!positionInfo.HasSide() && sumTracker.GetSum() >= minimumOppositeTrendToInvert)
            Trade.BuyMarket(1);

        if (!positionInfo.HasSide() && sumTracker.GetSum() <= -minimumOppositeTrendToInvert)
            Trade.SellMarket(1);

        if ((positionInfo.IsBuySide() && sumTracker.GetSum() < minimumOppositeTrendToInvert) ||
            (positionInfo.IsSellSide() && sumTracker.GetSum() > -minimumOppositeTrendToInvert))
        {
            if (positionInfo.AverageProfit() > 2)
            {
                Trade.ClosePosition();
            }
        }

        if ((positionInfo.IsBuySide() && sumTracker.GetSum() <= -minimumOppositeTrendToInvert) ||
            (positionInfo.IsSellSide() && sumTracker.GetSum() >= minimumOppositeTrendToInvert))
        {
            Trade.InvertAll();
        }
    }

    lastPrice = price;
}

string MarketTrendComponent::GetInfo() const
{
    string output = "";

    output += StringFormat("History Size: %d\n", sumTracker.GetValueCount());
    output += StringFormat("Trend: %d\n", sumTracker.GetSum());
    output += StringFormat("Profit: %.2f\n", positionInfo.Profit());
    output += StringFormat("Averge Profit: %.2f", positionInfo.AverageProfit());

    return output;
}