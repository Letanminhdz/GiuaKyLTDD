using GiuaKi.Debugging;

namespace GiuaKi;

public class GiuaKiConsts
{
    public const string LocalizationSourceName = "GiuaKi";

    public const string ConnectionStringName = "Default";

    public const bool MultiTenancyEnabled = true;


    /// <summary>
    /// Default pass phrase for SimpleStringCipher decrypt/encrypt operations
    /// </summary>
    public static readonly string DefaultPassPhrase =
        DebugHelper.IsDebug ? "gsKxGZ012HLL3MI5" : "3780cf5ce9b94613baf8ca3e1aefa09a";
}
