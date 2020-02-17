#include "Globals.mqh"
#include "PositionInfoUtils.mqh"

#define Trade Trader::Get()

class Trader
{
public:
    static Trader& Get();
    
    void BuyMarket(int volume, string comment = "Entry");
    void SellMarket(int volume, string comment = "Entry");
    void InvertTo(int volume);
    void InvertAll();
    void ClosePosition();
};

Trader& Get()
{
    static Trader instance;
    return &instance;
}

void Trader::BuyMarket(int volume)
{
    if (!trade.Buy(volume, _Symbol, symbolInfo.Ask(), comment))
        LogError("Logger", "Failed to buy. [Volume: %.1f | Symbol: %s | Price: %.2 | Comment: %s]",
                 volume, _Symbol, symbolInfo.Ask(), comment);
}

void Trader::SellMarket(int volume)
{
    if (!trade.Sell(volume, _Symbol, symbolInfo.Bid(), comment))
        LogError("Logger", "Failed to Sell. [Volume: %.1f | Symbol: %s | Price: %.2 | Comment: %s]",
                 volume, _Symbol, symbolInfo.Bid(), comment);
}

void Trader::InvertTo(int volume)
{
    if (IsBuy())
        Sell(positionInfo.Volume + volume);
    else if (IsSell())
        Buy(positionInfo.Volume + volume);
    else
        LogWarning("Logger", "Tryed to invert but no side is taken.");    
}

void Trader::InvertAll()
{
    invertTo(positionInfo.Volume);
}

void Trader::ClosePosition()
{
    if (IsBuy())
        Sell(positionInfo.Volume);
    else if (IsSell())
        Buy(positionInfo.Volume);
}