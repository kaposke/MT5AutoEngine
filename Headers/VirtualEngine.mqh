#include "VirtualOrder.mqh"
#include "Globals.mqh"
#include "PositionInfoUtils.mqh"
#include "ArrayUtils.mqh"

class VirtualEngine
{
private:
    VirtualOrder *orders[];

    MqlBookInfo priceArray[];

    int tickRange;

    int inSkip; // Ticks to skip from current price to start entry placing
    int inDistance;  // Distance between entries
    int outDistance; // Distance of exits from the entry

    bool enabled;

    void GetOrdersAtPrice(double price, VirtualOrder*& output[]);

    // void PlaceEntries();
    void ExecuteNeededOrders();

public:
    VirtualEngine();

    void OnTick();

    string GetInfoString();

    bool IsEnabled();
    void Enable();
    void Disable();
};

VirtualEngine::VirtualEngine()
{
    inDistance = 1;
    outDistance = 3;
}

void VirtualEngine::OnTick()
{
    if (!IsBuySide() IsSellSideSell())
        return;
    // PlaceEntries();
    // ExecuteNeededOrders();
}

// void VirtualEngine::PlaceEntries()
// {
//     if (IsBuySide())
//     {
//         for (int i = 0; i < tickRange; i++)
//         {
//             if ((i - inSkip) % inDistance != 0)
//                 continue;
//             double price = symbolInfo.Bid() - (i * symbolInfo.TickSize()); 
//             ArrayPush(orders, new VirtualOrder(1, price, ORDER_TYPE_BUY, "in")); // TODO: have a base volume
//         }
//     }
//     else if (IsSellSide())
//     {
//         for (int i = 0; i < tickRange; i++)
//         {
//             if ((i - inSkip) % inDistance != 0)
//                 continue;
//             double price = symbolInfo.Ask() + (i * symbolInfo.TickSize()); 
//             ArrayPush(orders, new VirtualOrder(1, price, ORDER_TYPE_SELL, "in")); // TODO: have a base volume
//         }
//     }
// }

void VirtualEngine::ExecuteNeededOrders()
{
    double price = IsBuySide() ? symbolInfo.Ask() : symbolInfo.Bid();

    VirtualOrder* ordersAtPrice[];
    GetOrdersAtPrice(price, ordersAtPrice);
    int ordersCount = ArraySize(ordersAtPrice);
    if (ordersCount == 0)
        return;

    for (int i = 0; i < ordersCount; i++)
    {
        VirtualOrder* order = ordersAtPrice[i];
        if (order.GetType() == ORDER_TYPE_BUY)
            trade.Buy(order.GetVolume(), _Symbol, price, order.GetComment());
        else
            trade.Sell(order.GetVolume(), _Symbol, price, order.GetComment());
    }
}

string VirtualEngine::GetInfoString()
{
    string output = "";

    int pricesToShow = 10;
    for (int i = 0; i < pricesToShow * 2; i++)
    {
        if (i == pricesToShow)
            output += "========\n";

        double price = symbolInfo.Bid() + (pricesToShow - i) * symbolInfo.TickSize();

        VirtualOrder* ordersAtPrice[];
        GetOrdersAtPrice(price, ordersAtPrice);

        // Create order string
        int orderCount = ArraySize(ordersAtPrice);
        string ordersString = "";
        for (int j = 0; j < orderCount; j++)
        {
            VirtualOrder* order = ordersAtPrice[j];
            ordersString += StringFormat("%s[%d]%s", order.GetComment(), order.GetVolume(), j == orderCount - 1 ? "" : ", ");
        }
        
        output += StringFormat("%.2f | %s\n", price, ordersString);
    }
    return output;
}

bool VirtualEngine::IsEnabled()
{
    return enabled;
}

void VirtualEngine::Enable()
{
    enabled = true;
}
void VirtualEngine::Disable()
{
    enabled = false;
}

void VirtualEngine::GetOrdersAtPrice(double price, VirtualOrder*& output[])
{
    for (int i = 0; i < ArraySize(orders); i++)
    {
        VirtualOrder* order = orders[i];
        if (order.GetPrice() == price)
            ArrayPush(output, order);
    }
}