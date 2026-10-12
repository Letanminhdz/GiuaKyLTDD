using Abp.AspNetCore.Mvc.Controllers;
using Abp.IdentityFramework;
using Microsoft.AspNetCore.Identity;

namespace GiuaKi.Controllers
{
    public abstract class GiuaKiControllerBase : AbpController
    {
        protected GiuaKiControllerBase()
        {
            LocalizationSourceName = GiuaKiConsts.LocalizationSourceName;
        }

        protected void CheckErrors(IdentityResult identityResult)
        {
            identityResult.CheckErrors(LocalizationManager);
        }
    }
}
