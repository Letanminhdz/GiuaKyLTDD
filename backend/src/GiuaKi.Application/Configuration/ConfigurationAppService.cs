using Abp.Authorization;
using Abp.Runtime.Session;
using GiuaKi.Configuration.Dto;
using System.Threading.Tasks;

namespace GiuaKi.Configuration;

[AbpAuthorize]
public class ConfigurationAppService : GiuaKiAppServiceBase, IConfigurationAppService
{
    public async Task ChangeUiTheme(ChangeUiThemeInput input)
    {
        await SettingManager.ChangeSettingForUserAsync(AbpSession.ToUserIdentifier(), AppSettingNames.UiTheme, input.Theme);
    }
}
