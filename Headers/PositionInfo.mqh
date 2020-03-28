class PositionInfo
{
private:
    int volume;
    double profit;
    double averageProfit;

public:
    void Update();

    int Volume();
    double Profit();
    double AverageProfit();
    
    bool IsBuySide();
    bool IsSellSide();
    bool HasSide();
};

void PositionInfo::Update()
{
    volume = 0;
    profit = 0;
    averageProfit = 0;

    PositionSelect(_Symbol);
    for (int i = 0; i < PositionsTotal(); i++)
    {
        PositionGetSymbol(i);

        ENUM_POSITION_TYPE type = PositionGetInteger(POSITION_TYPE);
        if (type == POSITION_TYPE_BUY)
            volume += PositionGetDouble(POSITION_VOLUME);
        else if (type == POSITION_TYPE_SELL)
            volume -= PositionGetDouble(POSITION_VOLUME);
        
        profit += PositionGetDouble(POSITION_PROFIT);
    }

    if (volume != 0)
        averageProfit = profit / fabs(volume);
}

int PositionInfo::Volume()
{
    return fabs(volume);
}

double PositionInfo::Profit()
{
    return profit;
}

double PositionInfo::AverageProfit()
{
    return averageProfit;
}

bool PositionInfo::IsBuySide()
{
    return volume > 0;
}

bool PositionInfo::IsSellSide()
{
    return volume < 0;
}

bool PositionInfo::HasSide()
{
    return volume != 0;
}