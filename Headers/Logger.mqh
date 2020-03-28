
class Logger
{
public:
    static void LogInfo(string message);
    static void LogInfo(string sender, string message);
    static void LogWarning(string message);
    static void LogWarning(string sender, string message);
    static void LogError(string message);
    static void LogError(string sender, string message);
    static void LogTrade(string message);
    static void LogTrade(string sender, string message);
};

void Logger::LogInfo(string message)
{
    PrintFormat("[Info]: %s", message);
}

void Logger::LogInfo(string sender, string message)
{
    PrintFormat("[Info] %s: %s", sender, message);
}

void Logger::LogWarning(string message)
{
    PrintFormat("[Warning]: %s", message);
}

void Logger::LogWarning(string sender, string message)
{
    PrintFormat("[Warning] %s: %s", sender, message);
}

void Logger::LogError(string message)
{
    PrintFormat("[Error]: %s", message);
}

void Logger::LogError(string sender, string message)
{
    PrintFormat("[Error] %s: %s", sender, message);
}

static void Logger::LogTrade(string message)
{
    PrintFormat("[Trade]: %s", message);
}

static void Logger::LogTrade(string sender, string message)
{
    PrintFormat("[Trade] %s: %s", sender, message);
}