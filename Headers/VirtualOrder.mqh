
class VirtualOrder
{
private:
    int volume;
    float price;
    ENUM_ORDER_TYPE type;
    string comment;

public:
    VirtualOrder(int volume, float price, ENUM_ORDER_TYPE type, string comment = "");

    int GetVolume();
    float GetPrice();
    ENUM_ORDER_TYPE GetType();
    string GetComment();
};

VirtualOrder::VirtualOrder(int volume, float price, ENUM_ORDER_TYPE type,string comment)
    : volume(volume), price(price), type(type), comment(comment)
{}

int VirtualOrder::GetVolume()
{
    return volume;
}

float VirtualOrder::GetPrice()
{
    return price;
}

ENUM_ORDER_TYPE VirtualOrder::GetType()
{
    return type;
}

string VirtualOrder::GetComment()
{
    return comment;
}