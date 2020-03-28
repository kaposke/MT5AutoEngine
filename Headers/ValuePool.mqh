template <typename T>
class ValuePool
{
private:
    T values[];
    int poolSize;
    int currentIndex;

public:
    ValuePool(int size);

    void AddValue(T value);

    T Get(int nBehind);

    T operator[](const int index);
    void operator+=(T &value);

    T GetAverage(int last = 0);

    int GetPoolSize() const;
    int GetCurrentSize() const;
};

template <typename T>
ValuePool::ValuePool(int size)
{
    this.poolSize = size;
    this.currentIndex = 0;

    ArrayResize(values, 0, poolSize);
}

template <typename T>
void ValuePool::AddValue(T value)
{
    int size = ArraySize(values);
    if (size < poolSize)
        ArrayPush(values, value);
    else
        values[currentIndex] = value;

    currentIndex = (currentIndex + 1) % poolSize;
}

template <typename T>
T ValuePool::Get(int nBehind)
{
    int correctIndex = currentIndex - nBehind - 1;
    if (correctIndex < 0)
        correctIndex += poolSize;

    correctIndex %= poolSize;

    return values[correctIndex];
}

template <typename T>
T ValuePool::operator[](const int index)
{
    return Get(index);
}

template <typename T>
void ValuePool::operator+=(T &value)
{
    AddValue(value);
}

template <typename T>
T ValuePool::GetAverage(int last = 0)
{
    int size = GetCurrentSize();
    if (size == 0)
        return 0;
    T total;
    for (int i = 0; i < size; i++)
    {
        total += Get(i);
    }
    return total / size;
}

template <typename T>
int ValuePool::GetPoolSize() const
{
    return poolSize;
}

template <typename T>
int ValuePool::GetCurrentSize() const
{
    return ArraySize(values);
}