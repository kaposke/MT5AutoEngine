#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>
#include "PositionInfo.mqh"
#include "Logger.mqh"

CTrade trade;
CSymbolInfo symbolInfo;
PositionInfo positionInfo;

// class VirtualEngine;
// VirtualEngine* virtualEngine;

class ComponentSystem;
ComponentSystem* componentSystem;

class MovementSizeComponent;
MovementSizeComponent* movementSizeComponent;

class ExtremityTraderComponent;
ExtremityTraderComponent* extremityTraderComponent;

class MarketTrendComponent;
MarketTrendComponent* marketTrendComponent;