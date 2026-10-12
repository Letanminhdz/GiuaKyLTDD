using Abp.AspNetCore.Mvc.Authorization;
using GiuaKi.Controllers;
using Microsoft.AspNetCore.Mvc;
using System;

namespace GiuaKi.Web.Controllers;

[AbpMvcAuthorize]
public class HomeController : GiuaKiControllerBase
{
    public ActionResult Index()
    {
        // Phân quyền chuyển hướng thông minh theo tài khoản
        if (User.Identity?.Name?.Equals("user", StringComparison.OrdinalIgnoreCase) == true)
        {
            return RedirectToAction("Catalog", "Student");
        }

        return RedirectToAction("Index", "Exam");
    }
}
