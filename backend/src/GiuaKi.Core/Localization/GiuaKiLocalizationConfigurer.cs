using Abp.Configuration.Startup;
using Abp.Localization.Dictionaries;
using Abp.Localization.Dictionaries.Xml;
using Abp.Reflection.Extensions;

namespace GiuaKi.Localization;

public static class GiuaKiLocalizationConfigurer
{
    public static void Configure(ILocalizationConfiguration localizationConfiguration)
    {
        localizationConfiguration.Sources.Add(
            new DictionaryBasedLocalizationSource(GiuaKiConsts.LocalizationSourceName,
                new XmlEmbeddedFileLocalizationDictionaryProvider(
                    typeof(GiuaKiLocalizationConfigurer).GetAssembly(),
                    "GiuaKi.Localization.SourceFiles"
                )
            )
        );
    }
}
