
template<typename T>
void ArrayPush(T& list[], T item)
{
    int size = ArraySize(list);
    ArrayResize(list, size + 1);
    list[size] = item;
}

template<typename T>
void ArrayDeleteAll(T& list[])
{
    for (int i = 0; i < ArraySize(list); i++)
    {
        delete list[i];
    }
    ArrayFree(list);
}