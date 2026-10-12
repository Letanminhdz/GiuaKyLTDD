using Abp.AspNetCore.Mvc.ViewComponents;

namespace GiuaKi.Web.Views;

public abstract class GiuaKiViewComponent : AbpViewComponent
{
    protected GiuaKiViewComponent()
    {
        LocalizationSourceName = GiuaKiConsts.LocalizationSourceName;
    }
}
