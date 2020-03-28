#include "Globals.mqh"

#define Trade Trader::Get()
;
class Trader
{
private:
    double totalTickProfit;

    Trader();

public:
    static Trader *Get();

    void BuyMarket(int volume, string comment = "Entry");
    void SellMarket(int volume, string comment = "Entry");
    void InvertTo(int volume, string comment = "Inversion");
    void InvertAll(string comment = "Inversion");
    void ClosePosition();

    double GetTotalTickProfit();
};

Trader::Trader()
{
    totalTickProfit = 0;
}

Trader *Trader::Get()
{
    static Trader *instance;
    if (instance == NULL)
        instance = new Trader();
    return instance;
}

void Trader::BuyMarket(int volume, string comment)
{
    if (!trade.Buy(volume, _Symbol, symbolInfo.Ask(), comment))
        Logger::LogError("Trader", StringFormat("Failed to buy. [Volume: %.1f | Symbol: %s | Price: %.2f | Comment: %s]",
                                                volume, _Symbol, symbolInfo.Ask(), comment));
    else
        Logger::LogTrade("Trader", StringFormat("Buy Market | Volume: %.2f | Price: %.2f | Comment: %s", volume, symbolInfo.Ask(), comment));

    positionInfo.Update();
}

void Trader::SellMarket(int volume, string comment)
{
    if (!trade.Sell(volume, _Symbol, symbolInfo.Bid(), comment))
        Logger::LogError("Trader", StringFormat("Failed to Sell. [Volume: %.1f | Symbol: %s | Price: %.2f | Comment: %s]",
                                                volume, _Symbol, symbolInfo.Bid(), comment));
    else
        Logger::LogTrade("Trader", StringFormat("Sell Market | Volume: %.2f | Price: %.2f | Comment: %s", volume, symbolInfo.Bid(), comment));

    positionInfo.Update();
}

void Trader::InvertTo(int volume, string comment)
{
    totalTickProfit += positionInfo.Profit() / 5.0;

    if (positionInfo.IsBuySide())
    {
        if (!trade.Sell(volume, _Symbol, symbolInfo.Bid(), comment))
            Logger::LogError("Trader", StringFormat("Failed to Sell. [Volume: %.1f | Symbol: %s | Price: %.2f | Comment: %s]",
                                                    volume, _Symbol, symbolInfo.Bid(), comment));
        else
            Logger::LogTrade("Trader", StringFormat("Invert To Sell | Volume: %.2f | Price: %.2f | Comment: %s", volume, symbolInfo.Bid(), comment));
    }
    else if (positionInfo.IsSellSide())
    {
        if (!trade.Buy(volume, _Symbol, symbolInfo.Ask(), comment))
            Logger::LogError("Trader", StringFormat("Failed to buy. [Volume: %.1f | Symbol: %s | Price: %.2f | Comment: %s]",
                                                    volume, _Symbol, symbolInfo.Ask(), comment));
        else
            Logger::LogTrade("Trader", StringFormat("Invert To Buy | Volume: %.2f | Price: %.2f | Comment: %s", volume, symbolInfo.Ask(), comment));
    }
    else
        Logger::LogWarning("Trader", "Tryed to invert but no side is taken.");


    positionInfo.Update();
}

void Trader::InvertAll(string comment)
{
    InvertTo(positionInfo.Volume(), comment);
}

void Trader::ClosePosition()
{
    if (positionInfo.IsBuySide())
        SellMarket(positionInfo.Volume());
    else if (positionInfo.IsSellSide())
        BuyMarket(positionInfo.Volume());

    positionInfo.Update();
}

double Trader::GetTotalTickProfit()
{
    return totalTickProfit;
}