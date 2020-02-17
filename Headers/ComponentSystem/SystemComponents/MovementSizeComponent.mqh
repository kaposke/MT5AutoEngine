#include "../../Globals.mqh"
#include "../SystemComponent.mqh"
#include "../../ValuePool.mqh"
#include "../../ChartObjects.mqh"

class MovementSizeComponent : public SystemComponent
{
private:
    ValuePool<double> *movementSizePool;

    int maxTickReturn;

    double currentTop;
    double currentBot;
    double lastTop;
    double lastBot;

    bool topSaved;
    bool botSaved;

    void RecordMovement();

public:
    MovementSizeComponent();
    ~MovementSizeComponent();

    void OnTick();
    string GetInfo() const;
    void DrawObjects() const;
};

MovementSizeComponent::MovementSizeComponent()
{
    movementSizePool = new ValuePool<double>(20);

    maxTickReturn = 3;

    currentTop = -DBL_MAX;
    currentBot = DBL_MAX;
    lastTop = 0;
    lastBot = 0;
    topSaved = false;
    botSaved = false;
}

MovementSizeComponent::~MovementSizeComponent()
{
    delete movementSizePool;
}

void MovementSizeComponent::OnTick()
{
    double price = symbolInfo.Last();

    if (price > currentTop)
        currentTop = price;
    if (price < currentBot)
        currentBot = price;

    if (price <= currentTop - maxTickReturn * symbolInfo.TickSize())
    {
        lastTop = currentTop;
        currentTop = price;
        topSaved = true;
        if (botSaved)
        {
            RecordMovement();
            botSaved = false;
        }
    }

    if (price >= currentBot + maxTickReturn * symbolInfo.TickSize())
    {
        lastBot = currentBot;
        currentBot = price;
        botSaved = true;
        if (topSaved)
        {
            RecordMovement();
            topSaved = false;
        }
    }
}

void MovementSizeComponent::RecordMovement()
{
    double size = lastTop - lastBot;
    movementSizePool += size;

    Logger::LogInfo(StringFormat("Recorded Movement. Top: %2.f | Bot: %.2f | Size: %.2f", lastTop, lastBot, size));
}

string MovementSizeComponent::GetInfo() const
{
    string output = "";
    
    // output += StringFormat("CurrentTop: %.2f\n", currentTop);
    // output += StringFormat("CurrentBot: %.2f\n", currentBot);
    output += StringFormat("LastTop: %.2f\n", lastTop);
    output += StringFormat("LastBot: %.2f\n", lastBot);
    // output += StringFormat("Size Average: %.4f);

    return output;
}

void MovementSizeComponent::DrawObjects() const
{
    HLineCreate(0, "LastTop", 0, lastTop, clrDarkGreen);
    HLineCreate(0, "LastBot", 0, lastBot, clrCrimson);
    // HLineCreate(0, "CurrentTop", 0, currentTop, clrDarkGreen);
    // HLineCreate(0, "CurrentBot", 0, currentBot, clrCrimson);
}