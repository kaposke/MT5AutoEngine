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

    double top;
    double bot;

    bool savedFirstTime;

    void RecordMovement();

public:
    MovementSizeComponent();
    ~MovementSizeComponent();

    void OnTick();
    string GetInfo() const;
    void DrawObjects() const;

    double GetTop() const;
    double GetBot() const;

    bool HasDefinedExtremities();
    bool IsPriceBetweenExtremities();
};

MovementSizeComponent::MovementSizeComponent()
{
    movementSizePool = new ValuePool<double>(20);

    maxTickReturn = 5;

    currentTop = -DBL_MAX;
    currentBot = DBL_MAX;
    lastTop = 0;
    lastBot = 0;
    topSaved = false;
    botSaved = false;
    savedFirstTime = false;

    top = 0;
    bot = 0;
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

    if (price <= currentTop - maxTickReturn * symbolInfo.TickSize() && (!topSaved || !savedFirstTime))
    {
        savedFirstTime = true;
        lastTop = currentTop;
        currentTop = -DBL_MAX;
        topSaved = true;
        // Logger::LogInfo(StringFormat("Creating Top at %.2f", lastTop));
        if (botSaved)
        {
            botSaved = false;
            RecordMovement();
        }
    }

    if (price >= currentBot + maxTickReturn * symbolInfo.TickSize() && (!botSaved || !savedFirstTime))
    {
        savedFirstTime = true;
        lastBot = currentBot;
        currentBot = DBL_MAX;
        botSaved = true;
        // Logger::LogInfo(StringFormat("Creating Bot at %.2f", lastBot));
        if (topSaved)
        {
            topSaved = false;
            RecordMovement();
        }
    }
}

void MovementSizeComponent::RecordMovement()
{
    double size = lastTop - lastBot;
    movementSizePool.AddValue(size);
    
    double average = movementSizePool.GetAverage();

    // Logger::LogInfo(StringFormat("Recorded Movement. Top: %2.f | Bot: %.2f | Size: %.2f", lastTop, lastBot, size));
    // Logger::LogInfo(StringFormat("LastTop: %.2f | LastBot: %.2f", lastTop, lastBot));
    Logger::LogInfo(StringFormat("New Average: %.2f", movementSizePool.GetAverage()));
    
    if (topSaved)
    {
        top = lastTop;
        bot = top - movementSizePool.GetAverage();
    }
    else if (botSaved)
    {
        bot = lastBot;
        top = bot + movementSizePool.GetAverage();
    }
}

string MovementSizeComponent::GetInfo() const
{
    string output = "";

    output += StringFormat("Top: %.2f\n", top);
    output += StringFormat("Bot: %.2f\n", bot);
    output += StringFormat("Movements: %d\n", movementSizePool.GetCurrentSize());
    output += StringFormat("Average: %.2f\n", movementSizePool.GetAverage());

    return output;
}

void MovementSizeComponent::DrawObjects() const
{
    // TextCreate(0, "LastTop", 0, TimeCurrent(), lastTop, "- LastTop -", "Arial", 8, clrDarkOliveGreen, 0.0, ANCHOR_RIGHT);
    // TextCreate(0, "LastBot", 0, TimeCurrent(), lastBot, "- LastBot -", "Arial", 8, clrFireBrick, 0.0, ANCHOR_RIGHT);

    TextCreate(0, "Top", 0, TimeCurrent(), top, "- Top -", "Arial", 10, clrDarkOliveGreen, 0.0, ANCHOR_LEFT);
    TextCreate(0, "Bot", 0, TimeCurrent(), bot, "- Bot -", "Arial", 10, clrFireBrick, 0.0, ANCHOR_LEFT);
}

double MovementSizeComponent::GetTop() const
{
    return top;
}

double MovementSizeComponent::GetBot() const
{
    return bot;
}

bool MovementSizeComponent::HasDefinedExtremities()
{
    return movementSizePool.GetCurrentSize() > 1;
}


bool MovementSizeComponent::IsPriceBetweenExtremities()
{
    double price = symbolInfo.Last();
    return price < top && price > bot;
}