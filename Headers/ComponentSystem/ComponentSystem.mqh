#include "SystemComponent.mqh"
#include "../ArrayUtils.mqh"

class ComponentSystem
{
private:
    SystemComponent* components[];

public:
    ComponentSystem();
    ~ComponentSystem();

    void AddComponent(SystemComponent* component);

    void OnTick();

    string GetInfo() const;

    void DrawObjects() const;
};

ComponentSystem::ComponentSystem()
{

}

ComponentSystem::~ComponentSystem()
{
    ArrayDeleteAll(components);
}

void ComponentSystem::AddComponent(SystemComponent* component)
{
    ArrayPush(components, component);
}

void ComponentSystem::OnTick()
{
    for (int i = 0; i < ArraySize(components); i++)
    {
        SystemComponent* component = components[i];
        component.OnTick();
    }
}

string ComponentSystem::GetInfo() const
{
    string output = "";
    for (int i = 0; i < ArraySize(components); i++)
    {
        output += components[i].GetInfo();
        output += "\n";
    }
    return output;
}

void ComponentSystem::DrawObjects() const
{
    for (int i = 0; i < ArraySize(components); i++)
    {
        components[i].DrawObjects();
    }
}