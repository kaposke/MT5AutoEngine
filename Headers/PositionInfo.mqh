// #include "Globals.mqh"

// class PositionInfo
// {
// private:
//     double openVolume;
//     double openProfit;
//     double averageOpenProfit;

//     // double closedVolume;
//     // double totalClosedProfit;
//     // double averageClosedProfit;

//     // double totalVolume;
//     // double totalAverageProfit;
//     // double totalProfit;

//     datetime tradeStartTime;

// public:
//     PositionInfo();

//     void update();

//     double GetOpenVolume();
//     double GetOpenProfit();
//     double GetAverageOpenProfit();
// };

// PositionInfo::PositionInfo()
// {
//     openVolume = 0.0;
//     openProfit = 0.0;
//     averageOpenProfit = 0.0;

//     // closedVolume = 0.0;
//     // totalClosedProfit = 0.0;
//     // averageClosedProfit = 0.0;

//     // totalVolume = 0.0;
//     // totalAverageProfit = 0.0;
//     // totalProfit = 0.0;
// }

// void PositionInfo::update()
// {
//     openVolume = positionInfo.Volume();
//     openProfit = positionInfo.Profit();
//     averageOpenProfit = openProfit / openVolume;
// }

// double PositionInfo::GetOpenVolume()
// {
//     return openVolume;
// }

// double PositionInfo::GetOpenProfit()
// {
//     return openProfit;
// }

// double PositionInfo::GetAverageOpenProfit()
// {
//     return averageOpenProfit;
// }