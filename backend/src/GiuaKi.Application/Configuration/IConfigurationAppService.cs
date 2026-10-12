using GiuaKi.Configuration.Dto;
using System.Threading.Tasks;

namespace GiuaKi.Configuration;

public interface IConfigurationAppService
{
    Task ChangeUiTheme(ChangeUiThemeInput input);
}
