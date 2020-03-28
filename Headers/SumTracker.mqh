#include "ValuePool.mqh"

class SumTracker
{
private:
    ValuePool<int> *valuePool;
    int sum;

public:
    SumTracker(int poolSize);
    ~SumTracker();

    void Add(int value);

    int GetSum() const;
    int GetValueCount() const;
};

SumTracker::SumTracker(int poolSize)
{
    valuePool = new ValuePool<int>(poolSize);
    sum = 0;
}

SumTracker::~SumTracker()
{
    delete valuePool;
}

void SumTracker::Add(int value)
{
    sum += value;

    if (valuePool.GetCurrentSize() == valuePool.GetPoolSize())
        sum -= valuePool[-1]; // Last

    valuePool += value;
}

int SumTracker::GetSum() const
{
    return sum;
}

int SumTracker::GetValueCount() const
{
    return valuePool.GetCurrentSize();
}