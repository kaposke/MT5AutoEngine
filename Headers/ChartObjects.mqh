bool HLineCreate(const long chart_ID = 0,                   // chart's ID
                 const string name = "HLine",               // line name
                 const int sub_window = 0,                  // subwindow index
                 double price = 0,                          // line price
                 const color clr = clrRed,                  // line color
                 const ENUM_LINE_STYLE style = STYLE_SOLID, // line style
                 const int width = 1,                       // line width
                 const bool back = false,                   // in the background
                 const bool selection = true,               // highlight to move
                 const bool hidden = true,                  // hidden in the object list
                 const long z_order = 0)                    // priority for mouse click
{
    HLineDelete(0, name);

    //--- if the price is not set, set it at the current Bid price level
    if (!price)
        price = SymbolInfoDouble(Symbol(), SYMBOL_BID);

    //--- reset the error value
    ResetLastError();

    if (!ObjectCreate(chart_ID, name, OBJ_HLINE, sub_window, 0, price))
    {
        Print(__FUNCTION__, ": failed to create a horizontal line! Error code = ", GetLastError());
        return (false);
    }

    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
    ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);
    ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, width);
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);

    return (true);
}

bool HLineDelete(const long chart_ID = 0,     // chart's ID
                 const string name = "HLine") // line name
{
    ResetLastError();

    if (!ObjectDelete(chart_ID, name))
    {
        Print(__FUNCTION__,
              ": failed to delete a horizontal line! Error code = ", GetLastError());
        return (false);
    }
    return (true);
}

bool TextCreate(const long chart_ID = 0,                            // chart's ID
                const string name = "Text",                         // object name
                const int sub_window = 0,                           // subwindow index
                datetime time = 0,                                  // anchor point time
                double price = 0,                                   // anchor point price
                const string text = "Text",                         // the text itself
                const string font = "Arial",                        // font
                const int font_size = 10,                           // font size
                const color clr = clrRed,                           // color
                const double angle = 0.0,                           // text slope
                const ENUM_ANCHOR_POINT anchor = ANCHOR_LEFT_UPPER, // anchor type
                const bool back = false,                            // in the background
                const bool selection = false,                       // highlight to move
                const bool hidden = true,                           // hidden in the object list
                const long z_order = 0)                             // priority for mouse click
{
    TextDelete(chart_ID, name);

    ResetLastError();

    if (!ObjectCreate(chart_ID, name, OBJ_TEXT, sub_window, time, price))
    {
        Print(__FUNCTION__, ": failed to create \"Text\" object! Error code = ", GetLastError());
        return false;
    }

    ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
    ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
    ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
    ObjectSetDouble(chart_ID, name, OBJPROP_ANGLE, angle);
    ObjectSetInteger(chart_ID, name, OBJPROP_ANCHOR, anchor);
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);

    return true;
}

bool TextDelete(const long chart_ID = 0,    // chart's ID
                const string name = "Text") // object name
{
    ResetLastError();

    if (!ObjectDelete(chart_ID, name))
    {
        Print(__FUNCTION__, ": failed to delete \"Text\" object! Error code = ", GetLastError());
        return false;
    }
    return true;
}