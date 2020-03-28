
class VirtualOrder
{
private:
    int volume;
    double price;
    ENUM_ORDER_TYPE type;
    string comment;

public:
    VirtualOrder(int volume, double price, ENUM_ORDER_TYPE type, string comment = "");

    int GetVolume();
    double GetPrice();
    ENUM_ORDER_TYPE GetType();
    string GetComment();
};

VirtualOrder::VirtualOrder(int volume, double price, ENUM_ORDER_TYPE type,string comment)
    : volume(volume), price(price), type(type), comment(comment)
{}

int VirtualOrder::GetVolume()
{
    return volume;
}

double VirtualOrder::GetPrice()
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