using Abp.AspNetCore.Mvc.Views;
using Abp.Runtime.Session;
using Microsoft.AspNetCore.Mvc.Razor.Internal;

namespace GiuaKi.Web.Views;

public abstract class GiuaKiRazorPage<TModel> : AbpRazorPage<TModel>
{
    [RazorInject]
    public IAbpSession AbpSession { get; set; }

    protected GiuaKiRazorPage()
    {
        LocalizationSourceName = GiuaKiConsts.LocalizationSourceName;
    }
}
