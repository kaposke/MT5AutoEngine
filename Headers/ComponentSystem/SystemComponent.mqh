class SystemComponent
{
public:
    virtual void OnTick() = 0;
    
    virtual string GetInfo() const;
    virtual void DrawObjects() const {};
};

string SystemComponent::GetInfo() const
{
    return "Nothing usefull here";
}