using Abp.AspNetCore.Mvc.Authorization;
using GiuaKi.Controllers;
using Microsoft.AspNetCore.Mvc;

namespace GiuaKi.Web.Controllers;

[AbpMvcAuthorize]
public class AboutController : GiuaKiControllerBase
{
    public ActionResult Index()
    {
        return View();
    }
}
